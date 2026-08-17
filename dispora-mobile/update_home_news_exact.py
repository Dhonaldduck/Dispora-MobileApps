with open('lib/ui/screens/home_screen.dart', 'r') as f:
    content = f.read()

# Replace _NewsSection definition up to its end.
# Find the start of class _NewsSection extends StatelessWidget
start_idx = content.find('class _NewsSection extends StatelessWidget {')
if start_idx != -1:
    end_idx = content.find('class _ReportBanner extends StatelessWidget {', start_idx)
    if end_idx != -1:
        old_section = content[start_idx:end_idx]
        
        new_section = """class _NewsSection extends ConsumerWidget {
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
"""
        content = content.replace(old_section, new_section)
        
        with open('lib/ui/screens/home_screen.dart', 'w') as f:
            f.write(content)
        print("Success replacing section")
    else:
        print("Could not find end idx")
else:
    print("Could not find start idx")

