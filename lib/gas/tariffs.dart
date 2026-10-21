/// Pakistan domestic gas tariffs (bundled).
///
/// Source: OGRA natural gas sale price notice effective 1 July 2025
/// (still current as of Oct 2026; geo.tv, thenews.pk, pakera.pk).
/// Gas billing model: the slab rate is chosen by TOTAL monthly HM3 and
/// applied to ALL MMBtu (not progressive like electricity).
library;

/// One slab: consumption up to [maxHm3] (inclusive) is billed at
/// [ratePerMmbtu] Rs/MMBtu. Use a very large number for the top slab.
class GasSlab {
  final double maxHm3;
  final double ratePerMmbtu;

  const GasSlab(this.maxHm3, this.ratePerMmbtu);
}

enum GasConsumerType {
  protected,
  nonProtected;

  String get label {
    switch (this) {
      case GasConsumerType.protected:
        return 'Protected';
      case GasConsumerType.nonProtected:
        return 'Non-Protected';
    }
  }
}

/// Bundled tariff table. All amounts in PKR.
class GasTariffs {
  static const double gstRate = 0.18;
  static const double meterRent = 40.0;

  /// 1 HM3 ~= 3.5 MMBtu at GCV 990 (SSGC figure). The bill prints the
  /// exact GCV used; this is the standard estimate.
  static const double mmbtuPerHm3 = 3.5;

  static const Map<GasConsumerType, List<GasSlab>> slabs = {
    GasConsumerType.protected: [
      GasSlab(0.25, 200),
      GasSlab(0.50, 250),
      GasSlab(0.60, 300),
      GasSlab(0.90, 350),
    ],
    GasConsumerType.nonProtected: [
      GasSlab(0.25, 500),
      GasSlab(0.60, 850),
      GasSlab(1.00, 1250),
      GasSlab(1.50, 1450),
      GasSlab(2.00, 1900),
      GasSlab(3.00, 3300),
      GasSlab(4.00, 3800),
      GasSlab(1000000, 4200),
    ],
  };

  /// Fixed monthly charges by consumer type and consumption.
  static double fixedCharges(GasConsumerType type, double hm3) {
    switch (type) {
      case GasConsumerType.protected:
        return 600;
      case GasConsumerType.nonProtected:
        return hm3 <= 1.5 ? 1500 : 3000;
    }
  }

  /// Maximum HM3 the table covers (-1 = effectively unlimited).
  static double maxHm3(GasConsumerType type) {
    final last = slabs[type]!.last.maxHm3;
    return last >= 1000000 ? -1 : last;
  }
}
