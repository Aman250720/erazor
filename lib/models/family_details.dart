// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FamilyDetails {
  final String key;
  final String cid;
  final String name;
  final int age;
  final String gender;
  final int mobileNumber;
  FamilyDetails({
    required this.key,
    required this.cid,
    required this.name,
    required this.age,
    required this.gender,
    required this.mobileNumber,
  });

  FamilyDetails copyWith({
    String? key,
    String? cid,
    String? name,
    int? age,
    String? gender,
    int? mobileNumber,
  }) {
    return FamilyDetails(
      key: key ?? this.key,
      cid: cid ?? this.cid,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      mobileNumber: mobileNumber ?? this.mobileNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'key': key,
      'cid': cid,
      'name': name,
      'age': age,
      'gender': gender,
      'mobileNumber': mobileNumber,
    };
  }

  factory FamilyDetails.fromMap(Map<String, dynamic> map, String key) {
    return FamilyDetails(
      key: key,
      cid: map['cid'] as String,
      name: map['name'] as String,
      age: map['age'] as int,
      gender: map['gender'] as String,
      mobileNumber: map['mobileNumber'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  // factory FamilyDetails.fromJson(String source) =>
  //     FamilyDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FamilyDetails(key: $key, cid: $cid, name: $name, age: $age, gender: $gender, mobileNumber: $mobileNumber)';
  }

  @override
  bool operator ==(covariant FamilyDetails other) {
    if (identical(this, other)) return true;

    return other.key == key &&
        other.cid == cid &&
        other.name == name &&
        other.age == age &&
        other.gender == gender &&
        other.mobileNumber == mobileNumber;
  }

  @override
  int get hashCode {
    return key.hashCode ^
        cid.hashCode ^
        name.hashCode ^
        age.hashCode ^
        gender.hashCode ^
        mobileNumber.hashCode;
  }
}
