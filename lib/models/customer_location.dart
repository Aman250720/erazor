// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class CustomerLocationDetails {
  final String key;
  final String uid;
  final Map<String, dynamic> geoPoint;
  final String houseNumber;
  final String locality;
  CustomerLocationDetails({
    required this.key,
    required this.uid,
    required this.geoPoint,
    required this.houseNumber,
    required this.locality,
  });

  CustomerLocationDetails copyWith({
    String? key,
    String? uid,
    Map<String, dynamic>? geoPoint,
    String? houseNumber,
    String? locality,
  }) {
    return CustomerLocationDetails(
      key: key ?? this.key,
      uid: uid ?? this.uid,
      geoPoint: geoPoint ?? this.geoPoint,
      houseNumber: houseNumber ?? this.houseNumber,
      locality: locality ?? this.locality,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'key': key,
      'uid': uid,
      'geoPoint': geoPoint,
      'houseNumber': houseNumber,
      'locality': locality,
    };
  }

  factory CustomerLocationDetails.fromMap(
      Map<String, dynamic> map, String key) {
    return CustomerLocationDetails(
      key: key,
      uid: map['uid'] as String,
      geoPoint: map['geoPoint'] as Map<String, dynamic>,
      houseNumber: map['houseNumber'] as String,
      locality: map['locality'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'CustomerLocationDetails(key: $key, uid: $uid, geoPoint: $geoPoint, houseNumber: $houseNumber, locality: $locality)';
  }

  @override
  bool operator ==(covariant CustomerLocationDetails other) {
    if (identical(this, other)) return true;

    return other.key == key &&
        other.uid == uid &&
        mapEquals(other.geoPoint, geoPoint) &&
        other.houseNumber == houseNumber &&
        other.locality == locality;
  }

  @override
  int get hashCode {
    return key.hashCode ^
        uid.hashCode ^
        geoPoint.hashCode ^
        houseNumber.hashCode ^
        locality.hashCode;
  }
}
