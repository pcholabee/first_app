import 'package:shared_preferences/shared_preferences.dart';
import '../models/equation_model.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static const String _lastCoefficientsKey = 'last_coefficients';
  static const String _totalCalculationsKey = 'total_calculations';
  static const String _historyKey = 'equation_history';

  Future<void> saveLastCoefficients(double a, double b, double c) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastCoefficientsKey, '$a,$b,$c');
  }

  Future<List<double>?> getLastCoefficients() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_lastCoefficientsKey);
    if (data != null) {
      try {
        final parts = data.split(',');
        return [
          double.parse(parts[0]),
          double.parse(parts[1]),
          double.parse(parts[2]),
        ];
      } catch (_) {
        // Игнорируем ошибки парсинга, возвращаем null
        return null;
      }
    }
    return null;
  }

  Future<void> incrementTotalCalculations() async {
    final prefs = await SharedPreferences.getInstance();
    final int current = prefs.getInt(_totalCalculationsKey) ?? 0;
    await prefs.setInt(_totalCalculationsKey, current + 1);
  }

  Future<int> getTotalCalculations() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_totalCalculationsKey) ?? 0;
  }

  Future<void> saveEquation(EquationSolution equation) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_historyKey) ?? [];
    
    final equationData = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'a': equation.a.toString(),
      'b': equation.b.toString(),
      'c': equation.c.toString(),
      'equation_text': equation.equationText,
      'solution_text': equation.solutionText,
      'discriminant_text': equation.discriminantText,
      'created_at': equation.createdAt.toIso8601String(),
    };
    
    history.add('${equationData['id']}|${equationData['a']}|${equationData['b']}|${equationData['c']}|${equationData['equation_text']}|${equationData['solution_text']}|${equationData['discriminant_text']}|${equationData['created_at']}');
    
    // Сохраняем только последние 50 записей
    if (history.length > 50) {
      history.removeAt(0);
    }
    
    await prefs.setStringList(_historyKey, history);
  }

  Future<List<EquationSolution>> getAllEquations() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? history = prefs.getStringList(_historyKey);
    
    if (history == null || history.isEmpty) {
      return [];
    }
    
    final List<EquationSolution> equations = [];
    
    for (final entry in history) {
      final parts = entry.split('|');
      if (parts.length >= 8) {
        try {
          final equation = EquationSolution(
            id: int.tryParse(parts[0]),
            a: double.parse(parts[1]),
            b: double.parse(parts[2]),
            c: double.parse(parts[3]),
            equationText: parts[4],
            solutionText: parts[5],
            discriminantText: parts[6],
            createdAt: DateTime.parse(parts[7]),
          );
          equations.add(equation);
        } catch (_) {
          // Пропускаем некорректные записи
          continue;
        }
      }
    }
    
    // Сортируем по дате создания (новые сначала)
    equations.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    return equations;
  }

  Future<void> deleteEquation(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? history = prefs.getStringList(_historyKey);
    
    if (history != null) {
      final newHistory = history.where((entry) {
        final parts = entry.split('|');
        if (parts.isNotEmpty) {
          return parts[0] != id.toString();
        }
        return true;
      }).toList();
      
      await prefs.setStringList(_historyKey, newHistory);
    }
  }

  Future<void> clearAllEquations() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }

  Future<void> clearAllPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}