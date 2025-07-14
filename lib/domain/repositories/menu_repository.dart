import '../entities/menu_item_entity.dart';

abstract class MenuRepository {
  List<MenuItemEntity> getMenuItems(String category);
}