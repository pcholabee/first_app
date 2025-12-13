import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/storage_service.dart';
import 'history_screen_state.dart';

class HistoryScreenCubit extends Cubit<HistoryScreenState> {
  final StorageService _storageService = StorageService();

  HistoryScreenCubit() : super(HistoryScreenLoading()) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    try {
      emit(HistoryScreenLoading());
      
      final equations = await _storageService.getAllEquations();
      final totalCalculations = await _storageService.getTotalCalculations();
      
      emit(HistoryScreenLoaded(
        equations: equations,
        totalCalculations: totalCalculations,
      ));
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error loading history: $e');
      }
      emit(HistoryScreenError('Не удалось загрузить историю решений'));
    }
  }

  Future<void> deleteEquation(int id) async {
    try {
      await _storageService.deleteEquation(id);
      await loadHistory();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error deleting equation: $e');
      }
    }
  }

  Future<void> clearAllHistory() async {
    try {
      await _storageService.clearAllEquations();
      await loadHistory();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error clearing history: $e');
      }
    }
  }

  Future<void> refresh() async {
    await loadHistory();
  }
}