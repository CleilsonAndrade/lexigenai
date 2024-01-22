import 'package:flutter/material.dart';
import 'package:lexigenai_app/src/component/app_button.dart';
import 'package:lexigenai_app/src/component/loading_dialog.dart';
import 'package:lexigenai_app/src/service/text_generate_service.dart';
import 'package:provider/provider.dart';

class TabText extends StatefulWidget {
  const TabText({Key? key}) : super(key: key);

  @override
  State<TabText> createState() => _TabTextState();
}

class _TabTextState extends State<TabText> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    final service = context.read<TextGenerateService>();

    service.addListener(() {
      if (service.state == TextGenerateState.loading) {
        showLoadingDialog(context: context, text: "Getting answers...");
      } else if (service.state == TextGenerateState.error) {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to get response'),
          backgroundColor: Colors.redAccent,
        ));
      } else if (service.state == TextGenerateState.success) {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Answer received'),
          backgroundColor: Colors.green,
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<TextGenerateService>(context);

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
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Tell your question',
                  labelText: 'What\'s your question?',
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
                maxLines: 3,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Question not informed';
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
                      title: 'Get Answers',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          service.getAnswers(question: controller.text);
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
              Consumer<TextGenerateService>(
                builder: (context, service, _) {
                  if (service.lastQuestion.isEmpty) {
                    return Container();
                  }
                  return Column(
                    children: [
                      Text(
                        service.lastQuestion,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                    ],
                  );
                },
              ),
              Consumer<TextGenerateService>(
                builder: (context, service, _) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: service.generatedTexts.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          service.generatedTexts[index].text,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          )),
    );
  }
}
