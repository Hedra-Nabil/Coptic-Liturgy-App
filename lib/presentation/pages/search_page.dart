import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/app_state_manager.dart';
import '../../core/utils/constants.dart';
import '../../domain/entities/content_entity.dart';
import '../../domain/repositories/content_repository.dart';
import '../../domain/usecases/get_content_usecase.dart';
import '../../data/repositories/content_repository_impl.dart';
import '../../data/datasources/content_local_data_source.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<SearchResult> _searchResults = [];
  bool _isSearching = false;
  late GetContentUseCase _getContentUseCase;

  @override
  void initState() {
    super.initState();
    final contentDataSource = ContentLocalDataSourceImpl();
    final contentRepository = ContentRepositoryImpl(contentDataSource);
    _getContentUseCase = GetContentUseCase(contentRepository);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults.clear();
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchResults.clear();
    });

    try {
      // Search in the main content files
      final filesToSearch = [
        AppConstants.liturgyDistributionFile,
        AppConstants.psalmodyFile,
        AppConstants.readingsFile,
        AppConstants.agpeyaFile,
      ];

      for (final file in filesToSearch) {
        final content = await _getContentUseCase.execute(file);
        final results = _searchInContent(content, query, file);
        if (results.isNotEmpty) {
          _searchResults.add(SearchResult(fileName: file, items: results));
        }
      }

      setState(() {
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء البحث: $e')),
      );
    }
  }

  List<SearchResultItem> _searchInContent(
    List<ContentEntity> content,
    String query,
    String fileName,
  ) {
    final results = <SearchResultItem>[];
    final lowerCaseQuery = query.toLowerCase();

    for (final item in content) {
      bool matchFound = false;
      String? matchText;

      if (item.arabicText != null &&
          item.arabicText!.toLowerCase().contains(lowerCaseQuery)) {
        matchFound = true;
        matchText = item.arabicText;
      } else if (item.copticTransliteratedText != null &&
          item.copticTransliteratedText!.toLowerCase().contains(lowerCaseQuery)) {
        matchFound = true;
        matchText = item.copticTransliteratedText;
      }

      if (matchFound && matchText != null) {
        results.add(
          SearchResultItem(
            content: item,
            matchText: matchText,
            fileName: fileName,
          ),
        );
      }
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('البحث'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ابحث عن...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              textDirection: TextDirection.rtl,
              onChanged: (value) {
                _performSearch(value);
              },
            ),
          ),
          Expanded(
            child: _isSearching
                ? const Center(child: CircularProgressIndicator())
                : _searchResults.isEmpty
                    ? Center(
                        child: _searchController.text.isEmpty
                            ? const Text('ابدأ البحث بكتابة كلمة أو عبارة')
                            : const Text('لا توجد نتائج'),
                      )
                    : ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final result = _searchResults[index];
                          return _buildSearchResultSection(result, appState);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultSection(
    SearchResult result,
    AppStateManager appState,
  ) {
    String displayFileName = result.fileName;
    
    // Map file names to display names
    if (result.fileName == AppConstants.liturgyDistributionFile) {
      displayFileName = 'القداسات';
    } else if (result.fileName == AppConstants.psalmodyFile) {
      displayFileName = 'التسبحة';
    } else if (result.fileName == AppConstants.readingsFile) {
      displayFileName = 'القراءات';
    } else if (result.fileName == AppConstants.agpeyaFile) {
      displayFileName = 'الأجبية';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            displayFileName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: result.items.length,
          itemBuilder: (context, index) {
            final item = result.items[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: ListTile(
                title: Text(
                  item.matchText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: appState.fontSize - AppConstants.fontSizeStep,
                  ),
                ),
                subtitle: item.content.slideNumber != null
                    ? Text('الشريحة ${item.content.slideNumber}')
                    : null,
                onTap: () {
                  // Navigate to content page with specific slide
                  // This would be implemented with your navigation system
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('سيتم الانتقال إلى المحتوى في الإصدار القادم'),
                    ),
                  );
                },
              ),
            );
          },
        ),
        const Divider(),
      ],
    );
  }
}

class SearchResult {
  final String fileName;
  final List<SearchResultItem> items;

  SearchResult({
    required this.fileName,
    required this.items,
  });
}

class SearchResultItem {
  final ContentEntity content;
  final String matchText;
  final String fileName;

  SearchResultItem({
    required this.content,
    required this.matchText,
    required this.fileName,
  });
}

// Temporary provider for dependency injection
class ContentRepositoryProvider extends InheritedWidget {
  final ContentRepository repository;

  const ContentRepositoryProvider({
    Key? key,
    required this.repository,
    required Widget child,
  }) : super(key: key, child: child);

  static ContentRepository of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<ContentRepositoryProvider>();
    return provider!.repository;
  }

  @override
  bool updateShouldNotify(ContentRepositoryProvider oldWidget) {
    return repository != oldWidget.repository;
  }
}