import 'package:shared_preferences/shared_preferences.dart';

import 'saved_bill.dart';

/// Local history of saved bill calculations (newest first, max 100).
class HistoryStore {
  static const String _key = 'gas_bill_history';

  static Future<List<SavedBill>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw.map(SavedBill.fromStorageString).toList();
  }

  static Future<void> save(SavedBill bill) async {
    final bills = await load();
    bills.insert(0, bill);
    while (bills.length > 100) {
      bills.removeLast();
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        _key, bills.map((b) => b.toStorageString()).toList());
  }

  static Future<void> deleteAt(int index) async {
    final bills = await load();
    if (index >= 0 && index < bills.length) {
      bills.removeAt(index);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
          _key, bills.map((b) => b.toStorageString()).toList());
    }
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
