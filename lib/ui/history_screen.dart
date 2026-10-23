import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../gas/saved_bill.dart';
import '../gas/history_store.dart';
import 'sources_dialog.dart';
import 'theme.dart';
import '../ads/ad_banner.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<SavedBill> _bills = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    final bills = await HistoryStore.load();
    if (mounted) {
      setState(() {
        _bills = bills;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HISTORY'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Sources & Disclaimer',
            onPressed: () => showGasSourcesDialog(context),
          ),
          if (_bills.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Clear all',
              onPressed: () async {
                await HistoryStore.clear();
                await _reload();
              },
            ),
        ],
      ),
      bottomNavigationBar: const AdBanner(),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _bills.isEmpty
              ? const Center(
                  child: Text(
                    'No saved bills yet.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _bills.length,
                  itemBuilder: (context, i) {
                    final b = _bills[i];
                    return Dismissible(
                      key: ValueKey('${b.savedAt.millisecondsSinceEpoch}-$i'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) async {
                        await HistoryStore.deleteAt(i);
                        await _reload();
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        child: ListTile(
                          leading: const Icon(Icons.local_fire_department,
                              color: BillTheme.goldDark, size: 32),
                          title: Text(
                            'Rs ${NumberFormat('#,##0.00').format(b.total)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 17,
                                color: BillTheme.navy),
                          ),
                          subtitle: Text(
                            '${b.hm3.toStringAsFixed(2)} HM³ — ${b.typeLabel}\n'
                            '${DateFormat('d MMM yyyy, h:mm a').format(b.savedAt)}',
                          ),
                          isThreeLine: true,
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
