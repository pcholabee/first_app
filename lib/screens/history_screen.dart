import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/history_screen_cubit.dart';
import '../cubit/history_screen_state.dart';
import '../models/equation_model.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HistoryScreenCubit(),
      child: const _HistoryScreenContent(),
    );
  }
}

class _HistoryScreenContent extends StatelessWidget {
  const _HistoryScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('История решений'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showClearDialog(context),
            tooltip: 'Очистить всю историю',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<HistoryScreenCubit>().refresh(),
            tooltip: 'Обновить',
          ),
        ],
      ),
      body: BlocBuilder<HistoryScreenCubit, HistoryScreenState>(
        builder: (context, state) {
          if (state is HistoryScreenLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HistoryScreenError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<HistoryScreenCubit>().refresh(),
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          if (state is HistoryScreenLoaded) {
            final equations = state.equations;
            final totalCalculations = state.totalCalculations;

            return Column(
              children: [
                // Статистика
                Container(
                  padding: const EdgeInsets.all(16),
                  color: const Color.fromRGBO(33, 149, 243, 0.1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard(
                        'Всего решений',
                        totalCalculations.toString(),
                        Icons.calculate,
                      ),
                      _buildStatCard(
                        'В истории',
                        equations.length.toString(),
                        Icons.history,
                      ),
                    ],
                  ),
                ),
                
                // Список решений
                Expanded(
                  child: equations.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                          onRefresh: () async {
                            await context.read<HistoryScreenCubit>().refresh();
                          },
                          child: ListView.builder(
                            itemCount: equations.length,
                            itemBuilder: (context, index) {
                              final equation = equations[index];
                              return _buildEquationCard(context, equation);
                            },
                          ),
                        ),
                ),
              ],
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.history_toggle_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'История решений пуста',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            'Решите несколько уравнений,\nчтобы увидеть их здесь',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF757575),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.blue),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildEquationCard(BuildContext context, EquationSolution equation) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок с датой
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Уравнение',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${equation.createdAt.day}.${equation.createdAt.month}.${equation.createdAt.year} '
                  '${equation.createdAt.hour}:${equation.createdAt.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Коэффициенты
            Text(
              'Коэффициенты: a=${equation.a}, b=${equation.b}, c=${equation.c}',
              style: const TextStyle(color: Color(0xFF616161)),
            ),
            const SizedBox(height: 8),
            
            // Уравнение
            Text(
              equation.equationText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            
            // Дискриминант
            Text(
              equation.discriminantText,
              style: const TextStyle(
                color: Color(0xFF1976D2),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            
            // Решение
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(76, 175, 80, 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                equation.solutionText,
                style: const TextStyle(height: 1.4),
              ),
            ),
            
            // Кнопка удаления
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  context.read<HistoryScreenCubit>().deleteEquation(equation.id!);
                },
                tooltip: 'Удалить из истории',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showClearDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Очистить историю'),
        content: const Text('Вы уверены, что хотите удалить всю историю решений?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Очистить'),
          ),
        ],
      ),
    );

    if (result == true) {
      // ignore: use_build_context_synchronously
      await context.read<HistoryScreenCubit>().clearAllHistory();
    }
  }
}