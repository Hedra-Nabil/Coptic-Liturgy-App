import '../../core/utils/constants.dart';
import '../models/menu_item_model.dart';

abstract class MenuLocalDataSource {
  List<MenuItemModel> getMenuItems(String category);
}

class MenuLocalDataSourceImpl implements MenuLocalDataSource {
  final Map<String, List<Map<String, String>>> _menuData = {
    AppConstants.mainCategory: [
      {
        'title': AppConstants.liturgiesTitle,
        'image': '${AppConstants.assetsImagesPath}liturgies.png',
        'file': AppConstants.liturgyDistributionFile,
      },
      {
        'title': AppConstants.psalmodyTitle,
        'image': '${AppConstants.assetsImagesPath}psalmody.png',
        'file': AppConstants.psalmodyFile,
      },
      {
        'title': AppConstants.readingsTitle,
        'image': '${AppConstants.assetsImagesPath}readings.png',
        'file': AppConstants.readingsFile,
      },
      {
        'title': AppConstants.agpeyaTitle,
        'image': '${AppConstants.assetsImagesPath}agpeya.png',
        'file': AppConstants.agpeyaFile,
      },
    ],
    AppConstants.liturgiesCategory: [
      {
        'title': 'القداس الباسيلى',
        'image': '${AppConstants.assetsImagesPath}liturgies.png',
        'file': AppConstants.liturgyDistributionFile,
      },
      {
        'title': 'القداس الغروغورى',
        'image': '${AppConstants.assetsImagesPath}psalmody.png',
        'file': AppConstants.psalmodyFile,
      },
      {
        'title': 'القداس الكيرلسى',
        'image': '${AppConstants.assetsImagesPath}readings.png',
        'file': AppConstants.readingsFile,
      },
      {
        'title': 'التوزيع',
        'image': '${AppConstants.assetsImagesPath}agpeya.png',
        'file': AppConstants.agpeyaFile,
      },
    ],
  };

  @override
  List<MenuItemModel> getMenuItems(String category) {
    final items = _menuData[category] ?? [];
    return items.map((item) => MenuItemModel.fromJson(item)).toList();
  }
}