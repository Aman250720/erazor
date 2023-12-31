import 'dart:convert';

import 'package:flutter/foundation.dart';

class SalonLocationDetails {
  final String uid;
  final Map<String, dynamic> geoPoint;
  SalonLocationDetails({
    required this.uid,
    required this.geoPoint,
  });

  SalonLocationDetails copyWith({
    String? uid,
    Map<String, dynamic>? geoPoint,
  }) {
    return SalonLocationDetails(
      uid: uid ?? this.uid,
      geoPoint: geoPoint ?? this.geoPoint,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'geoPoint': geoPoint,
    };
  }

  factory SalonLocationDetails.fromMap(Map<String, dynamic> map) {
    return SalonLocationDetails(
      uid: map['uid'] as String,
      geoPoint: map['salonGeopoint'] as Map<String, dynamic>,
    );
  }

  String toJson() => json.encode(toMap());

  factory SalonLocationDetails.fromJson(String source) =>
      SalonLocationDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SalonLocationDetails(uid: $uid, geoPoint: $geoPoint)';

  @override
  bool operator ==(covariant SalonLocationDetails other) {
    if (identical(this, other)) return true;

    return other.uid == uid && mapEquals(other.geoPoint, geoPoint);
  }

  @override
  int get hashCode => uid.hashCode ^ geoPoint.hashCode;
}
