import 'package:flutter_test/flutter_test.dart';
import 'package:gas_bill/gas/gas_calculator.dart';
import 'package:gas_bill/gas/tariffs.dart';

void main() {
  group('GasBillCalculator', () {
    test('protected 0.2 HM3 -> slab 200, total = mmbtu*200 + 600 + 40', () {
      final r = GasBillCalculator.calculate(
          hm3: 0.2, type: GasConsumerType.protected);
      expect(r.ratePerMmbtu, 200);
      expect(r.mmbtu, closeTo(0.2 * 3.5, 0.0001));
      expect(r.gasCharges, closeTo(0.7 * 200, 0.001));
      expect(r.fixedCharges, 600);
      expect(r.meterRent, 40);
      expect(r.total, closeTo(0.7 * 200 + 640, 0.001));
    });

    test('protected slab boundaries pick correct rate', () {
      expect(
          GasBillCalculator.calculate(
                  hm3: 0.25, type: GasConsumerType.protected)
              .ratePerMmbtu,
          200);
      expect(
          GasBillCalculator.calculate(
                  hm3: 0.26, type: GasConsumerType.protected)
              .ratePerMmbtu,
          250);
      expect(
          GasBillCalculator.calculate(
                  hm3: 0.9, type: GasConsumerType.protected)
              .ratePerMmbtu,
          350);
    });

    test('protected rejects 0.91 HM3 (out of range)', () {
      expect(
          () => GasBillCalculator.calculate(
              hm3: 0.91, type: GasConsumerType.protected),
          throwsArgumentError);
    });

    test('non-protected 1.0 HM3 -> 1250 slab, fixed 1500', () {
      final r = GasBillCalculator.calculate(
          hm3: 1.0, type: GasConsumerType.nonProtected);
      expect(r.ratePerMmbtu, 1250);
      expect(r.fixedCharges, 1500);
      expect(r.total, closeTo(3.5 * 1250 + 1500 + 40, 0.001));
    });

    test('non-protected above 1.5 HM3 -> fixed 3000', () {
      final r = GasBillCalculator.calculate(
          hm3: 2.0, type: GasConsumerType.nonProtected);
      expect(r.ratePerMmbtu, 1900);
      expect(r.fixedCharges, 3000);
    });

    test('non-protected 5 HM3 hits top slab 4200', () {
      final r = GasBillCalculator.calculate(
          hm3: 5.0, type: GasConsumerType.nonProtected);
      expect(r.ratePerMmbtu, 4200);
    });

    test('GST 18% applies on gas + fixed + rent', () {
      final r = GasBillCalculator.calculate(
        hm3: 1.0,
        type: GasConsumerType.nonProtected,
        includeGst: true,
      );
      final base = 3.5 * 1250 + 1500 + 40;
      expect(r.gst, closeTo(base * 0.18, 0.001));
      expect(r.total, closeTo(base + r.gst, 0.001));
    });

    test('zero/negative HM3 throws', () {
      expect(
          () => GasBillCalculator.calculate(
              hm3: 0, type: GasConsumerType.nonProtected),
          throwsArgumentError);
      expect(
          () => GasBillCalculator.calculate(
              hm3: -1, type: GasConsumerType.protected),
          throwsArgumentError);
    });

    test('hm3FromReadings computes difference', () {
      expect(GasBillCalculator.hm3FromReadings(100.5, 102.0),
          closeTo(1.5, 0.0001));
    });

    test('hm3FromReadings: current < previous throws', () {
      expect(() => GasBillCalculator.hm3FromReadings(102.0, 100.5),
          throwsArgumentError);
    });

    test('hm3FromReadings: equal readings throw', () {
      expect(() => GasBillCalculator.hm3FromReadings(100.0, 100.0),
          throwsArgumentError);
    });
  });
}
