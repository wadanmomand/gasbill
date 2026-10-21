/// Gas bill calculation engine.
library;

import 'tariffs.dart';

/// Full calculation result.
class GasBillResult {
  final GasConsumerType type;
  final double hm3;
  final double mmbtu;
  final double ratePerMmbtu;
  final double gasCharges;
  final double fixedCharges;
  final double meterRent;
  final double gst;
  final double total;

  const GasBillResult({
    required this.type,
    required this.hm3,
    required this.mmbtu,
    required this.ratePerMmbtu,
    required this.gasCharges,
    required this.fixedCharges,
    required this.meterRent,
    required this.gst,
    required this.total,
  });
}

class GasBillCalculator {
  /// Calculates the bill for [hm3] cubic hectometers under [type].
  ///
  /// The slab rate is picked by total HM3 and applied to all MMBtu.
  /// [includeGst] applies 18% GST on (gas + fixed + meter rent).
  /// Throws [ArgumentError] for invalid input or consumption beyond the
  /// consumer type's covered range.
  static GasBillResult calculate({
    required double hm3,
    required GasConsumerType type,
    bool includeGst = false,
  }) {
    if (hm3 <= 0) {
      throw ArgumentError('Consumption must be positive, got $hm3.');
    }
    final table = GasTariffs.slabs[type]!;
    final maxCovered = GasTariffs.maxHm3(type);
    if (maxCovered > 0 && hm3 > maxCovered) {
      throw ArgumentError(
          'Consumption ($hm3 HM3) exceeds the ${type.label} table range.');
    }

    var rate = table.last.ratePerMmbtu;
    for (final slab in table) {
      if (hm3 <= slab.maxHm3) {
        rate = slab.ratePerMmbtu;
        break;
      }
    }

    final mmbtu = hm3 * GasTariffs.mmbtuPerHm3;
    final gasCharges = mmbtu * rate;
    final fixed = GasTariffs.fixedCharges(type, hm3);
    const rent = GasTariffs.meterRent;
    final gst =
        includeGst ? (gasCharges + fixed + rent) * GasTariffs.gstRate : 0.0;

    return GasBillResult(
      type: type,
      hm3: hm3,
      mmbtu: mmbtu,
      ratePerMmbtu: rate,
      gasCharges: gasCharges,
      fixedCharges: fixed,
      meterRent: rent,
      gst: gst,
      total: gasCharges + fixed + rent + gst,
    );
  }

  /// HM3 consumed between two meter readings.
  static double hm3FromReadings(double previous, double current) {
    if (current < previous) {
      throw ArgumentError(
          'Current reading ($current) is less than previous ($previous).');
    }
    final hm3 = current - previous;
    if (hm3 <= 0) {
      throw ArgumentError('Readings must differ to consume gas.');
    }
    return hm3;
  }
}
