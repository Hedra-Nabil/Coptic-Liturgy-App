import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/utils/app_state_manager.dart';
import '../../core/utils/constants.dart';
import '../../domain/entities/content_entity.dart';
import '../../domain/repositories/content_repository.dart';
import '../../domain/usecases/get_content_usecase.dart';
import '../../data/repositories/content_repository_impl.dart';
import '../../data/datasources/content_local_data_source.dart';

class ContentPage extends StatefulWidget {
  final String title;
  final String jsonFile;

  const ContentPage({Key? key, required this.title, required this.jsonFile})
    : super(key: key);

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  late Future<List<ContentEntity>> _contentFuture;
  late GetContentUseCase _getContentUseCase;

  @override
  void initState() {
    super.initState();
    final contentDataSource = ContentLocalDataSourceImpl();
    final contentRepository = ContentRepositoryImpl(contentDataSource);
    _getContentUseCase = GetContentUseCase(contentRepository);
    _contentFuture = _getContentUseCase.execute(widget.jsonFile);
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateManager>(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: FutureBuilder<List<ContentEntity>>(
        future: _contentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('لا يوجد محتوى'));
          }

          final content = snapshot.data!;
          return ContentListView(
            contentList: content,
            isDarkMode: appState.isDarkMode,
            fontSize: appState.fontSize,
            currentFile: widget.jsonFile,
          );
        },
      ),
    );
  }
}

class ContentListView extends StatefulWidget {
  final List<ContentEntity> contentList;
  final bool isDarkMode;
  final double fontSize;
  final String currentFile;

  const ContentListView({
    Key? key,
    required this.contentList,
    required this.isDarkMode,
    required this.fontSize,
    required this.currentFile,
  }) : super(key: key);

  @override
  State<ContentListView> createState() => _ContentListViewState();
}

class _ContentListViewState extends State<ContentListView> {
  final ScrollController _scrollController = ScrollController();
  late final FocusNode _focusNode;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    // Add keyboard listeners for navigation
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _navigateToNextFile();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _navigateToPreviousFile();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        _scrollController.animateTo(
          _scrollController.position.pixels + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        _scrollController.animateTo(
          _scrollController.position.pixels - 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _navigateToNextFile() {
    // This would be implemented to navigate to the next JSON file
    // For now, just show a message
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('الانتقال إلى الملف التالي')));
  }

  void _navigateToPreviousFile() {
    // This would be implemented to navigate to the previous JSON file
    // For now, just show a message
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('الانتقال إلى الملف السابق')));
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _handleKeyEvent,
      autofocus: true,
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            // Swiped right
            _navigateToPreviousFile();
          } else if (details.primaryVelocity! < 0) {
            // Swiped left
            _navigateToNextFile();
          }
        },
        child: ListView.builder(
          controller: _scrollController,
          itemCount: widget.contentList.length,
          itemBuilder: (context, index) {
            return ContentSlide(
              content: widget.contentList[index],
              isDarkMode: widget.isDarkMode,
              fontSize: widget.fontSize,
            );
          },
        ),
      ),
    );
  }
}

class ContentSlide extends StatefulWidget {
  final ContentEntity content;
  final bool isDarkMode;
  final double fontSize;

  const ContentSlide({
    Key? key,
    required this.content,
    required this.isDarkMode,
    required this.fontSize,
  }) : super(key: key);

  @override
  State<ContentSlide> createState() => _ContentSlideState();
}

class _ContentSlideState extends State<ContentSlide> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Collapsible slide number
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              // padding: const EdgeInsets.symmetric(
              //   horizontal: 16.0,
              //   vertical: 8.0,
              // ),
              // decoration: BoxDecoration(
              //   color: widget.isDarkMode ? Colors.grey[800] : Colors.grey[200],
              //   // borderRadius: BorderRadius.circular(20.0),
              // ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: widget.fontSize,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    'شريحة ${widget.content.slideNumber}',
                    style: TextStyle(
                      fontSize: widget.fontSize - AppConstants.fontSizeStep,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Content section
          if (_isExpanded) const SizedBox(height: 16.0),
          if (_isExpanded)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Coptic text on the left side
                  Expanded(
                    child:
                        widget.content.copticTransliteratedText.isNotEmpty
                            ? SelectableText(
                              widget.content.copticTransliteratedText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: widget.fontSize,
                                height: 1.5,
                                color:
                                    widget.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                              ),
                            )
                            : const SizedBox(),
                  ),
                  // Vertical divider in the middle
                  VerticalDivider(
                    width: 16.0,
                    thickness: 1.0,
                    color: widget.isDarkMode ? Colors.white30 : Colors.black12,
                  ),
                  // Arabic text on the right side
                  Expanded(
                    child:
                        widget.content.arabicText.isNotEmpty
                            ? SelectableText(
                              widget.content.arabicText,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontSize: widget.fontSize,
                                height: 1.5,
                                color:
                                    widget.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                              ),
                            )
                            : const SizedBox(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
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
    final provider =
        context
                .getElementForInheritedWidgetOfExactType<
                  ContentRepositoryProvider
                >()
                ?.widget
            as ContentRepositoryProvider?;
    if (provider == null) {
      throw FlutterError('ContentRepositoryProvider not found in context');
    }
    return provider.repository;
  }

  @override
  bool updateShouldNotify(ContentRepositoryProvider oldWidget) {
    return repository != oldWidget.repository;
  }
}
