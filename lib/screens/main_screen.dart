import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/main_screen_cubit.dart';
import 'cubit/main_screen_state.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Лидихо Станислав Александрович'),
      ),
      body: BlocBuilder<MainScreenCubit, MainScreenState>(
        builder: (context, state) {
          if (state is MainScreenInputState) {
            return _buildInputScreen(context, state);
          } else if (state is MainScreenResultState) {
            return _buildResultScreen(context, state);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildInputScreen(BuildContext context, MainScreenInputState state) {
    final cubit = BlocProvider.of<MainScreenCubit>(context);
    
    // Используйте const для TextEditingController (опционально)
    final aController = TextEditingController(text: state.a?.toString() ?? '');
    final bController = TextEditingController(text: state.b?.toString() ?? '');
    final cController = TextEditingController(text: state.c?.toString() ?? '');
    
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Решение квадратного уравнения',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text(
            'Введите коэффициенты:',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          
          TextFormField(
            controller: aController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Коэффициент a',
              border: const OutlineInputBorder(),
              errorText: state.aError,
            ),
            onChanged: (value) => cubit.updateA(value),
          ),
          const SizedBox(height: 10),
          
          TextFormField(
            controller: bController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Коэффициент b',
              border: const OutlineInputBorder(),
              errorText: state.bError,
            ),
            onChanged: (value) => cubit.updateB(value),
          ),
          const SizedBox(height: 10),
          
          TextFormField(
            controller: cController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Коэффициент c',
              border: const OutlineInputBorder(),
              errorText: state.cError,
            ),
            onChanged: (value) => cubit.updateC(value),
          ),
          const SizedBox(height: 20),
          
          CheckboxListTile(
            title: const Text('Согласен на обработку данных'),
            value: state.isProcessingAgreed,
            onChanged: (bool? value) {
              cubit.updateAgreement(value ?? false);
            },
          ),
          const SizedBox(height: 20),
          
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (state.isProcessingAgreed &&
                    state.a != null &&
                    state.b != null &&
                    state.c != null &&
                    state.aError == null &&
                    state.bError == null &&
                    state.cError == null) {
                  cubit.solveEquation();
                } else if (!state.isProcessingAgreed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Необходимо согласие на обработку данных'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Пожалуйста, исправьте ошибки в форме'),
                    ),
                  );
                }
              },
              child: const Text('Решить уравнение'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultScreen(BuildContext context, MainScreenResultState state) {
    final cubit = BlocProvider.of<MainScreenCubit>(context);

    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Квадратное уравнение:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            state.equationText,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          
          Text(
            state.discriminantText,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          
          const Text(
            'Решение:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                state.solutionText,
                style: const TextStyle(fontSize: 18, height: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          Center(
            child: ElevatedButton(
              onPressed: () {
                cubit.returnToInput();
              },
              child: const Text('Вернуться к вводу'),
            ),
          ),
        ],
      ),
    );
  }
}