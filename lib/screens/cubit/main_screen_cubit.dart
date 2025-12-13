import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';
import 'main_screen_state.dart';

// Cubit
class MainScreenCubit extends Cubit<MainScreenState> {
  MainScreenCubit() : super(MainScreenInputState(
    isProcessingAgreed: false,
  ));
  
  // Функция для обновления коэффициента A
  void updateA(String value) {
    final currentState = state as MainScreenInputState;
    
    if (value.isEmpty) {
      emit(MainScreenInputState(
        a: null,
        b: currentState.b,
        c: currentState.c,
        isProcessingAgreed: currentState.isProcessingAgreed,
        aError: 'Введите коэффициент a',
        bError: currentState.bError,
        cError: currentState.cError,
      ));
      return;
    }
    
    final aValue = double.tryParse(value);
    if (aValue == null) {
      emit(MainScreenInputState(
        a: null,
        b: currentState.b,
        c: currentState.c,
        isProcessingAgreed: currentState.isProcessingAgreed,
        aError: 'Введите корректное число',
        bError: currentState.bError,
        cError: currentState.cError,
      ));
    } else if (aValue == 0) {
      emit(MainScreenInputState(
        a: aValue,
        b: currentState.b,
        c: currentState.c,
        isProcessingAgreed: currentState.isProcessingAgreed,
        aError: 'Коэффициент a не может быть равен 0',
        bError: currentState.bError,
        cError: currentState.cError,
      ));
    } else {
      emit(MainScreenInputState(
        a: aValue,
        b: currentState.b,
        c: currentState.c,
        isProcessingAgreed: currentState.isProcessingAgreed,
        aError: null,
        bError: currentState.bError,
        cError: currentState.cError,
      ));
    }
  }
  
  // Функция для обновления коэффициента B
  void updateB(String value) {
    final currentState = state as MainScreenInputState;
    
    if (value.isEmpty) {
      emit(MainScreenInputState(
        a: currentState.a,
        b: null,
        c: currentState.c,
        isProcessingAgreed: currentState.isProcessingAgreed,
        aError: currentState.aError,
        bError: 'Введите коэффициент b',
        cError: currentState.cError,
      ));
      return;
    }
    
    final bValue = double.tryParse(value);
    if (bValue == null) {
      emit(MainScreenInputState(
        a: currentState.a,
        b: null,
        c: currentState.c,
        isProcessingAgreed: currentState.isProcessingAgreed,
        aError: currentState.aError,
        bError: 'Введите корректное число',
        cError: currentState.cError,
      ));
    } else {
      emit(MainScreenInputState(
        a: currentState.a,
        b: bValue,
        c: currentState.c,
        isProcessingAgreed: currentState.isProcessingAgreed,
        aError: currentState.aError,
        bError: null,
        cError: currentState.cError,
      ));
    }
  }
  
  // Функция для обновления коэффициента C
  void updateC(String value) {
    final currentState = state as MainScreenInputState;
    
    if (value.isEmpty) {
      emit(MainScreenInputState(
        a: currentState.a,
        b: currentState.b,
        c: null,
        isProcessingAgreed: currentState.isProcessingAgreed,
        aError: currentState.aError,
        bError: currentState.bError,
        cError: 'Введите коэффициент c',
      ));
      return;
    }
    
    final cValue = double.tryParse(value);
    if (cValue == null) {
      emit(MainScreenInputState(
        a: currentState.a,
        b: currentState.b,
        c: null,
        isProcessingAgreed: currentState.isProcessingAgreed,
        aError: currentState.aError,
        bError: currentState.bError,
        cError: 'Введите корректное число',
      ));
    } else {
      emit(MainScreenInputState(
        a: currentState.a,
        b: currentState.b,
        c: cValue,
        isProcessingAgreed: currentState.isProcessingAgreed,
        aError: currentState.aError,
        bError: currentState.bError,
        cError: null,
      ));
    }
  }
  
  // Функция для обновления согласия на обработку
  void updateAgreement(bool value) {
    final currentState = state as MainScreenInputState;
    
    emit(MainScreenInputState(
      a: currentState.a,
      b: currentState.b,
      c: currentState.c,
      isProcessingAgreed: value,
      aError: currentState.aError,
      bError: currentState.bError,
      cError: currentState.cError,
    ));
  }
  
  // Функция для решения уравнения
  void solveEquation() {
    final currentState = state as MainScreenInputState;
    
    // Проверка валидности данных
    if (currentState.a == null || 
        currentState.b == null || 
        currentState.c == null ||
        currentState.aError != null ||
        currentState.bError != null ||
        currentState.cError != null ||
        !currentState.isProcessingAgreed) {
      // Если данные невалидны, остаемся на том же экране с ошибками
      return;
    }
    
    final a = currentState.a!;
    final b = currentState.b!;
    final c = currentState.c!;
    
    // Вычисление дискриминанта
    double discriminant = (b * b) - (4 * a * c);
    
    // Формирование текста уравнения
    String equationText = '${a.toStringAsFixed(0)}x² + ${b.toStringAsFixed(0)}x + ${c.toStringAsFixed(0)} = 0';
    
    // Формирование текста решения
    String solutionText;
    if (discriminant > 0) {
      double x1 = (-b + sqrt(discriminant)) / (2 * a);
      double x2 = (-b - sqrt(discriminant)) / (2 * a);
      solutionText = 'Уравнение имеет два корня:\n'
           'x₁ = ${x1.toStringAsFixed(2)}\n'
           'x₂ = ${x2.toStringAsFixed(2)}';
    } else if (discriminant == 0) {
      double x = -b / (2 * a);
      solutionText = 'Уравнение имеет один корень:\n'
           'x = ${x.toStringAsFixed(2)}';
    } else {
      solutionText = 'Уравнение не имеет действительных корней\n'
           '(дискриминант отрицательный)';
    }
    
    // Формирование текста дискриминанта
    String discriminantText = 'Дискриминант D = ${discriminant.toStringAsFixed(2)}';
    
    emit(MainScreenResultState(
      a: a,
      b: b,
      c: c,
      equationText: equationText,
      solutionText: solutionText,
      discriminantText: discriminantText,
    ));
  }
  
  // Функция для возврата к вводу
  void returnToInput() {
    final currentState = state as MainScreenResultState;
    
    emit(MainScreenInputState(
      a: currentState.a,
      b: currentState.b,
      c: currentState.c,
      isProcessingAgreed: true,
      aError: null,
      bError: null,
      cError: null,
    ));
  }
}