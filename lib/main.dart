import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Решение квадратных уравнений',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FirstScreen(),
    );
  }
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final _formKey = GlobalKey<FormState>();
  final _aController = TextEditingController();
  final _bController = TextEditingController();
  final _cController = TextEditingController();
  bool _agreeToProcess = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Лидихо Станислав Александрович'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
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
                controller: _aController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Коэффициент a',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите коэффициент a';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Введите корректное число';
                  }
                  if (double.parse(value) == 0) {
                    return 'Коэффициент a не может быть равен 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              
              TextFormField(
                controller: _bController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Коэффициент b',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите коэффициент b';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Введите корректное число';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              
              TextFormField(
                controller: _cController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Коэффициент c',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите коэффициент c';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Введите корректное число';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              CheckboxListTile(
                title: const Text('Согласен на обработку данных'),
                value: _agreeToProcess,
                onChanged: (bool? value) {
                  setState(() {
                    _agreeToProcess = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() && _agreeToProcess) {
                      double a = double.parse(_aController.text);
                      double b = double.parse(_bController.text);
                      double c = double.parse(_cController.text);
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SecondScreen(
                            a: a,
                            b: b,
                            c: c,
                          ),
                        ),
                      );
                    } else if (!_agreeToProcess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Необходимо согласие на обработку данных'),
                        ),
                      );
                    }
                  },
                  child: const Text('Решить уравнение'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _aController.dispose();
    _bController.dispose();
    _cController.dispose();
    super.dispose();
  }
}

class SecondScreen extends StatelessWidget {
  final double a;
  final double b;
  final double c;

  const SecondScreen({
    super.key,
    required this.a,
    required this.b,
    required this.c,
  });

  String _solveEquation() {
    // Вычисляем дискриминант по формуле: D = b² - 4ac
    double discriminant = (b * b) - (4 * a * c);
    
    // Для отладки, покажем дискриминант
    String debugInfo = 'Дискриминант D = ${discriminant.toStringAsFixed(0)}\n\n';
    
    if (discriminant > 0) {
      // Два действительных корня
      double x1 = (-b + sqrt(discriminant)) / (2 * a);
      double x2 = (-b - sqrt(discriminant)) / (2 * a);
      return '$debugInfo Уравнение имеет два корня:\n'
           'x₁ = ${x1.toStringAsFixed(2)}\n'
           'x₂ = ${x2.toStringAsFixed(2)}';
    } else if (discriminant == 0) {
      // Один действительный корень
      double x = -b / (2 * a);
      return '$debugInfo Уравнение имеет один корень:\n'
           'x = ${x.toStringAsFixed(0)}';
    } else {
      // Нет действительных корней
      return '$debugInfo Уравнение не имеет действительных корней\n'
           '(дискриминант отрицательный)';
    }
  }

  @override
  Widget build(BuildContext context) {
    String solution = _solveEquation();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Результат решения'),
      ),
      body: Container(
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
              '${a.toStringAsFixed(0)}x² + ${b.toStringAsFixed(0)}x + ${c.toStringAsFixed(0)} = 0',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              'Решение:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  solution,
                  style: const TextStyle(fontSize: 18, height: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Вернуться назад'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}