import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routers/app_router.dart';

class NewsItem {
  const NewsItem({
    required this.category,
    required this.title,
    this.imageAsset,
  });

  final String category;
  final String title;
  final String? imageAsset;
}

// Dữ liệu lấy từ https://www.ueh.edu.vn/tin-tuc, thay bằng API/DB khi có.
const _featuredNews = NewsItem(
  category: 'TIN TỨC NỔI BẬT',
  title: '[UEH 50 năm] 8 giá trị được đánh thức – Nội lực UEH được tiếp nối',
  imageAsset: 'assets/images/ueh-50-nam-banner.jpg',
);

const _latestNews = <NewsItem>[
  NewsItem(
    category: 'CUỘC SỐNG UEH',
    title: '[UEH Alumni - Ngày trở về] UEH Alumni Co-Creation Showcase 2026: Điểm hẹn giao thương, công nghệ và sáng kiến bền vững',
  ),
  NewsItem(
    category: 'KHOA HỌC - GÓC NHÌN CHUYÊN GIA',
    title: '[UEH 50] UEH tổ chức Hội thảo khoa học: “Phát triển nguồn nhân lực chất lượng cao - Nền tảng cho tái cấu trúc các tỉnh vùng Đồng bằng sông Cửu Long giai đoạn sau sáp nhập”',
  ),
  NewsItem(
    category: 'BÁO CHÍ NÓI VỀ UEH',
    title: '8 ngành học ‘khát’ nhân lực toàn cầu tại UEH',
  ),
  NewsItem(
    category: 'TUYỂN SINH & HƯỚNG NGHIỆP',
    title: '[Unbox Glo-cal Program] Từ bài toán bảo hiểm Việt Nam đến sân chơi quốc tế: Hành trình Glo-cal của sinh viên Khoa Tài chính UEH',
  ),
  NewsItem(
    category: 'UEH NEXUS NHA TRANG',
    title: 'RTD 2026 tại Khánh Hòa: Từ AI, công nghệ đại dương đến kinh tế biển xanh - Đồng kiến tạo tương lai bền vững',
  ),
  NewsItem(
    category: 'KHOA HỌC - GÓC NHÌN CHUYÊN GIA',
    title: 'New UEH Publications Alert (Tuần 3 - Tháng 09/2026): Giải mã cơ chế vận hành từ tâm lý hành vi, trí tuệ nhân tạo đến tài chính khí hậu',
  ),
  NewsItem(
    category: 'BÁO CHÍ NÓI VỀ UEH',
    title: 'QS Sustainability và THE Impact trong quản trị đại học bền vững',
  ),
  NewsItem(
    category: 'TUYỂN SINH & HƯỚNG NGHIỆP',
    title: '[UEH 50] 50+ Lớp học Glo-cal truyền cảm hứng: Lớp học ArtTech cùng nghệ sĩ VR Minh Hằng, mở rộng biên độ sáng tạo thông qua công nghệ và nghệ thuật',
  ),
  NewsItem(
    category: 'UEH NEXUS NHA TRANG',
    title: '[UEH CONFERENCE 50] Khai mạc Hội thảo Khoa học Quốc tế RTD 2026: Định hình “FutureScape” - Tầm nhìn Công nghệ và Thiết kế vì một tương lai bền vững',
  ),
  NewsItem(
    category: 'CUỘC SỐNG UEH',
    title: '[TRỰC TIẾP] Lễ tốt nghiệp UEH - Chiều ngày 27/9/2026',
  ),
  NewsItem(
    category: 'KHOA HỌC - GÓC NHÌN CHUYÊN GIA',
    title: '[HCMC Beyond - Tập 2]: Làm chủ công nghệ, đồng kiến tạo Thành phố tương lai',
  ),
  NewsItem(
    category: 'BÁO CHÍ NÓI VỀ UEH',
    title: 'Đại học Kinh tế TP.HCM: QS và THE trong bức tranh quản trị đại học',
  ),
  NewsItem(
    category: 'TUYỂN SINH & HƯỚNG NGHIỆP',
    title: 'Thông báo xét tuyển bổ sung Khóa 52 – Đại học chính quy năm 2026 học tại Vĩnh Long (UEH Mekong)',
  ),
  NewsItem(
    category: 'UEH NEXUS NHA TRANG',
    title: 'Công bố Quy hoạch tổng mặt bằng dự án Trung tâm Đổi mới sáng tạo và Khởi nghiệp thanh niên tại phường Nam Nha Trang, tỉnh Khánh Hòa',
  ),
  NewsItem(
    category: 'CUỘC SỐNG UEH',
    title: '[TRỰC TIẾP] Lễ tốt nghiệp UEH - Sáng ngày 27/9/2026',
  ),
  NewsItem(
    category: 'KHOA HỌC - GÓC NHÌN CHUYÊN GIA',
    title: 'New UEH Publications Alert (Tuần 2 - Tháng 09/2026): Hướng tới “Chuyển đổi kép” – Công bố quốc tế UEH giải mã sự giao thoa giữa pháp lý, công nghệ số, tài chính và phát triển bền vững',
  ),
  NewsItem(
    category: 'BÁO CHÍ NÓI VỀ UEH',
    title:
        'UEH: Bảng xếp hạng là công cụ nâng cấp dài hạn, thứ hạng là ngắn hạn',
  ),
  NewsItem(
    category: 'TUYỂN SINH & HƯỚNG NGHIỆP',
    title: '[Unbox Glo-cal Class] Lớp học Dự án Nghệ thuật và Văn hóa: Khi công nghệ sáng tạo làm sống dậy di sản làng nghề hoa giấy truyền thông',
  ),
  NewsItem(
    category: 'UEH NEXUS NHA TRANG',
    title: 'Alumni Day Khánh Hòa 2026: Dấu mốc kết nối cộng đồng UEHers tại Nam Trung Bộ - Tây Nguyên',
  ),
];

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  static const orangeColor = Color(0xFFF26F21);
  static const slateColor = Color(0xFF4F6D82);

  @override
  Widget build(BuildContext context) {
    // Container > Column: tiêu đề, khối nổi bật (Stack), danh sách tin (Text/Text).
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Tin tức',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: orangeColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Thông tin mới nhất và kiến thức hữu ích từ UEH',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            const _FeaturedNews(news: _featuredNews),
            for (final news in _latestNews) _NewsCard(news: news),
          ],
        ),
      ),
    );
  }
}

BoxDecoration _cardDecoration() => BoxDecoration(
  color: Colors.white,
  boxShadow: [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.15),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ],
);

class _FeaturedNews extends StatelessWidget {
  const _FeaturedNews({required this.news});

  final NewsItem news;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: _cardDecoration(),
      // Stack: ảnh nền, lớp chữ phủ lên đáy ảnh, trên cùng là vùng chạm.
      child: Stack(
        children: [
          // Ảnh gốc 6247x2501 khá dẹt, cắt giữa cho đủ chỗ phủ chữ; cacheWidth giảm bộ nhớ giải mã.
          SizedBox(
            width: double.infinity,
            height: 240,
            child: Image.asset(
              news.imageAsset!,
              fit: BoxFit.cover,
              cacheWidth: 1200,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 28, 12, 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    NewsScreen.slateColor.withValues(alpha: 0),
                    NewsScreen.slateColor.withValues(alpha: 0.9),
                    NewsScreen.slateColor,
                  ],
                  stops: const [0, 0.35, 1],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    news.category,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    news.title,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(onTap: () {}),
            ),
          ),
        ],
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  const _NewsCard({required this.news});

  final NewsItem news;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chạm vào chuyên mục để mở danh sách bài viết của chuyên mục đó.
          InkWell(
            onTap: () => context.push(
              Uri(
                path: AppRoutes.newsCategory,
                queryParameters: {'name': news.category},
              ).toString(),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                news.category,
                style: const TextStyle(
                  color: NewsScreen.orangeColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            news.title,
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
