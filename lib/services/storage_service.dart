import 'package:flutter/foundation.dart' show debugPrint;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/equation_model.dart';
import 'database_provider.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  // Используем оба хранилища
  final DatabaseProvider _databaseProvider = DatabaseProvider();
  
  static const String _lastCoefficientsKey = 'last_coefficients';
  static const String _totalCalculationsKey = 'total_calculations';

  // === SharedPreferences методы (простые данные) ===

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

  // === DatabaseProvider методы (структурированные данные) ===

  Future<void> saveEquation(EquationSolution equation) async {
    try {
      // Создаем Map для сохранения
      final equationMap = {
        'id': equation.id ?? DateTime.now().millisecondsSinceEpoch,
        'a': equation.a,
        'b': equation.b,
        'c': equation.c,
        'equation_text': equation.equationText,
        'solution_text': equation.solutionText,
        'discriminant_text': equation.discriminantText,
        'created_at': equation.createdAt.toIso8601String(),
      };

      // Сохраняем в DatabaseProvider (SQLite на мобильных, SharedPreferences на Web)
      await _databaseProvider.insertEquation(equationMap);
      
      // Также сохраняем последние коэффициенты
      await saveLastCoefficients(equation.a, equation.b, equation.c);
      
      // Увеличиваем счетчик расчетов
      await incrementTotalCalculations();
      
    } catch (e) {
      debugPrint('Error saving equation: $e');
      rethrow;
    }
  }

  Future<List<EquationSolution>> getAllEquations() async {
    try {
      // Получаем данные из DatabaseProvider
      final data = await _databaseProvider.getAllEquations();
      
      final List<EquationSolution> equations = [];
      
      for (final map in data) {
        try {
          final equation = EquationSolution(
            id: map['id'] is int ? map['id'] as int : int.tryParse(map['id'].toString()),
            a: (map['a'] as num).toDouble(),
            b: (map['b'] as num).toDouble(),
            c: (map['c'] as num).toDouble(),
            equationText: map['equation_text'] as String,
            solutionText: map['solution_text'] as String,
            discriminantText: map['discriminant_text'] as String,
            createdAt: DateTime.parse(map['created_at'] as String),
          );
          equations.add(equation);
        } catch (e) {
          debugPrint('Error parsing equation: $e');
          continue;
        }
      }
      
      return equations;
    } catch (e) {
      debugPrint('Error getting equations: $e');
      return [];
    }
  }

  Future<void> deleteEquation(int id) async {
    try {
      await _databaseProvider.deleteEquation(id);
    } catch (e) {
      debugPrint('Error deleting equation: $e');
    }
  }

  Future<void> clearAllEquations() async {
    try {
      await _databaseProvider.clearAllEquations();
    } catch (e) {
      debugPrint('Error clearing equations: $e');
    }
  }

  Future<void> clearAllPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      debugPrint('Error clearing preferences: $e');
    }
  }

  // Дополнительные методы для статистики
  
  Future<int> getEquationCount() async {
    try {
      return await _databaseProvider.getEquationCount();
    } catch (e) {
      return 0;
    }
  }
  
  Future<Map<String, dynamic>> getStatistics() async {
    final totalCalculations = await getTotalCalculations();
    final equationCount = await getEquationCount();
    final lastCoefficients = await getLastCoefficients();
    
    return {
      'total_calculations': totalCalculations,
      'saved_equations': equationCount,
      'last_coefficients': lastCoefficients,
    };
  }
}