// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class SalonImageDetails {
  final String key;
  final String uid;
  final String url;
  final int order;
  final Timestamp date;
  SalonImageDetails({
    required this.key,
    required this.uid,
    required this.url,
    required this.order,
    required this.date,
  });

  SalonImageDetails copyWith({
    String? key,
    String? uid,
    String? url,
    int? order,
    Timestamp? date,
  }) {
    return SalonImageDetails(
      key: key ?? this.key,
      uid: uid ?? this.uid,
      url: url ?? this.url,
      order: order ?? this.order,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'key': key,
      'uid': uid,
      'url': url,
      'order': order,
      'date': date,
    };
  }

  factory SalonImageDetails.fromMap(Map<String, dynamic> map, String key) {
    return SalonImageDetails(
      key: key,
      uid: map['uid'] as String,
      url: map['url'] as String,
      order: map['order'] as int,
      date: map['date'] as Timestamp,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'SalonImageDetails(key: $key, uid: $uid, url: $url, order: $order, date: $date)';
  }

  @override
  bool operator ==(covariant SalonImageDetails other) {
    if (identical(this, other)) return true;

    return other.key == key &&
        other.uid == uid &&
        other.url == url &&
        other.order == order &&
        other.date == date;
  }

  @override
  int get hashCode {
    return key.hashCode ^
        uid.hashCode ^
        url.hashCode ^
        order.hashCode ^
        date.hashCode;
  }
}
