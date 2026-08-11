import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../features/news/providers/news_provider.dart';
import '../../features/agenda/providers/agenda_provider.dart';
import '../../features/youth_services/providers/youth_service_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispora Portal'),
        centerTitle: true,
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
              const SizedBox(height: 16),
              _buildSectionTitle('Berita Terbaru'),
              _buildNewsSection(ref),
              const SizedBox(height: 24),
              _buildSectionTitle('Agenda Terdekat'),
              _buildAgendaSection(ref),
              const SizedBox(height: 24),
              _buildSectionTitle('Layanan Kepemudaan'),
              _buildYouthServiceSection(ref),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildNewsSection(WidgetRef ref) {
    final newsAsyncValue = ref.watch(newsListProvider);

    return newsAsyncValue.when(
      data: (newsList) {
        if (newsList.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Belum ada berita terbaru.'),
          );
        }
        return SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            itemCount: newsList.length,
            itemBuilder: (context, index) {
              final news = newsList[index];
              return Container(
                width: 250,
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 120,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                        child: news.thumbnailUrl != null
                            ? Image.network(
                                news.thumbnailUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.image, size: 50),
                              )
                            : const Icon(Icons.image, size: 50),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              news.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('dd MMM yyyy').format(news.createdAt),
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
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
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildAgendaSection(WidgetRef ref) {
    final agendaAsyncValue = ref.watch(agendaListProvider);

    return agendaAsyncValue.when(
      data: (agendaList) {
        if (agendaList.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Belum ada agenda terdekat.'),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: agendaList.length,
          itemBuilder: (context, index) {
            final agenda = agendaList[index];
            final dateStr =
                DateFormat('dd MMM yyyy, HH:mm').format(agenda.startDate);
            return ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.event, color: Colors.blue),
              ),
              title: Text(
                agenda.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(dateStr, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          agenda.location,
                          style: const TextStyle(fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () {
                // TODO: Navigate to detail
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildYouthServiceSection(WidgetRef ref) {
    final serviceAsyncValue = ref.watch(youthServiceListProvider);

    return serviceAsyncValue.when(
      data: (serviceList) {
        if (serviceList.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Belum ada layanan yang tersedia.'),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: serviceList.length,
            itemBuilder: (context, index) {
              final service = serviceList[index];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    // TODO: Navigate to service detail
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.handshake,
                          size: 40,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          service.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          service.category,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
