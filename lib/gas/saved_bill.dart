import 'dart:convert';

/// A saved gas bill calculation.
class SavedBill {
  final double hm3;
  final String typeLabel;
  final double total;
  final DateTime savedAt;

  SavedBill({
    required this.hm3,
    required this.typeLabel,
    required this.total,
    required this.savedAt,
  });

  Map<String, dynamic> toJson() => {
        'hm3': hm3,
        'type': typeLabel,
        'total': total,
        'savedAt': savedAt.toIso8601String(),
      };

  factory SavedBill.fromJson(Map<String, dynamic> json) => SavedBill(
        hm3: (json['hm3'] as num).toDouble(),
        typeLabel: json['type'] as String,
        total: (json['total'] as num).toDouble(),
        savedAt: DateTime.parse(json['savedAt'] as String),
      );

  String toStorageString() => jsonEncode(toJson());

  factory SavedBill.fromStorageString(String s) =>
      SavedBill.fromJson(jsonDecode(s) as Map<String, dynamic>);
}
