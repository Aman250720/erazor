// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class SlotDetails {
  final String key;
  final String uid;
  final String cid;
  final String bid;
  final Timestamp slotDate;
  final String slotTime;
  final String employee;
  final String salon;
  final bool enabled;
  final bool booked;
  final String status;
  SlotDetails({
    required this.key,
    required this.uid,
    required this.cid,
    required this.bid,
    required this.slotDate,
    required this.slotTime,
    required this.employee,
    required this.salon,
    required this.enabled,
    required this.booked,
    required this.status,
  });

  SlotDetails copyWith({
    String? key,
    String? uid,
    String? cid,
    String? bid,
    Timestamp? slotDate,
    String? slotTime,
    String? employee,
    String? salon,
    bool? enabled,
    bool? booked,
    String? status,
  }) {
    return SlotDetails(
      key: key ?? this.key,
      uid: uid ?? this.uid,
      cid: cid ?? this.cid,
      bid: bid ?? this.bid,
      slotDate: slotDate ?? this.slotDate,
      slotTime: slotTime ?? this.slotTime,
      employee: employee ?? this.employee,
      salon: salon ?? this.salon,
      enabled: enabled ?? this.enabled,
      booked: booked ?? this.booked,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'key': key,
      'uid': uid,
      'cid': cid,
      'bid': bid,
      'slotDate': slotDate,
      'slotTime': slotTime,
      'employee': employee,
      'salon': salon,
      'enabled': enabled,
      'booked': booked,
      'status': status,
    };
  }

  factory SlotDetails.fromMap(Map<String, dynamic> map, String key) {
    return SlotDetails(
      key: key,
      uid: map['uid'] as String,
      cid: map['cid'] as String,
      bid: map['bid'] as String,
      slotDate: map['slotDate'] as Timestamp,
      slotTime: map['slotTime'] as String,
      employee: map['employee'] as String,
      salon: map['salon'] as String,
      enabled: map['enabled'] as bool,
      booked: map['booked'] as bool,
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'SlotDetails(key: $key, uid: $uid, cid: $cid, bid: $bid, slotDate: $slotDate, slotTime: $slotTime, employee: $employee, salon: $salon, enabled: $enabled, booked: $booked, status: $status)';
  }

  @override
  bool operator ==(covariant SlotDetails other) {
    if (identical(this, other)) return true;

    return other.key == key &&
        other.uid == uid &&
        other.cid == cid &&
        other.bid == bid &&
        other.slotDate == slotDate &&
        other.slotTime == slotTime &&
        other.employee == employee &&
        other.salon == salon &&
        other.enabled == enabled &&
        other.booked == booked &&
        other.status == status;
  }

  @override
  int get hashCode {
    return key.hashCode ^
        uid.hashCode ^
        cid.hashCode ^
        bid.hashCode ^
        slotDate.hashCode ^
        slotTime.hashCode ^
        employee.hashCode ^
        salon.hashCode ^
        enabled.hashCode ^
        booked.hashCode ^
        status.hashCode;
  }
}
