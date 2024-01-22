import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/image_generate.dart';

enum ImageGenerateState { idle, success, error, loading }

class ImageGenerateService extends ChangeNotifier {
  ImageGenerateState state = ImageGenerateState.idle;
  List<ImageGenerate> generatedImages = [];
  String lastGeneratedImage = '';

  Future<void> getImages(
      {required String imageTitle, required int total}) async {
    try {
      state = ImageGenerateState.loading;
      generatedImages.clear();
      lastGeneratedImage = '';
      notifyListeners();

      final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
      final body = {"text": imageTitle, "number": total};
      final response = await http.post(
        Uri.parse('http://localhost:8080/images'),
        body: jsonEncode(body),
        headers: headers,
      );

      final int statusCode = response.statusCode;

      if (statusCode == 200) {
        List<dynamic> responseList =
            json.decode(const Utf8Decoder().convert(response.bodyBytes));
        for (var element in responseList) {
          generatedImages.add(ImageGenerate.fromJson(element));
        }
        lastGeneratedImage = imageTitle;
        state = ImageGenerateState.success;
      } else if (statusCode == 400) {
        generatedImages.add(ImageGenerate(url: 'Unavailable service...'));
        state = ImageGenerateState.error;
      } else {
        generatedImages.add(ImageGenerate(url: response.body));
        state = ImageGenerateState.error;
      }
      notifyListeners();
    } catch (_) {
      state = ImageGenerateState.error;
      notifyListeners();
    }
  }
}
