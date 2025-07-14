import '../entities/content_entity.dart';
import '../repositories/content_repository.dart';

class GetContentUseCase {
  final ContentRepository repository;

  GetContentUseCase(this.repository);

  Future<List<ContentEntity>> execute(String jsonFile) {
    return repository.getContentFromJson(jsonFile);
  }
}