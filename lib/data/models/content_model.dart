import '../../domain/entities/content_entity.dart';

class ContentModel extends ContentEntity {
  const ContentModel({
    required int slideNumber,
    required String arabicText,
    required String copticTransliteratedText,
  }) : super(
          slideNumber: slideNumber,
          arabicText: arabicText,
          copticTransliteratedText: copticTransliteratedText,
        );

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      slideNumber: json['slide_number'] ?? 0,
      arabicText: json['arabic_text'] ?? '',
      copticTransliteratedText: json['coptic_transliterated_text'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slide_number': slideNumber,
      'arabic_text': arabicText,
      'coptic_transliterated_text': copticTransliteratedText,
    };
  }
}