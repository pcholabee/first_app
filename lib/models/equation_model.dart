class EquationSolution {
  final int? id;
  final double a;
  final double b;
  final double c;
  final String equationText;
  final String solutionText;
  final String discriminantText;
  final DateTime createdAt;

  EquationSolution({
    this.id,
    required this.a,
    required this.b,
    required this.c,
    required this.equationText,
    required this.solutionText,
    required this.discriminantText,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'a': a,
      'b': b,
      'c': c,
      'equation_text': equationText,
      'solution_text': solutionText,
      'discriminant_text': discriminantText,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory EquationSolution.fromMap(Map<String, dynamic> map) {
    return EquationSolution(
      id: map['id'],
      a: map['a'] as double,
      b: map['b'] as double,
      c: map['c'] as double,
      equationText: map['equation_text'] as String,
      solutionText: map['solution_text'] as String,
      discriminantText: map['discriminant_text'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}