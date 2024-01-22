import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lexigenai_app/src/model/text_generate.dart';

enum TextGenerateState { idle, success, error, loading }

class TextGenerateService extends ChangeNotifier {
  TextGenerateState state = TextGenerateState.idle;
  List<TextGenerate> generatedTexts = [];
  String lastQuestion = '';

  Future<void> getAnswers({required String question}) async {
    try {
      state = TextGenerateState.loading;
      generatedTexts.clear();
      lastQuestion = '';
      notifyListeners();

      final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
      final body = {"text": question};
      final response = await http.post(
        Uri.parse('http://localhost:8080/texts'),
        body: jsonEncode(body),
        headers: headers,
      );

      final int statusCode = response.statusCode;

      if (statusCode == 200) {
        List<dynamic> responseList =
            json.decode(const Utf8Decoder().convert(response.bodyBytes));
        for (var element in responseList) {
          generatedTexts.add(TextGenerate.fromJson(element));
        }
        lastQuestion = question;
        state = TextGenerateState.success;
      } else {
        generatedTexts.add(TextGenerate(text: response.body));
        state = TextGenerateState.error;
      }
      notifyListeners();
    } catch (_) {
      state = TextGenerateState.error;
      notifyListeners();
    }
  }
}
