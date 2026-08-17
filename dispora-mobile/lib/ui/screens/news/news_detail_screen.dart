import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../features/news/models/news_model.dart';
import '../../theme/app_colors.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsModel news;

  const NewsDetailScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.putihHangat,
      extendBodyBehindAppBar: true, // App bar transparan menimpa gambar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Hero Image
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: _buildHeroImage(),
                ),
                Container(
                  height: 24,
                  decoration: const BoxDecoration(
                    color: AppColors.putihBersih,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                ),
              ],
            ),
            // 2. Konten Berita
            Container(
              width: double.infinity,
              color: AppColors.putihBersih,
              padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tag Kategori (Pill)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.blushCream,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      'Kabar DISPORA',
                      style: GoogleFonts.poppins(
                        color: AppColors.merahBata,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Judul Berita
                  Text(
                    news.title,
                    style: GoogleFonts.poppins(
                      color: AppColors.cokelatTua,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Tanggal
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.mutedBrown),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('dd MMMM yyyy', 'id_ID').format(news.createdAt),
                        style: GoogleFonts.poppins(
                          color: AppColors.mutedBrown,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: AppColors.borderCream),
                  const SizedBox(height: 20),

                  // Isi Berita
                  Text(
                    news.content,
                    style: GoogleFonts.poppins(
                      color: AppColors.cokelatTua,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroImage() {
    if (news.thumbnailUrl != null && news.thumbnailUrl!.isNotEmpty) {
      return Image.network(
        news.thumbnailUrl!,
        fit: BoxFit.fitWidth,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey.shade300,
            height: 250,
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.merahBata),
            ),
          );
        },
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey.shade300,
      height: 250,
      child: const Center(
        child: Icon(Icons.image, color: Colors.grey, size: 64),
      ),
    );
  }
}
