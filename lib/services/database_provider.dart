import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

// Интерфейс для работы с хранилищем
abstract class DatabaseProvider {
  // CRUD операции для уравнений
  Future<int> insertEquation(Map<String, dynamic> equation);
  Future<List<Map<String, dynamic>>> getAllEquations();
  Future<Map<String, dynamic>?> getEquationById(int id);
  Future<int> updateEquation(int id, Map<String, dynamic> equation);
  Future<int> deleteEquation(int id);
  Future<int> clearAllEquations();
  Future<void> close();
  
  // Статистика
  Future<int> getEquationCount();
  
  // Фабричный метод для создания провайдера
  factory DatabaseProvider() {
    if (kIsWeb) {
      return WebDatabaseProvider();
    } else {
      return MobileDatabaseProvider();
    }
  }
}

// Реализация для Web (использует SharedPreferences)
class WebDatabaseProvider implements DatabaseProvider {
  static const String _historyKey = 'sqlite_history_simulation';
  
  @override
  Future<int> insertEquation(Map<String, dynamic> equation) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_historyKey) ?? [];
    
    // Сериализуем Map в строку для хранения в SharedPreferences
    final equationStr = _serializeEquation(equation);
    history.add(equationStr);
    
    // Ограничиваем историю 50 записями
    if (history.length > 50) {
      history.removeAt(0);
    }
    
    await prefs.setStringList(_historyKey, history);
    return equation['id'] ?? DateTime.now().millisecondsSinceEpoch;
  }
  
  @override
  Future<List<Map<String, dynamic>>> getAllEquations() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? history = prefs.getStringList(_historyKey);
    
    if (history == null || history.isEmpty) {
      return [];
    }
    
    final List<Map<String, dynamic>> equations = [];
    
    for (final entry in history) {
      final equation = _deserializeEquation(entry);
      if (equation != null) {
        equations.add(equation);
      }
    }
    
    // Сортируем по дате создания (новые сначала)
    equations.sort((a, b) {
      final dateA = DateTime.parse(a['created_at']);
      final dateB = DateTime.parse(b['created_at']);
      return dateB.compareTo(dateA);
    });
    
    return equations;
  }
  
  @override
  Future<Map<String, dynamic>?> getEquationById(int id) async {
    final allEquations = await getAllEquations();
    for (final equation in allEquations) {
      if (equation['id'] == id) {
        return equation;
      }
    }
    return null;
  }
  
  @override
  Future<int> updateEquation(int id, Map<String, dynamic> newEquation) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? history = prefs.getStringList(_historyKey);
    
    if (history == null) {
      return 0;
    }
    
    final List<String> updatedHistory = [];
    int updatedCount = 0;
    
    for (final entry in history) {
      final equation = _deserializeEquation(entry);
      if (equation != null && equation['id'] == id) {
        // Обновляем уравнение
        final updatedStr = _serializeEquation(newEquation);
        updatedHistory.add(updatedStr);
        updatedCount++;
      } else {
        updatedHistory.add(entry);
      }
    }
    
    if (updatedCount > 0) {
      await prefs.setStringList(_historyKey, updatedHistory);
    }
    
    return updatedCount;
  }
  
  @override
  Future<int> deleteEquation(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? history = prefs.getStringList(_historyKey);
    
    if (history == null) {
      return 0;
    }
    
    final List<String> updatedHistory = [];
    int deletedCount = 0;
    
    for (final entry in history) {
      final equation = _deserializeEquation(entry);
      if (equation != null && equation['id'] == id) {
        deletedCount++;
      } else {
        updatedHistory.add(entry);
      }
    }
    
    if (deletedCount > 0) {
      await prefs.setStringList(_historyKey, updatedHistory);
    }
    
    return deletedCount;
  }
  
  @override
  Future<int> clearAllEquations() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
    return 1;
  }
  
  @override
  Future<void> close() async {
    // Для Web ничего закрывать не нужно
  }
  
  @override
  Future<int> getEquationCount() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? history = prefs.getStringList(_historyKey);
    return history?.length ?? 0;
  }
  
  // Приватные методы для сериализации/десериализации
  
  String _serializeEquation(Map<String, dynamic> equation) {
    final parts = <String>[];
    
    // Порядок полей важен для десериализации
    parts.add(equation['id'].toString());
    parts.add(equation['a'].toString());
    parts.add(equation['b'].toString());
    parts.add(equation['c'].toString());
    parts.add(equation['equation_text'].toString());
    parts.add(equation['solution_text'].toString());
    parts.add(equation['discriminant_text'].toString());
    parts.add(equation['created_at'].toString());
    
    return parts.join('|');
  }
  
  Map<String, dynamic>? _deserializeEquation(String data) {
    try {
      final parts = data.split('|');
      if (parts.length < 8) {
        return null;
      }
      
      return {
        'id': int.tryParse(parts[0]),
        'a': double.tryParse(parts[1]) ?? 0.0,
        'b': double.tryParse(parts[2]) ?? 0.0,
        'c': double.tryParse(parts[3]) ?? 0.0,
        'equation_text': parts[4],
        'solution_text': parts[5],
        'discriminant_text': parts[6],
        'created_at': parts[7],
      };
    } catch (e) {
      return null;
    }
  }
}

// Реализация для мобильных устройств (использует SQLite)
// Эта реализация будет работать только на мобильных устройствах
// Для Web используется WebDatabaseProvider
class MobileDatabaseProvider implements DatabaseProvider {
  // Для мобильных устройств мы будем использовать статическую реализацию
  // которая не будет вызываться на Web
  
  @override
  Future<int> insertEquation(Map<String, dynamic> equation) async {
    // На Web этот метод не должен вызываться
    assert(!kIsWeb, 'MobileDatabaseProvider не должен использоваться на Web');
    return 0;
  }
  
  @override
  Future<List<Map<String, dynamic>>> getAllEquations() async {
    // На Web этот метод не должен вызываться
    assert(!kIsWeb, 'MobileDatabaseProvider не должен использоваться на Web');
    return [];
  }
  
  @override
  Future<Map<String, dynamic>?> getEquationById(int id) async {
    // На Web этот метод не должен вызываться
    assert(!kIsWeb, 'MobileDatabaseProvider не должен использоваться на Web');
    return null;
  }
  
  @override
  Future<int> updateEquation(int id, Map<String, dynamic> equation) async {
    // На Web этот метод не должен вызываться
    assert(!kIsWeb, 'MobileDatabaseProvider не должен использоваться на Web');
    return 0;
  }
  
  @override
  Future<int> deleteEquation(int id) async {
    // На Web этот метод не должен вызываться
    assert(!kIsWeb, 'MobileDatabaseProvider не должен использоваться на Web');
    return 0;
  }
  
  @override
  Future<int> clearAllEquations() async {
    // На Web этот метод не должен вызываться
    assert(!kIsWeb, 'MobileDatabaseProvider не должен использоваться на Web');
    return 0;
  }
  
  @override
  Future<void> close() async {
    // На Web этот метод не должен вызываться
    assert(!kIsWeb, 'MobileDatabaseProvider не должен использоваться на Web');
  }
  
  @override
  Future<int> getEquationCount() async {
    // На Web этот метод не должен вызываться
    assert(!kIsWeb, 'MobileDatabaseProvider не должен использоваться на Web');
    return 0;
  }
}