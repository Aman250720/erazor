// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BookedPerson {
  final String key;
  final String cid;
  final String bid;
  final String name;
  final String gender;
  final int age;
  final int mobileNumber;
  final String token;
  BookedPerson({
    required this.key,
    required this.cid,
    required this.bid,
    required this.name,
    required this.gender,
    required this.age,
    required this.mobileNumber,
    required this.token,
  });

  BookedPerson copyWith({
    String? key,
    String? cid,
    String? bid,
    String? name,
    String? gender,
    int? age,
    int? mobileNumber,
    String? token,
  }) {
    return BookedPerson(
      key: key ?? this.key,
      cid: cid ?? this.cid,
      bid: bid ?? this.bid,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'key': key,
      'cid': cid,
      'bid': bid,
      'name': name,
      'gender': gender,
      'age': age,
      'mobileNumber': mobileNumber,
      'token': token,
    };
  }

  factory BookedPerson.fromMap(Map<String, dynamic> map, String key) {
    return BookedPerson(
      key: key,
      cid: map['cid'] as String,
      bid: map['bid'] as String,
      name: map['name'] as String,
      gender: map['gender'] as String,
      age: map['age'] as int,
      mobileNumber: map['mobileNumber'] as int,
      token: map['token'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'BookedPerson(key: $key, cid: $cid, bid: $bid, name: $name, gender: $gender, age: $age, mobileNumber: $mobileNumber, token: $token)';
  }

  @override
  bool operator ==(covariant BookedPerson other) {
    if (identical(this, other)) return true;

    return other.key == key &&
        other.cid == cid &&
        other.bid == bid &&
        other.name == name &&
        other.gender == gender &&
        other.age == age &&
        other.mobileNumber == mobileNumber &&
        other.token == token;
  }

  @override
  int get hashCode {
    return key.hashCode ^
        cid.hashCode ^
        bid.hashCode ^
        name.hashCode ^
        gender.hashCode ^
        age.hashCode ^
        mobileNumber.hashCode ^
        token.hashCode;
  }
}
