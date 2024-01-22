import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lexigenai_app/src/component/app_button.dart';
import 'package:lexigenai_app/src/component/loading_dialog.dart';
import 'package:lexigenai_app/src/service/image_generate_service.dart';
import 'package:provider/provider.dart';

class TabImage extends StatefulWidget {
  const TabImage({Key? key}) : super(key: key);

  @override
  State<TabImage> createState() => _TabImageState();
}

class _TabImageState extends State<TabImage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController controllerTitle = TextEditingController();
  TextEditingController controllerTotal = TextEditingController(text: '1');

  @override
  void initState() {
    super.initState();

    final service = context.read<ImageGenerateService>();

    service.addListener(() {
      if (service.state == ImageGenerateState.loading) {
        showLoadingDialog(context: context, text: "Getting images...");
      } else if (service.state == ImageGenerateState.error) {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to get response'),
          backgroundColor: Colors.redAccent,
        ));
      } else if (service.state == ImageGenerateState.success) {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Image received'),
          backgroundColor: Colors.green,
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<ImageGenerateService>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        vertical: 25,
        horizontal: 15,
      ),
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: controllerTitle,
                decoration: const InputDecoration(
                  hintText: 'Tell your image',
                  labelText: 'What image do you want to generate?',
                  labelStyle: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blueGrey,
                      width: 3.0,
                    ),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 20,
                ),
                keyboardType: TextInputType.text,
                autocorrect: true,
                maxLength: 200,
                maxLines: 2,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Image not informed';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: controllerTotal,
                decoration: const InputDecoration(
                  hintText: 'Total of images',
                  labelText: 'Total Images?',
                  labelStyle: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blueGrey,
                      width: 3.0,
                    ),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 20,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (value) {
                  if (value!.isEmpty || int.parse(value!) <= 0) {
                    return 'Number not informed';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppButton(
                      title: 'Get Images',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          service.getImages(
                              imageTitle: controllerTitle.text,
                              total: int.parse(controllerTotal.text));
                        }
                      }),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 15,
                ),
                child: Divider(
                  thickness: 2,
                ),
              ),
              Consumer<ImageGenerateService>(
                builder: (context, service, _) {
                  if (service.lastGeneratedImage.isEmpty) {
                    return Container();
                  }
                  return Column(
                    children: [
                      Text(
                        service.lastGeneratedImage,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                    ],
                  );
                },
              ),
              Consumer<ImageGenerateService>(
                builder: (context, service, _) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: service.generatedImages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: CachedNetworkImage(
                          progressIndicatorBuilder: (context, url, progress) =>
                              Center(
                            child: CircularProgressIndicator(
                              value: progress.progress,
                            ),
                          ),
                          imageUrl: service.generatedImages[index].url,
                        ),
                        leading: IconButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(
                                    text: service.generatedImages[index].url))
                                .then((result) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('URL copied'),
                                backgroundColor: Colors.green,
                              ));
                            });
                          },
                          icon: const Icon(
                            Icons.copy,
                            color: Colors.blueGrey,
                            size: 20,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          )),
    );
  }
}
