import 'package:flutter/material.dart';
import '../../data/datasources/content_local_data_source.dart';
import '../../data/datasources/menu_local_data_source.dart';
import '../../data/repositories/content_repository_impl.dart';
import '../../data/repositories/menu_repository_impl.dart';
import '../../domain/repositories/content_repository.dart';
import '../../domain/repositories/menu_repository.dart';
import '../../domain/usecases/get_content_usecase.dart';
import '../../domain/usecases/get_menu_items_usecase.dart';

class DependencyInjection {
  static final DependencyInjection _instance = DependencyInjection._internal();

  factory DependencyInjection() => _instance;

  DependencyInjection._internal();

  // Data sources
  late ContentLocalDataSource contentLocalDataSource;
  late MenuLocalDataSource menuLocalDataSource;

  // Repositories
  late ContentRepository contentRepository;
  late MenuRepository menuRepository;

  // Use cases
  late GetContentUseCase getContentUseCase;
  late GetMenuItemsUseCase getMenuItemsUseCase;

  void init() {
    // Initialize data sources
    contentLocalDataSource = ContentLocalDataSourceImpl();
    menuLocalDataSource = MenuLocalDataSourceImpl();

    // Initialize repositories
    contentRepository = ContentRepositoryImpl(contentLocalDataSource);
    menuRepository = MenuRepositoryImpl(menuLocalDataSource);

    // Initialize use cases
    getContentUseCase = GetContentUseCase(contentRepository);
    getMenuItemsUseCase = GetMenuItemsUseCase(menuRepository);
  }

  Widget wrapWithRepositoryProviders(Widget child) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ContentRepository>(
          repository: contentRepository,
          child: Container(), // Placeholder, will be replaced in MultiRepositoryProvider
        ),
        RepositoryProvider<MenuRepository>(
          repository: menuRepository,
          child: Container(), // Placeholder, will be replaced in MultiRepositoryProvider
        ),
      ],
      child: child,
    );
  }
}

// Helper widgets for dependency injection
class RepositoryProvider<T> extends InheritedWidget {
  final T repository;

  const RepositoryProvider({
    Key? key,
    required this.repository,
    required Widget child,
  }) : super(key: key, child: child);

  static T of<T>(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<RepositoryProvider<T>>();
    if (provider == null) {
      throw Exception('RepositoryProvider<$T> not found in context');
    }
    return provider.repository;
  }

  @override
  bool updateShouldNotify(RepositoryProvider<T> oldWidget) {
    return repository != oldWidget.repository;
  }
}

class MultiRepositoryProvider extends StatelessWidget {
  final List<Widget> providers;
  final Widget child;

  const MultiRepositoryProvider({
    Key? key,
    required this.providers,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget result = child;
    for (int i = providers.length - 1; i >= 0; i--) {
      // Each provider in the list should be a RepositoryProvider that wraps the result
      if (providers[i] is RepositoryProvider) {
        final provider = providers[i] as RepositoryProvider;
        result = RepositoryProvider(
          repository: provider.repository,
          child: result,
        );
      }
    }
    return result;
  }
}