// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CustomerDetails {
  final String cid;
  final String name;
  final int age;
  final String gender;
  final int mobileNumber;
  final String email;
  final String token;
  CustomerDetails({
    required this.cid,
    required this.name,
    required this.age,
    required this.gender,
    required this.mobileNumber,
    required this.email,
    required this.token,
  });

  CustomerDetails copyWith({
    String? cid,
    String? name,
    int? age,
    String? gender,
    int? mobileNumber,
    String? email,
    String? token,
  }) {
    return CustomerDetails(
      cid: cid ?? this.cid,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      email: email ?? this.email,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cid': cid,
      'name': name,
      'age': age,
      'gender': gender,
      'mobileNumber': mobileNumber,
      'email': email,
      'token': token,
    };
  }

  factory CustomerDetails.fromMap(Map<String, dynamic> map) {
    return CustomerDetails(
      cid: map['cid'] as String,
      name: map['name'] as String,
      age: map['age'] as int,
      gender: map['gender'] as String,
      mobileNumber: map['mobileNumber'] as int,
      email: map['email'] as String,
      token: map['token'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerDetails.fromJson(String source) =>
      CustomerDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CustomerDetails(cid: $cid, name: $name, age: $age, gender: $gender, mobileNumber: $mobileNumber, email: $email, token: $token)';
  }

  @override
  bool operator ==(covariant CustomerDetails other) {
    if (identical(this, other)) return true;

    return other.cid == cid &&
        other.name == name &&
        other.age == age &&
        other.gender == gender &&
        other.mobileNumber == mobileNumber &&
        other.email == email &&
        other.token == token;
  }

  @override
  int get hashCode {
    return cid.hashCode ^
        name.hashCode ^
        age.hashCode ^
        gender.hashCode ^
        mobileNumber.hashCode ^
        email.hashCode ^
        token.hashCode;
  }
}
