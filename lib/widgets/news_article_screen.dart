import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:url_launcher/url_launcher.dart';

import 'news_category_screen.dart';
import 'news_screen.dart';

// Chi tiết bài viết: tiêu đề, thời gian, SDG, rồi nội dung HTML lấy từ ueh.edu.vn.
class NewsArticleScreen extends StatefulWidget {
  const NewsArticleScreen({
    super.key,
    required this.category,
    required this.id,
  });

  final String category;
  final String id;

  @override
  State<NewsArticleScreen> createState() => _NewsArticleScreenState();
}

class _NewsArticleScreenState extends State<NewsArticleScreen> {
  late final _article = findArticle(widget.category, widget.id);
  late final Future<String> _html = rootBundle.loadString(
    'assets/news_html/${widget.id}.html',
  );

  Future<bool> _openUrl(String url) =>
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);

  @override
  Widget build(BuildContext context) {
    final article = _article;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: newsAppBar(context),
      body: article == null
          ? Center(
              child: Text(
                'Không tìm thấy bài viết',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            )
          : CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                  sliver: SliverToBoxAdapter(child: _buildHeader(article)),
                ),
                FutureBuilder<String>(
                  future: _html,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Text(
                            'Không tải được nội dung bài viết',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                      // sliverList dựng từng đoạn khi cuộn tới, bài dài vẫn mượt.
                      sliver: HtmlWidget(
                        snapshot.data!,
                        renderMode: RenderMode.sliverList,
                        textStyle: const TextStyle(fontSize: 15, height: 1.5),
                        onTapUrl: _openUrl,
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }

  Widget _buildHeader(CategoryArticle article) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          article.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            height: 1.35,
            color: newsTitleColor,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.access_time, size: 14, color: NewsScreen.slateColor),
            const SizedBox(width: 4),
            Text(
              article.date,
              style: const TextStyle(
                fontSize: 13,
                color: NewsScreen.slateColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SdgIcons(sdgs: article.sdgs, size: 40),
        const SizedBox(height: 8),
        const Divider(),
      ],
    );
  }
}
