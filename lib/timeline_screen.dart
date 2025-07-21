import 'package:flutter/material.dart';

class TimelineEntry {
  final String text;
  final DateTime timestamp;
  final String? imageUrl;

  TimelineEntry({required this.text, required this.timestamp, this.imageUrl});
}

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<TimelineEntry> _followingEntries = [
    TimelineEntry(text: 'Followed user post 1', timestamp: DateTime.now().subtract(const Duration(minutes: 5))),
    TimelineEntry(text: 'Followed user post 2 with image', timestamp: DateTime.now().subtract(const Duration(hours: 1)), imageUrl: null),
  ];

  final List<TimelineEntry> _exploreEntries = [
    TimelineEntry(text: 'Explore post 1', timestamp: DateTime.now().subtract(const Duration(days: 1))),
    TimelineEntry(text: 'Explore post 2 with image', timestamp: DateTime.now().subtract(const Duration(days: 2)), imageUrl: null),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timeline'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Following'),
            Tab(text: 'Explore'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildList(_followingEntries),
          _buildList(_exploreEntries),
        ],
      ),
    );
  }

  Widget _buildList(List<TimelineEntry> entries) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.text, style: const TextStyle(fontSize: 16)),
                if (entry.imageUrl != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Image.network(entry.imageUrl!),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _formatTimestamp(entry.timestamp),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatTimestamp(DateTime time) {
    return '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} '
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
