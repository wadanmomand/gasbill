import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ui/calculator_screen.dart';
import 'ui/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await MobileAds.instance.initialize();
  } catch (_) {
    // Ads must never break the calculator (offline use, plugin missing).
  }
  runApp(const GasBillApp());
}

class GasBillApp extends StatelessWidget {
  const GasBillApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gas Bill Calculator',
      debugShowCheckedModeBanner: false,
      theme: BillTheme.light(),
      home: const CalculatorScreen(),
    );
  }
}
