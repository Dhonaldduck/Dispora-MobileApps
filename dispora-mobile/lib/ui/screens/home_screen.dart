import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shimmer/shimmer.dart';

import '../../features/news/providers/news_provider.dart';
import '../../features/agenda/providers/agenda_provider.dart';
import '../../features/youth_services/providers/youth_service_provider.dart';
import '../../features/auth/providers/auth_provider.dart';
import 'auth/login_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _handleRestrictedAction(BuildContext context, WidgetRef ref, VoidCallback onAuthenticated) {
    final authState = ref.read(authProvider);
    if (authState.isGuest || !authState.isAuthenticated) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Perlu Login', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('Anda harus masuk (login) untuk mengakses fitur ini.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: const Text('Login Sekarang'),
            ),
          ],
        ),
      );
    } else {
      onAuthenticated();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final userName = authState.isGuest ? 'Tamu' : 'Sobat Olahraga';

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.sports_soccer, color: Color(0xFF1D4ED8)),
            const SizedBox(width: 8),
            const Text(
              'Dispora',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8)),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Color(0xFF1F2937)),
            onPressed: () {
              _handleRestrictedAction(context, ref, () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Menuju Halaman Profil...')));
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFFDC2626)),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(newsListProvider);
          ref.invalidate(agendaListProvider);
          ref.invalidate(youthServiceListProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo, $userName! 👋',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Temukan berita dan kegiatan terbaru hari ini.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              _buildSectionTitle('Berita Utama'),
              _buildNewsCarousel(ref),
              
              const SizedBox(height: 32),
              
              _buildSectionTitle('Agenda Terdekat'),
              _buildAgendaHorizontalList(ref),

              const SizedBox(height: 32),
              
              _buildSectionTitle('Layanan Kepemudaan'),
              _buildYouthServiceGrid(ref, context),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1F2937),
        ),
      ),
    );
  }

  Widget _buildNewsCarousel(WidgetRef ref) {
    final newsAsyncValue = ref.watch(newsListProvider);

    return newsAsyncValue.when(
      data: (newsList) {
        if (newsList.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text('Belum ada berita terbaru.', style: TextStyle(color: Colors.grey)),
          );
        }
        
        final headlineNews = newsList.take(3).toList(); // Take top 3
        
        return CarouselSlider(
          options: CarouselOptions(
            height: 200.0,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.85,
            aspectRatio: 16/9,
            initialPage: 0,
          ),
          items: headlineNews.map((news) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.grey.shade300,
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        news.thumbnailUrl != null
                            ? Image.network(
                                news.thumbnailUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 50, color: Colors.grey),
                              )
                            : const Icon(Icons.image, size: 50, color: Colors.grey),
                        
                        // Dark Gradient Overlay
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.transparent, Colors.black87],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        
                        // Text Overlay
                        Positioned(
                          bottom: 16.0,
                          left: 16.0,
                          right: 16.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Terbaru',
                                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                news.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
      loading: () => _buildCarouselShimmer(),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildAgendaHorizontalList(WidgetRef ref) {
    final agendaAsyncValue = ref.watch(agendaListProvider);

    return agendaAsyncValue.when(
      data: (agendaList) {
        if (agendaList.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text('Belum ada agenda terdekat.', style: TextStyle(color: Colors.grey)),
          );
        }
        
        return SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: agendaList.length,
            itemBuilder: (context, index) {
              final agenda = agendaList[index];
              final day = DateFormat('dd').format(agenda.startDate);
              final month = DateFormat('MMM').format(agenda.startDate);
              
              return Container(
                width: 280,
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0D000000), // Very light shadow
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Date Chip
                      Container(
                        width: 60,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              day,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                                height: 1.1,
                              ),
                            ),
                            Text(
                              month.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              agenda.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 14, color: Color(0xFF6B7280)),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    agenda.location,
                                    style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 14, color: Color(0xFF6B7280)),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat('HH:mm').format(agenda.startDate),
                                  style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
      loading: () => _buildHorizontalListShimmer(),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildYouthServiceGrid(WidgetRef ref, BuildContext context) {
    final serviceAsyncValue = ref.watch(youthServiceListProvider);

    return serviceAsyncValue.when(
      data: (serviceList) {
        if (serviceList.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text('Belum ada layanan.', style: TextStyle(color: Colors.grey)),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
            ),
            itemCount: serviceList.length,
            itemBuilder: (context, index) {
              final service = serviceList[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      _handleRestrictedAction(context, ref, () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Membuka detail layanan...')));
                      });
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getCategoryIcon(service.category),
                              size: 32,
                              color: Theme.of(context).colorScheme.tertiary, // Green for growth/health
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            service.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF1F2937),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            service.category,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
      loading: () => _buildGridShimmer(),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'olahraga':
        return Icons.sports_gymnastics;
      case 'kepemudaan':
        return Icons.groups;
      case 'kesehatan':
        return Icons.health_and_safety;
      default:
        return Icons.star_border;
    }
  }

  // --- Shimmer Loaders ---

  Widget _buildCarouselShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 200.0,
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }

  Widget _buildHorizontalListShimmer() {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        itemCount: 3,
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: 280,
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.9,
        ),
        itemCount: 4,
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}
