/// Sources & Disclaimer dialog (Play Misleading Claims policy fix,
/// 2026-10-23; v1.0.2 complete-source-list update). Opened from the
/// AppBar info button on every screen. States plainly that this is
/// NOT a government app and lists EVERY official source used — Play's
/// second notice (2026-10-23) objected that v1.0.1's wording implied
/// more than one source while listing only one link.
library;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> showGasSourcesDialog(BuildContext context) {
  Future<void> open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget link(String url, String label) {
    return InkWell(
      onTap: () => open(url),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

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
              'COMPLETE LIST OF OFFICIAL SOURCES — this is the full '
              'list. No other government source is used in this app. '
              'All tariff data comes from ONE OGRA notification:',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              '1. OGRA notification of revised category-wise natural '
              'gas sale prices, issued 29 June 2025 and effective '
              '1 July 2025. This ONE notification sets the domestic '
              'prices for BOTH SNGPL and SSGC customers. Find it on '
              "OGRA's website under its natural gas sale price "
              'notifications:',
            ),
            const SizedBox(height: 4),
            link(
              'https://www.ogra.org.pk/',
              'OGRA — www.ogra.org.pk',
            ),
            const SizedBox(height: 8),
            const Text(
              '2. The same notified schedule, as published for each '
              "company's customers:",
            ),
            const SizedBox(height: 4),
            link(
              'https://www.sngpl.com.pk/',
              'SNGPL — www.sngpl.com.pk',
            ),
            const SizedBox(height: 4),
            link(
              'https://viewbill.ssgc.com.pk/web/',
              "SSGC official bill portal — viewbill.ssgc.com.pk",
            ),
            const SizedBox(height: 8),
            const Text(
              'What comes from where: slab rates (Protected Rs 200–'
              '350 per MMBtu; Non-Protected Rs 500–4,200 per MMBtu), '
              'fixed charges (Rs 600 / Rs 1,500 / Rs 3,000) and Rs 40 '
              'meter rent — all from the OGRA-notified domestic '
              'schedule above. SNGPL and SSGC are the companies '
              'covered by that notification, not additional data '
              'sources.',
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
