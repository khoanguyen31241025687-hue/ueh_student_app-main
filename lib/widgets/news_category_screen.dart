import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routers/app_router.dart';
import 'news_category_data.dart';
import 'news_screen.dart';

class CategoryArticle {
  const CategoryArticle({
    required this.title,
    required this.date,
    required this.sdgs,
    this.id,
    this.imageAsset,
  });

  // Mã bài trên ueh.edu.vn, nội dung ở assets/news_html/<id>.html; null = bài mẫu.
  final String? id;
  final String title;
  final String date;
  // Số hiệu mục tiêu SDG (1-17), ứng với assets/images/sdg/sdg_<n>.png.
  final List<int> sdgs;
  final String? imageAsset;
}

// Bài viết thật lấy từ ueh.edu.vn theo chuyên mục; chuyên mục chưa có thì dùng dữ liệu mẫu.
const _realArticles = <String, List<CategoryArticle>>{
  'CUỘC SỐNG UEH': cuocSongUehArticles,
};

CategoryArticle? findArticle(String category, String id) {
  for (final article in _realArticles[category] ?? const <CategoryArticle>[]) {
    if (article.id == id) return article;
  }
  return null;
}

// Nguồn dữ liệu có phân trang, thay bằng API/DB khi có.
class _MockArticleSource {
  _MockArticleSource(String category) : _real = _realArticles[category];

  static const _totalItems = 57;
  final List<CategoryArticle>? _real;

  static const _titles = [
    'Lễ tốt nghiệp UEH - Tôn vinh hành trình tri thức',
    'Sinh viên UEH ra quân chiến dịch Mùa hè xanh',
    'UEH Go Green: Chung tay giảm rác thải nhựa trong khuôn viên',
    'Hội thảo khởi nghiệp sáng tạo dành cho sinh viên',
    'Ngày hội việc làm UEH kết nối hơn 100 doanh nghiệp',
    'Chương trình học bổng tiếp sức đến trường năm học mới',
    'Giải bóng đá sinh viên UEH mở rộng khép lại thành công',
    'Tọa đàm bình đẳng giới trong môi trường đại học',
  ];

  Future<List<CategoryArticle>> fetchPage(int page, int pageSize) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final start = page * pageSize;
    final real = _real;
    if (real != null) {
      if (start >= real.length) return const [];
      return real.sublist(start, (start + pageSize).clamp(0, real.length));
    }
    if (start >= _totalItems) return const [];
    final end = (start + pageSize).clamp(0, _totalItems);
    return [
      for (var i = start; i < end; i++)
        CategoryArticle(
          title: _titles[i % _titles.length],
          date: '${28 - i % 28} tháng 09 năm 2026',
          sdgs: [for (var k = 0; k < 1 + i % 4; k++) (i * 5 + k * 3) % 17 + 1],
        ),
    ];
  }
}

class NewsCategoryScreen extends StatefulWidget {
  const NewsCategoryScreen({super.key, required this.category});

  final String category;

  @override
  State<NewsCategoryScreen> createState() => _NewsCategoryScreenState();
}

class _NewsCategoryScreenState extends State<NewsCategoryScreen> {
  static const _pageSize = 10;
  // Còn cách cuối danh sách bao nhiêu px thì tải trang kế tiếp.
  static const _loadMoreThreshold = 300.0;

  late final _source = _MockArticleSource(widget.category);
  final _scrollController = ScrollController();
  final _articles = <CategoryArticle>[];

  int _nextPage = 0;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadMore();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - _loadMoreThreshold) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoading || !_hasMore) return;
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      final items = await _source.fetchPage(_nextPage, _pageSize);
      if (!mounted) return;
      setState(() {
        _articles.addAll(items);
        _nextPage++;
        _hasMore = items.length == _pageSize;
      });
    } catch (_) {
      if (mounted) setState(() => _hasError = true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _articles.clear();
      _nextPage = 0;
      _hasMore = true;
    });
    await _loadMore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: newsAppBar(context),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                child: Text(
                  categoryTitle(widget.category),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                    color: NewsScreen.orangeColor,
                  ),
                ),
              ),
            ),
            if (_articles.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                // Khung viền bao quanh cả danh sách bài viết.
                sliver: DecoratedSliver(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  sliver: SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    sliver: SliverList.separated(
                      itemCount: _articles.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final article = _articles[index];
                        return _ArticleTile(
                          article: article,
                          onTap: article.id == null
                              ? null
                              : () => context.push(
                                  Uri(
                                    path: AppRoutes.newsArticle,
                                    queryParameters: {
                                      'category': widget.category,
                                      'id': article.id,
                                    },
                                  ).toString(),
                                ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            SliverToBoxAdapter(child: _buildFooter()),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_hasError) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Center(
          child: TextButton.icon(
            onPressed: _loadMore,
            icon: const Icon(Icons.refresh),
            label: const Text('Không tải được, thử lại'),
          ),
        ),
      );
    }
    if (!_hasMore) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            _articles.isEmpty
                ? 'Chưa có bài viết'
                : 'Đã hiển thị tất cả bài viết',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

// 'CUỘC SỐNG UEH' -> 'Cuộc sống UEH', 'KHOA HỌC - GÓC NHÌN CHUYÊN GIA'
// -> 'Khoa học - Góc nhìn chuyên gia' (giữ nguyên chữ UEH).
String categoryTitle(String text) {
  final lower = text.toLowerCase().replaceAll('ueh', 'UEH');
  return lower
      .split(' - ')
      .map(
        (part) =>
            part.isEmpty ? part : part[0].toUpperCase() + part.substring(1),
      )
      .join(' - ');
}

// AppBar chung cho các trang tin: chỉ có nút quay lại, tên chuyên mục đặt trong nội dung.
PreferredSizeWidget newsAppBar(BuildContext context) => AppBar(
  backgroundColor: const Color(0xFF005F69),
  foregroundColor: Colors.white,
  leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    tooltip: 'Quay lại',
    onPressed: () => context.canPop() ? context.pop() : context.go('/home'),
  ),
);

// Màu tiêu đề bài viết trong danh sách và trang chi tiết.
const newsTitleColor = Color(0xFF1F6F7C);

class _ArticleTile extends StatelessWidget {
  const _ArticleTile({required this.article, this.onTap});

  final CategoryArticle article;
  final VoidCallback? onTap;

  static const _thumbSize = 96.0;
  static const _sdgSize = 22.0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox.square(
                dimension: _thumbSize,
                child: article.imageAsset == null
                    ? ColoredBox(color: Colors.grey.shade300)
                    : Image.asset(
                        article.imageAsset!,
                        fit: BoxFit.cover,
                        cacheWidth: 300,
                      ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.date,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 6),
                  SdgIcons(sdgs: article.sdgs, size: _sdgSize),
                  const SizedBox(height: 8),
                  Text(
                    article.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                      color: newsTitleColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SdgIcons extends StatelessWidget {
  const SdgIcons({super.key, required this.sdgs, required this.size});

  final List<int> sdgs;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        for (final sdg in sdgs)
          Tooltip(
            message: 'SDG $sdg',
            child: Image.asset(
              'assets/images/sdg/sdg_$sdg.png',
              width: size,
              height: size,
              cacheWidth: (size * 3).round(),
            ),
          ),
      ],
    );
  }
}
