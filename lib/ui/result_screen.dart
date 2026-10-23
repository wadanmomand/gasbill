import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../gas/gas_calculator.dart';
import '../gas/saved_bill.dart';
import '../gas/history_store.dart';
import 'sources_dialog.dart';
import 'theme.dart';
import '../ads/ad_banner.dart';

class ResultScreen extends StatelessWidget {
  final GasBillResult result;

  const ResultScreen({super.key, required this.result});

  String _rs(double v) =>
      'Rs ${NumberFormat('#,##0.00').format(v)}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BILL BREAKDOWN'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Sources & Disclaimer',
            onPressed: () => showGasSourcesDialog(context),
          ),
        ],
      ),
      bottomNavigationBar: const AdBanner(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [BillTheme.navy, BillTheme.navyDark],
                ),
                boxShadow: [
                  BoxShadow(
                      color: BillTheme.navy.withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6)),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    '${result.hm3.toStringAsFixed(2)} HM³ — ${result.type.label}',
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _rs(result.total),
                    style: const TextStyle(
                      color: BillTheme.gold,
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('Estimated total',
                      style: TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _row('Gas consumption',
                '${result.hm3.toStringAsFixed(2)} HM³ = ${result.mmbtu.toStringAsFixed(2)} MMBtu'),
            _row('Slab rate', 'Rs ${result.ratePerMmbtu.toStringAsFixed(0)} / MMBtu'),
            _row('Gas charges', _rs(result.gasCharges)),
            _row('Fixed charges', _rs(result.fixedCharges)),
            _row('Meter rent', _rs(result.meterRent)),
            if (result.gst > 0) _row('GST (18%)', _rs(result.gst)),
            const Divider(height: 28),
            _row('TOTAL', _rs(result.total), bold: true),
            const SizedBox(height: 24),
            GoldButton(
              label: 'SAVE TO HISTORY',
              onPressed: () async {
                await HistoryStore.save(SavedBill(
                  hm3: result.hm3,
                  typeLabel: result.type.label,
                  total: result.total,
                  savedAt: DateTime.now(),
                ));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Saved to history')),
                  );
                  Navigator.of(context).pop();
                }
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Estimates only — actual bill may differ (GCV, taxes, slab changes).',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
                color: BillTheme.navy,
              )),
          Text(value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
                color: bold ? BillTheme.navy : Colors.black87,
              )),
        ],
      ),
    );
  }
}
