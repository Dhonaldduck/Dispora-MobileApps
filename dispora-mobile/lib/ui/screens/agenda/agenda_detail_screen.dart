import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../features/agenda/models/agenda_model.dart';
import '../../theme/app_colors.dart';

class AgendaDetailScreen extends StatelessWidget {
  final AgendaModel agenda;

  const AgendaDetailScreen({super.key, required this.agenda});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.putihHangat,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header & Poster
                Stack(
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: _buildHeroImage(agenda),
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
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FloatingActionButton.small(
                          heroTag: 'back_button_agenda',
                          backgroundColor: Colors.white.withOpacity(0.9),
                          elevation: 2,
                          onPressed: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back, color: AppColors.cokelatTua),
                        ),
                      ),
                    ),
                  ],
                ),

                // Info Card
                Container(
                  width: double.infinity,
                  color: AppColors.putihBersih,
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Lencana Kategori
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.blushCream,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          agenda.category?.toUpperCase() ?? 'EVENT',
                          style: GoogleFonts.poppins(
                            color: AppColors.merahBata,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Judul Acara
                      Text(
                        agenda.title,
                        style: GoogleFonts.poppins(
                          color: AppColors.cokelatTua,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Waktu & Lokasi
                      _buildInfoRow(
                        icon: Icons.calendar_today_outlined,
                        text: DateFormat('dd MMMM yyyy', 'id_ID').format(agenda.startDate),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        icon: Icons.access_time_outlined,
                        text: '${DateFormat('HH:mm').format(agenda.startDate)} - ${DateFormat('HH:mm').format(agenda.endDate)} WIB',
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        icon: Icons.location_on_outlined,
                        text: agenda.location,
                      ),
                      if (agenda.organizer != null && agenda.organizer!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          icon: Icons.business_outlined,
                          text: agenda.organizer!,
                        ),
                      ],
                      const SizedBox(height: 32),
                      
                      // Deskripsi
                      Text(
                        'Tentang Acara',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.cokelatTua,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        agenda.description,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.cokelatTua.withOpacity(0.8),
                          height: 1.6,
                        ),
                      ),
                      
                      // Extra space for bottom bar
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom Action Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              decoration: BoxDecoration(
                color: AppColors.putihBersih,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.merahBata,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Ikuti Event / Simpan Jadwal',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.mutedBrown),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.cokelatTua,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroImage(AgendaModel agenda) {
    if (agenda.thumbnailUrl != null && agenda.thumbnailUrl!.isNotEmpty) {
      return Image.network(
        agenda.thumbnailUrl!,
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
