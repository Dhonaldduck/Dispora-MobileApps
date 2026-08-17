import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../features/auth/providers/auth_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import 'auth/login_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _notificationsEnabled = true;

  String _getInitials(String name) {
    if (name.trim().isEmpty) return '';
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.length == 1) {
      return words[0].substring(0, 1).toUpperCase();
    }
    return '${words[0].substring(0, 1)}${words[1].substring(0, 1)}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.putihHangat,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 3, // Profil tab aktif
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context); // Kembali ke Home
          }
          // Tambahkan logika navigasi untuk index lain jika diperlukan
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _buildHeader(),
                const SizedBox(height: 24),
                _buildUserInfoCard(ref),
                const SizedBox(height: 32),
                _buildLayananPublikSection(),
                const SizedBox(height: 24),
                _buildPengaturanSection(),
                const SizedBox(height: 40),
                _buildFooter(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
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
        Text(
          'Profil',
          style: GoogleFonts.poppins(
            color: AppColors.cokelatTua,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfoCard(WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final isGuest = authState.isGuest || user == null;

    final name = isGuest ? 'Tamu' : user.fullName;
    final email = isGuest ? 'Masuk untuk mengakses layanan penuh' : user.email;

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
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: isGuest ? Colors.grey.shade300 : AppColors.warmGold,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: isGuest
                        ? const Icon(Icons.person, color: Colors.grey, size: 32)
                        : Text(
                            _getInitials(name),
                            style: GoogleFonts.poppins(
                              color: AppColors.cokelatTua,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.poppins(
                          color: AppColors.pureWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      if (email.isNotEmpty)
                        Text(
                          email,
                          style: GoogleFonts.poppins(
                            color: AppColors.softBlush,
                            fontSize: 12,
                          ),
                        ),
                      const SizedBox(height: 8),
                      if (!isGuest)
                        Row(
                          children: [
                            const Icon(Icons.verified, color: AppColors.paleGold, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              'Akun terverifikasi',
                              style: GoogleFonts.poppins(
                                color: AppColors.paleGold,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Edit Button (Top Right)
          Positioned(
            top: 20,
            right: 20,
            child: isGuest
                ? TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.15),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                    child: Text(
                      'Masuk',
                      style: GoogleFonts.poppins(
                        color: AppColors.pureWhite,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  )
                : InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(99),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit_outlined,
                        color: AppColors.pureWhite,
                        size: 16,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailingWidget,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.blushCream,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppColors.merahBata,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            // Texts
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: AppColors.cokelatTua,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      color: AppColors.mutedBrown,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Trailing
            trailingWidget ?? const Icon(Icons.chevron_right_rounded, color: AppColors.mutedBrown),
          ],
        ),
      ),
    );
  }

  Widget _buildLayananPublikSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Layanan publik',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.cokelatTua,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.putihBersih,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderCream),
          ),
          child: Column(
            children: [
              _buildMenuTile(
                icon: Icons.storage_rounded,
                title: 'Database keolahragaan',
                subtitle: 'Data atlet, wasit, dan fasilitas',
              ),
              const Divider(height: 1, color: AppColors.borderCream),
              _buildMenuTile(
                icon: Icons.groups_rounded,
                title: 'Layanan kepemudaan',
                subtitle: 'Program dan aktivitas pemuda',
              ),
              const Divider(height: 1, color: AppColors.borderCream),
              _buildMenuTile(
                icon: Icons.info_outline_rounded,
                title: 'Profil DISPORA',
                subtitle: 'Visi, misi, dan struktur organisasi',
              ),
              const Divider(height: 1, color: AppColors.borderCream),
              _buildMenuTile(
                icon: Icons.report_problem_outlined,
                title: 'Lapor fasilitas',
                subtitle: 'Pusat aduan kerusakan fasilitas',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPengaturanSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pengaturan',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.cokelatTua,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.putihBersih,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderCream),
          ),
          child: Column(
            children: [
              _buildMenuTile(
                icon: Icons.notifications_none_rounded,
                title: 'Notifikasi',
                subtitle: 'Atur pemberitahuan aplikasi',
                trailingWidget: Switch(
                  value: _notificationsEnabled,
                  activeColor: Colors.teal,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                ),
              ),
              const Divider(height: 1, color: AppColors.borderCream),
              _buildMenuTile(
                icon: Icons.help_outline_rounded,
                title: 'Pusat bantuan',
                subtitle: 'FAQ dan layanan dukungan',
              ),
              const Divider(height: 1, color: AppColors.borderCream),
              _buildMenuTile(
                icon: Icons.logout_rounded,
                title: 'Keluar akun',
                subtitle: 'Akhiri sesi Anda saat ini',
                onTap: () {
                  ref.read(authProvider.notifier).logout();
                  Navigator.pop(context); // Kembali ke root setelah logout
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.merahBata,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.sports_soccer,
              color: AppColors.putihBersih,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'DISPORA Kota Semarang',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.cokelatTua,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Melayani dengan gerak nyata · v1.0.0',
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: AppColors.mutedBrown,
            ),
          ),
        ],
      ),
    );
  }
}
