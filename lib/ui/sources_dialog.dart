/// Sources & Disclaimer dialog (Play Misleading Claims policy fix,
/// 2026-10-23). Opened from the AppBar info button on every screen.
/// States plainly that this is NOT a government app and names the
/// official source of the tariff tables.
library;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> showGasSourcesDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Sources & Disclaimer'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'This app is NOT a government app. It is not affiliated '
              'with, endorsed by, or representing OGRA, the Government '
              'of Pakistan, the Ministry of Energy (Petroleum Division), '
              'SNGPL, or SSGC.',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            const Text(
              'Tariff source: the slab tables in this app are based on '
              "OGRA's notified domestic natural gas sale prices for "
              'SNGPL and SSGC, notified 29 June 2025 and effective '
              '1 July 2025 (Protected Rs 200–350 per MMBtu + Rs 600 '
              'fixed charge + Rs 40 meter rent; Non-Protected Rs 500–'
              '4,200 per MMBtu + Rs 1,500 / Rs 3,000 fixed charge).',
            ),
            const SizedBox(height: 12),
            const Text('Official source:'),
            InkWell(
              onTap: () async {
                final uri = Uri.parse('https://www.ogra.org.pk/');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(
                    uri,
                    mode: LaunchMode.externalApplication,
                  );
                }
              },
              child: const Text(
                'OGRA — www.ogra.org.pk\n'
                '(tariff notifications & determinations)',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Amounts are estimates based on the bundled tariff tables. '
              "Your gas company's bill is the final authority and may "
              'include additional taxes, arrears, GCV variance, or '
              'other surcharges.',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
