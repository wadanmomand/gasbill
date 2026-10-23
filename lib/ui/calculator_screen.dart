import 'package:flutter/material.dart';

import '../gas/gas_calculator.dart';
import '../gas/tariffs.dart';
import 'result_screen.dart';
import 'history_screen.dart';
import 'sources_dialog.dart';
import 'theme.dart';
import '../ads/ad_banner.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  bool _useReadings = false;
  final _hm3Ctrl = TextEditingController();
  final _prevCtrl = TextEditingController();
  final _currCtrl = TextEditingController();
  GasConsumerType _type = GasConsumerType.protected;
  bool _gst = false;
  String? _error;

  @override
  void dispose() {
    _hm3Ctrl.dispose();
    _prevCtrl.dispose();
    _currCtrl.dispose();
    super.dispose();
  }

  void _calculate() {
    setState(() => _error = null);
    try {
      final hm3 = _useReadings
          ? GasBillCalculator.hm3FromReadings(
              double.parse(_prevCtrl.text.trim()),
              double.parse(_currCtrl.text.trim()),
            )
          : double.parse(_hm3Ctrl.text.trim());
      final result = GasBillCalculator.calculate(
        hm3: hm3,
        type: _type,
        includeGst: _gst,
      );
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ResultScreen(result: result)),
      );
    } on FormatException {
      setState(() => _error = 'Please enter valid numbers.');
    } on ArgumentError catch (e) {
      setState(() => _error = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GAS BILL CALCULATOR'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Sources & Disclaimer',
            onPressed: () => showGasSourcesDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'History',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AdBanner(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _modeToggle(),
            const SizedBox(height: 20),
            if (_useReadings) ...[
              _numberField(_prevCtrl, 'Previous reading (HM³)'),
              const SizedBox(height: 12),
              _numberField(_currCtrl, 'Current reading (HM³)'),
            ] else
              _numberField(_hm3Ctrl, 'Gas used (HM³)'),
            const SizedBox(height: 20),
            const Text(
              'Consumer type',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: BillTheme.navy),
            ),
            const SizedBox(height: 8),
            _TypeSelector(
              selected: _type,
              onChanged: (t) => setState(() => _type = t),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              value: _gst,
              onChanged: (v) => setState(() => _gst = v),
              title: const Text('Add GST 18%',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              activeThumbColor: BillTheme.navy,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 8),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(_error!,
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w600)),
              ),
            GoldButton(label: 'CALCULATE BILL', onPressed: _calculate),
            const SizedBox(height: 24),
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

  Widget _modeToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          _modeChip('HM³ Used', !_useReadings,
              () => setState(() => _useReadings = false)),
          _modeChip('Meter Readings', _useReadings,
              () => setState(() => _useReadings = true)),
        ],
      ),
    );
  }

  Widget _modeChip(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: active
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [BillTheme.gold, BillTheme.goldDark],
                  )
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: active ? Colors.white : BillTheme.navy,
            ),
          ),
        ),
      ),
    );
  }

  Widget _numberField(TextEditingController ctrl, String label) {
    return TextField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _TypeSelector extends StatelessWidget {
  final GasConsumerType selected;
  final ValueChanged<GasConsumerType> onChanged;

  const _TypeSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: GasConsumerType.values.map((t) {
        final active = t == selected;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(t),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: active
                    ? const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [BillTheme.gold, BillTheme.goldDark],
                      )
                    : null,
                color: active ? null : Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 3)),
                ],
              ),
              child: Text(
                t.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: active ? Colors.white : BillTheme.navy,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
