class TextGenerate {
  String text;

  TextGenerate({
    required this.text,
  });

  factory TextGenerate.fromJson(Map<String, dynamic> json) {
    return TextGenerate(
      text: json['text'],
    );
  }
}
