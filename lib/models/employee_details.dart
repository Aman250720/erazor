import 'dart:convert';

class EmployeeDetails {
  final String name;
  final String gender;
  EmployeeDetails({
    required this.name,
    required this.gender,
  });

  EmployeeDetails copyWith({
    String? name,
    String? gender,
  }) {
    return EmployeeDetails(
      name: name ?? this.name,
      gender: gender ?? this.gender,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'gender': gender,
    };
  }

  factory EmployeeDetails.fromMap(Map<String, dynamic> map) {
    return EmployeeDetails(
      name: map['name'] as String,
      gender: map['gender'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory EmployeeDetails.fromJson(String source) =>
      EmployeeDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'EmployeeDetails(name: $name, gender: $gender)';

  @override
  bool operator ==(covariant EmployeeDetails other) {
    if (identical(this, other)) return true;

    return other.name == name && other.gender == gender;
  }

  @override
  int get hashCode => name.hashCode ^ gender.hashCode;
}
