const fs = require('fs');
let content = fs.readFileSync('/home/dhonaldduck/Documents/Dispora-projects/dispora-mobile/lib/ui/screens/home_screen.dart', 'utf-8');

// Ensure import for agendaProvider and AgendaDetailScreen are there
if (!content.includes("import '../../features/agenda/providers/agenda_provider.dart';")) {
  content = content.replace(
    "import '../../features/news/providers/news_provider.dart';",
    "import '../../features/news/providers/news_provider.dart';\nimport '../../features/agenda/providers/agenda_provider.dart';\nimport 'agenda/agenda_detail_screen.dart';"
  );
}

const oldAgendaSection = `class _AgendaSection extends StatelessWidget {
  const _AgendaSection();

  @override
  Widget build(BuildContext context) {
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
        Container(
          decoration: BoxDecoration(
            color: AppColors.putihBersih,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderCream),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {},
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
                            '17',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.merahBata,
                              height: 1.0,
                            ),
                          ),
                          Text(
                            'AGU',
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
                            'Semarang Sport Festival',
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
                                  'GOR Tri Lomba Juang',
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
                                '08:00 WIB',
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
      ],
    );
  }
}`;

const newAgendaSection = `class _AgendaSection extends ConsumerWidget {
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
}`;

content = content.replace(oldAgendaSection, newAgendaSection);

fs.writeFileSync('/home/dhonaldduck/Documents/Dispora-projects/dispora-mobile/lib/ui/screens/home_screen.dart', content, 'utf-8');
console.log('HomeScreen updated successfully');
