import '../models/equation_model.dart';

abstract class HistoryScreenState {}

class HistoryScreenLoading extends HistoryScreenState {}

class HistoryScreenLoaded extends HistoryScreenState {
  final List<EquationSolution> equations;
  final int totalCalculations;
  
  HistoryScreenLoaded({
    required this.equations,
    required this.totalCalculations,
  });
}

class HistoryScreenError extends HistoryScreenState {
  final String message;
  
  HistoryScreenError(this.message);
}