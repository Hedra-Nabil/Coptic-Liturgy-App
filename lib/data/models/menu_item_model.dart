import '../../domain/entities/menu_item_entity.dart';

class MenuItemModel extends MenuItemEntity {
  const MenuItemModel({
    required String title,
    required String imagePath,
    required String jsonFile,
  }) : super(
          title: title,
          imagePath: imagePath,
          jsonFile: jsonFile,
        );

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      title: json['title'] ?? '',
      imagePath: json['image'] ?? '',
      jsonFile: json['file'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'image': imagePath,
      'file': jsonFile,
    };
  }
}