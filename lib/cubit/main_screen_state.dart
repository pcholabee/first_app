// Абстрактный класс состояния
abstract class MainScreenState {}

// Состояние для отображения ввода данных
class MainScreenInputState extends MainScreenState {
  final double? a;
  final double? b;
  final double? c;
  final bool isProcessingAgreed;
  final String? aError;
  final String? bError;
  final String? cError;
  
  MainScreenInputState({
    this.a,
    this.b,
    this.c,
    required this.isProcessingAgreed,
    this.aError,
    this.bError,
    this.cError,
  });
}

// Состояние для отображения результата
class MainScreenResultState extends MainScreenState {
  final double a;
  final double b;
  final double c;
  final String equationText;
  final String solutionText;
  final String discriminantText;
  
  MainScreenResultState({
    required this.a,
    required this.b,
    required this.c,
    required this.equationText,
    required this.solutionText,
    required this.discriminantText,
  });
}