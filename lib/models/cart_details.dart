// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:erazor/models/family_details.dart';
import 'package:erazor/models/service_details.dart';
import 'package:erazor/models/slot_details.dart';

class CartDetails {
  final int serviceCount;
  final int initialAmount;
  final int finalAmount;
  final int totalDuration;
  final List<ServiceDetails> serviceList;
  final DateTime selectedDate;
  final List<SlotDetails> slotsList;
  final FamilyDetails member;
  CartDetails({
    required this.serviceCount,
    required this.initialAmount,
    required this.finalAmount,
    required this.totalDuration,
    required this.serviceList,
    required this.selectedDate,
    required this.slotsList,
    required this.member,
  });

  CartDetails copyWith({
    int? serviceCount,
    int? initialAmount,
    int? finalAmount,
    int? totalDuration,
    List<ServiceDetails>? serviceList,
    DateTime? selectedDate,
    List<SlotDetails>? slotsList,
    FamilyDetails? member,
  }) {
    return CartDetails(
      serviceCount: serviceCount ?? this.serviceCount,
      initialAmount: initialAmount ?? this.initialAmount,
      finalAmount: finalAmount ?? this.finalAmount,
      totalDuration: totalDuration ?? this.totalDuration,
      serviceList: serviceList ?? this.serviceList,
      selectedDate: selectedDate ?? this.selectedDate,
      slotsList: slotsList ?? this.slotsList,
      member: member ?? this.member,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'serviceCount': serviceCount,
      'initialAmount': initialAmount,
      'finalAmount': finalAmount,
      'totalDuration': totalDuration,
      'serviceList': serviceList.map((x) => x.toMap()).toList(),
      'selectedDate': selectedDate,
      'slotsList': slotsList.map((x) => x.toMap()).toList(),
      'member': member.toMap(),
    };
  }

  // factory CartDetails.fromMap(Map<String, dynamic> map) {
  //   return CartDetails(
  //     serviceCount: map['serviceCount'] as int,
  //     initialAmount: map['initialAmount'] as int,
  //     finalAmount: map['finalAmount'] as int,
  //     totalDuration: map['totalDuration'] as int,
  //     serviceList: List<ServiceDetails>.from(
  //       (map['serviceList'] as List<int>).map<ServiceDetails>(
  //         (x) => ServiceDetails.fromMap(x as Map<String, dynamic>),
  //       ),
  //     ),
  //     selectedDate: map['selectedDate'] as String,
  //     slotsList: List<SlotDetails>.from(
  //       (map['slotsList'] as List<int>).map<SlotDetails>(
  //         (x) => SlotDetails.fromMap(x as Map<String, dynamic>),
  //       ),
  //     ),
  //   );
  // }

  String toJson() => json.encode(toMap());

  // factory CartDetails.fromJson(String source) =>
  //     CartDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CartDetails(serviceCount: $serviceCount, initialAmount: $initialAmount, finalAmount: $finalAmount, totalDuration: $totalDuration, serviceList: $serviceList, selectedDate: $selectedDate, slotsList: $slotsList, member: $member)';
  }

  @override
  bool operator ==(covariant CartDetails other) {
    if (identical(this, other)) return true;

    return other.serviceCount == serviceCount &&
        other.initialAmount == initialAmount &&
        other.finalAmount == finalAmount &&
        other.totalDuration == totalDuration &&
        listEquals(other.serviceList, serviceList) &&
        other.selectedDate == selectedDate &&
        listEquals(other.slotsList, slotsList) &&
        other.member == member;
  }

  @override
  int get hashCode {
    return serviceCount.hashCode ^
        initialAmount.hashCode ^
        finalAmount.hashCode ^
        totalDuration.hashCode ^
        serviceList.hashCode ^
        selectedDate.hashCode ^
        slotsList.hashCode ^
        member.hashCode;
  }
}
