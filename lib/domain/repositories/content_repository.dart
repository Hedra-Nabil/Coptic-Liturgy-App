import '../entities/content_entity.dart';

abstract class ContentRepository {
  Future<List<ContentEntity>> getContentFromJson(String jsonFile);
}