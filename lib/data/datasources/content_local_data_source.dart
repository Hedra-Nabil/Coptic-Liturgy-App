import 'dart:convert';
import 'package:flutter/services.dart';
import '../../core/utils/constants.dart';
import '../models/content_model.dart';

abstract class ContentLocalDataSource {
  Future<List<ContentModel>> getContentFromJson(String jsonFile);
}

class ContentLocalDataSourceImpl implements ContentLocalDataSource {
  @override
  Future<List<ContentModel>> getContentFromJson(String jsonFile) async {
    try {
      final String jsonString = await rootBundle.loadString('${AppConstants.assetsFilesPath}$jsonFile');
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((item) => ContentModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to load content: $e');
    }
  }
}