import re

with open('lib/ui/screens/home_screen.dart', 'r') as f:
    content = f.read()

new_content = """class _NewsSection extends StatelessWidget {
  const _NewsSection();

  @override
  Widget build(BuildContext context) {
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
        _buildNewsCard(
          context: context,
          backgroundColor: AppColors.merahBataGelap,
          tag: 'PENGUMUMAN',
          title: 'Pemeliharaan Lapangan Simpang Lima Diperpanjang',
          date: '08 Agu 2026',
          newsData: News(
            id: '1',
            title: 'Pemeliharaan Lapangan Simpang Lima Diperpanjang',
            content: 'Pemerintah Kota Semarang memperpanjang masa pemeliharaan rutin untuk seluruh area Lapangan Simpang Lima. Keputusan ini diambil demi memastikan rumput dan fasilitas publik lainnya dapat diperbarui secara maksimal menjelang gelaran Semarang Sport Festival bulan depan.\\n\\nMasyarakat diimbau untuk menggunakan alternatif fasilitas olahraga lainnya seperti GOR Tri Lomba Juang atau Taman Indonesia Kaya. Pemeliharaan ini diproyeksikan akan selesai pada akhir Agustus 2026.',
            thumbnailUrl: 'https://images.unsplash.com/photo-1579952363873-27f3bade9f55?q=80&w=600&auto=format&fit=crop',
            slug: 'pemeliharaan-lapangan',
            createdAt: DateTime(2026, 8, 8),
          ),
        ),
        const SizedBox(height: 12),
        _buildNewsCard(
          context: context,
          backgroundColor: AppColors.cokelatBatu,
          tag: 'OLAHRAGA',
          title: 'Tim Basket Semarang Raih Kemenangan Beruntun',
          date: '07 Agu 2026',
          newsData: News(
            id: '2',
            title: 'Tim Basket Semarang Raih Kemenangan Beruntun',
            content: 'Tim bola basket kebanggaan Kota Semarang kembali menorehkan prestasi gemilang dengan mencetak kemenangan beruntun di kejuaraan nasional tingkat provinsi. Kemenangan telak atas tim tuan rumah ini memastikan posisi mereka di puncak klasemen sementara.\\n\\nPelatih kepala menyatakan bahwa disiplin dan latihan fisik intensif selama tiga bulan terakhir membuahkan hasil manis.',
            thumbnailUrl: 'https://images.unsplash.com/photo-1546519638-68e109498ffc?q=80&w=600&auto=format&fit=crop',
            slug: 'tim-basket-menang',
            createdAt: DateTime(2026, 8, 7),
          ),
        ),
      ],
    );
  }

  Widget _buildNewsCard({
    required BuildContext context,
    required Color backgroundColor,
    required String tag,
    required String title,
    required String date,
    required News newsData,
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
}"""

# regex to replace class _NewsSection extends StatelessWidget { ... }
pattern = re.compile(r'class _NewsSection extends StatelessWidget \{.*?\n\}\n(?=class)', re.DOTALL)
updated_content = pattern.sub(new_content + '\n\n', content)

with open('lib/ui/screens/home_screen.dart', 'w') as f:
    f.write(updated_content)

