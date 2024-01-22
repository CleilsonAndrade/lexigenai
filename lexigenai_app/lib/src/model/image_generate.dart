class ImageGenerate {
  String url;

  ImageGenerate({
    required this.url,
  });

  factory ImageGenerate.fromJson(Map<String, dynamic> json) {
    return ImageGenerate(
      url: json['url'],
    );
  }
}
