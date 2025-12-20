class Rover {
  final int id;
  final String name;
  final String landingDate;
  final String launchDate;
  final String status;

  Rover({
    required this.id,
    required this.name,
    required this.landingDate,
    required this.launchDate,
    required this.status,
  });

  factory Rover.fromJson(Map<String, dynamic> json) {
    return Rover(
      id: json['id'],
      name: json['name'],
      landingDate: json['landing_date'],
      launchDate: json['launch_date'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'landing_date': landingDate,
        'launch_date': launchDate,
        'status': status,
      };
}