import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../features/auth/providers/auth_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import 'auth/login_screen.dart';
import 'profile_screen.dart';
import '../../features/news/models/news_model.dart';
import 'news/news_detail_screen.dart';
import 'package:shimmer/shimmer.dart';
import '../../features/news/providers/news_provider.dart';
import '../../features/agenda/providers/agenda_provider.dart';
import 'agenda/agenda_detail_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  void _handleRestrictedAction(VoidCallback onAuthenticated) {
    final authState = ref.read(authProvider);
    if (authState.isGuest || !authState.isAuthenticated) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.putihBersih,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Perlu Login', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.cokelatTua)),
          content: const Text('Anda harus masuk (login) untuk mengakses fitur ini.', style: TextStyle(color: AppColors.mutedBrown)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: AppColors.mutedBrown)),
            ),
            ElevatedButton(
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.putihHangat,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 2) {
            // Tiket butuh login
            _handleRestrictedAction(() {
              setState(() => _currentIndex = index);
            });
          } else if (index == 3) {
            // Profil butuh login
            _handleRestrictedAction(() {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            });
          } else {
            setState(() => _currentIndex = index);
          }
        },
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(latestNewsProvider);
          },
          child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _Header(onNotificationTap: () => _handleRestrictedAction(() {})),
                const SizedBox(height: 24),
                const _HeroCard(),
                const SizedBox(height: 24),
                const _StatsAndQuickAccess(),
                const SizedBox(height: 32),
                const _AgendaSection(),
                const SizedBox(height: 32),
                const _NewsSection(),
                const SizedBox(height: 32),
                const _ReportBanner(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  final VoidCallback onNotificationTap;
  const _Header({super.key, required this.onNotificationTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Ambil state pengguna dari Riverpod
    final authState = ref.watch(authProvider);
    final user = authState.user;

    // 2. Ekstrak kata pertama dari nama untuk sapaan dinamis
    String greetingName = 'Sobat Olahraga!'; // Fallback standar

    if (user != null && user.fullName.trim().isNotEmpty) {
      // Mengambil kata pertama dari fullName
      final firstName = user.fullName.trim().split(RegExp(r'\s+')).first;
      greetingName = '$firstName!';
    } else if (authState.isGuest) {
      greetingName = 'Tamu!';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DISPORA SEMARANG',
              style: GoogleFonts.poppins(
                color: AppColors.merahBata,
                fontWeight: FontWeight.w600,
                fontSize: 11,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            // 3. Menampilkan sapaan dinamis
            Text(
              'Halo, $greetingName',
              style: GoogleFonts.poppins(
                color: AppColors.cokelatTua,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        InkWell(
          onTap: onNotificationTap,
          borderRadius: BorderRadius.circular(99),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.putihBersih,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderCream, width: 1),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.cokelatTua,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.merahBata,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1AA33A32),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Translucent watermark ornament
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              Icons.sports_soccer,
              size: 150,
              color: AppColors.putihBersih.withOpacity(0.08),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on, color: AppColors.putihBersih, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'KOTA SEMARANG',
                      style: GoogleFonts.poppins(
                        color: AppColors.putihBersih,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Ruang gerak\nuntuk Semarang\nyang aktif.',
                  style: GoogleFonts.poppins(
                    color: AppColors.pureWhite,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blushCream,
                    foregroundColor: AppColors.merahBata,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () {},
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Jelajahi fasilitas', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsAndQuickAccess extends StatelessWidget {
  const _StatsAndQuickAccess();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Stats Row
        Container(
          decoration: BoxDecoration(
            color: AppColors.putihBersih,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderCream),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatItem(value: '48', label: 'Fasilitas'),
              SizedBox(height: 40, child: VerticalDivider(color: AppColors.borderCream)),
              _StatItem(value: '12', label: 'Agenda aktif'),
              SizedBox(height: 40, child: VerticalDivider(color: AppColors.borderCream)),
              _StatItem(value: '6', label: 'Layanan pemuda'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Quick Access
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _QuickAccessItem(icon: Icons.stadium_outlined, label: 'Fasilitas', onTap: () {}),
            _QuickAccessItem(icon: Icons.event_note_outlined, label: 'Agenda', onTap: () {}),
            _QuickAccessItem(icon: Icons.directions_run_outlined, label: 'Atlet', onTap: () {}),
            _QuickAccessItem(icon: Icons.groups_outlined, label: 'Pemuda', onTap: () {}),
          ],
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.merahBata,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: AppColors.mutedBrown,
          ),
        ),
      ],
    );
  }
}

class _QuickAccessItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAccessItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.paleRed,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.merahBata,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.cokelatTua,
            ),
          ),
        ],
      ),
    );
  }
}

class _AgendaSection extends ConsumerWidget {
  const _AgendaSection();

  String _getMonthShort(int month) {
    const months = ['JAN', 'FEB', 'MAR', 'APR', 'MEI', 'JUN', 'JUL', 'AGU', 'SEP', 'OKT', 'NOV', 'DES'];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agendaAsync = ref.watch(agendaProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Agenda terdekat',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.cokelatTua,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Lihat semua',
                style: GoogleFonts.poppins(
                  color: AppColors.merahBata,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        agendaAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.merahBata)),
          error: (err, stack) => Center(child: Text('Gagal memuat agenda: $err', style: TextStyle(color: AppColors.merahBata))),
          data: (agendas) {
            if (agendas.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.putihBersih,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderCream),
                ),
                child: Text('Belum ada agenda terdekat', textAlign: TextAlign.center, style: GoogleFonts.poppins(color: AppColors.mutedBrown)),
              );
            }
            
            // Limit to 2 for preview
            final agendasToShow = agendas.take(2).toList();
            
            return Column(
              children: agendasToShow.map((agenda) {
                final date = agenda.startDate.day.toString();
                final month = _getMonthShort(agenda.startDate.month);
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.putihBersih,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderCream),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AgendaDetailScreen(agenda: agenda),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Date Badge
                              Container(
                                width: 56,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.blushCream,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      date,
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.merahBata,
                                        height: 1.0,
                                      ),
                                    ),
                                    Text(
                                      month,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.merahBata,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      agenda.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: AppColors.cokelatTua,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on_outlined, size: 14, color: AppColors.mutedBrown),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            agenda.location,
                                            style: GoogleFonts.poppins(fontSize: 12, color: AppColors.mutedBrown),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        const Icon(Icons.access_time, size: 14, color: AppColors.mutedBrown),
                                        const SizedBox(width: 4),
                                        Text(
                                          DateFormat('HH:mm').format(agenda.startDate) + ' WIB',
                                          style: GoogleFonts.poppins(fontSize: 12, color: AppColors.mutedBrown),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.chevron_right_rounded, color: AppColors.mutedBrown),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _NewsSection extends ConsumerWidget {
  const _NewsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsyncValue = ref.watch(latestNewsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Kabar DISPORA',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.cokelatTua,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Semua berita',
                style: GoogleFonts.poppins(
                  color: AppColors.merahBata,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        newsAsyncValue.when(
          loading: () => Column(
            children: [
              _buildShimmerCard(),
              const SizedBox(height: 12),
              _buildShimmerCard(),
            ],
          ),
          error: (error, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  const Icon(Icons.error_outline, color: AppColors.merahBata, size: 40),
                  const SizedBox(height: 8),
                  Text('Gagal memuat berita', style: GoogleFonts.poppins(color: AppColors.mutedBrown)),
                  TextButton(
                    onPressed: () => ref.invalidate(latestNewsProvider),
                    child: const Text('Coba Lagi', style: TextStyle(color: AppColors.merahBata)),
                  ),
                ],
              ),
            ),
          ),
          data: (newsList) {
            if (newsList.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text('Belum ada berita', style: GoogleFonts.poppins(color: AppColors.mutedBrown)),
                ),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: newsList.length > 5 ? 5 : newsList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final news = newsList[index];
                // Alternating color
                final Color bgColor = index.isEven ? AppColors.merahBataGelap : AppColors.cokelatBatu;
                final dateStr = DateFormat('dd MMM yyyy', 'id_ID').format(news.createdAt);
                
                return _buildNewsCard(
                  context: context,
                  backgroundColor: bgColor,
                  tag: news.category?.toUpperCase() ?? 'KABAR',
                  title: news.title,
                  date: dateStr,
                  newsData: news,
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildNewsCard({
    required BuildContext context,
    required Color backgroundColor,
    required String tag,
    required String title,
    required String date,
    required NewsModel newsData,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsDetailScreen(news: newsData),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.putihBersih.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          tag,
                          style: GoogleFonts.poppins(
                            color: AppColors.pureWhite,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          color: AppColors.pureWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        date,
                        style: GoogleFonts.poppins(
                          color: AppColors.putihBersih.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.putihBersih.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_outward_rounded,
                    color: AppColors.pureWhite,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class _ReportBanner extends StatelessWidget {
  const _ReportBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE2B071), Color(0xFFC07A49)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'JAGA RUANG PUBLIK KITA',
                        style: GoogleFonts.poppins(
                          color: AppColors.cokelatTua.withOpacity(0.8),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ada fasilitas yang perlu diperbaiki?',
                        style: GoogleFonts.poppins(
                          color: AppColors.cokelatTua,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Bantu kami dengan melaporkannya sekarang.',
                        style: GoogleFonts.poppins(
                          color: AppColors.cokelatTua.withOpacity(0.9),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.blushCream,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.flag_rounded,
                    color: AppColors.merahBata,
                    size: 32,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
