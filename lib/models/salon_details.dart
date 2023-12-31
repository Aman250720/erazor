// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:erazor/models/employee_details.dart';

class SalonDetails {
  final String cid;
  final String salonName;
  final String ownerName;
  final int mobileNumber;
  final String gpsLocation;
  final String state;
  final String city;
  final String address;
  final int pincode;
  final String openingTime;
  final String closingTime;
  final int slotInterval;
  final int seatingCapacity;
  final String genderType;
  final String token;
  //final List<Map<String, String>> employees;
  final List<EmployeeDetails> employees;
  SalonDetails({
    required this.cid,
    required this.salonName,
    required this.ownerName,
    required this.mobileNumber,
    required this.gpsLocation,
    required this.state,
    required this.city,
    required this.address,
    required this.pincode,
    required this.openingTime,
    required this.closingTime,
    required this.slotInterval,
    required this.seatingCapacity,
    required this.genderType,
    required this.token,
    required this.employees,
  });

  SalonDetails copyWith({
    String? cid,
    String? salonName,
    String? ownerName,
    int? mobileNumber,
    String? gpsLocation,
    String? state,
    String? city,
    String? address,
    int? pincode,
    String? openingTime,
    String? closingTime,
    int? slotInterval,
    int? seatingCapacity,
    String? genderType,
    String? token,
    List<EmployeeDetails>? employees,
  }) {
    return SalonDetails(
      cid: cid ?? this.cid,
      salonName: salonName ?? this.salonName,
      ownerName: ownerName ?? this.ownerName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      gpsLocation: gpsLocation ?? this.gpsLocation,
      state: state ?? this.state,
      city: city ?? this.city,
      address: address ?? this.address,
      pincode: pincode ?? this.pincode,
      openingTime: openingTime ?? this.openingTime,
      closingTime: closingTime ?? this.closingTime,
      slotInterval: slotInterval ?? this.slotInterval,
      seatingCapacity: seatingCapacity ?? this.seatingCapacity,
      genderType: genderType ?? this.genderType,
      token: token ?? this.token,
      employees: employees ?? this.employees,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cid': cid,
      'salonName': salonName,
      'ownerName': ownerName,
      'mobileNumber': mobileNumber,
      'gpsLocation': gpsLocation,
      'state': state,
      'city': city,
      'address': address,
      'pincode': pincode,
      'openingTime': openingTime,
      'closingTime': closingTime,
      'slotInterval': slotInterval,
      'seatingCapacity': seatingCapacity,
      'genderType': genderType,
      'token': token,
      'employees': employees.map((x) => x.toMap()).toList(),
    };
  }

  factory SalonDetails.fromMap(Map<String, dynamic> map) {
    final list = map['employees'] as List;
    final List<EmployeeDetails> newList = [];
    for (var element in list) {
      newList.add(EmployeeDetails(
          name: element.values.elementAt(1),
          gender: element.values.elementAt(0)));
    }
    return SalonDetails(
        cid: map['cid'] as String,
        salonName: map['salonName'] as String,
        ownerName: map['ownerName'] as String,
        mobileNumber: map['mobileNumber'] as int,
        gpsLocation: map['gpsLocation'] as String,
        state: map['state'] as String,
        city: map['city'] as String,
        address: map['address'] as String,
        pincode: map['pincode'] as int,
        openingTime: map['openingTime'] as String,
        closingTime: map['closingTime'] as String,
        slotInterval: map['slotInterval'] as int,
        seatingCapacity: map['seatingCapacity'] as int,
        genderType: map['genderType'] as String,
        token: map['token'] as String,
        employees: newList
        // List<EmployeeDetails>.from(
        //   (map['employees'] as List<int>).map<EmployeeDetails>(
        //     (x) => EmployeeDetails.fromMap(x as Map<String, dynamic>),
        //   ),
        // ),
        );
  }

  String toJson() => json.encode(toMap());

  factory SalonDetails.fromJson(String source) =>
      SalonDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SalonDetails(cid: $cid, salonName: $salonName, ownerName: $ownerName, mobileNumber: $mobileNumber, gpsLocation: $gpsLocation, state: $state, city: $city, address: $address, pincode: $pincode, openingTime: $openingTime, closingTime: $closingTime, slotInterval: $slotInterval, seatingCapacity: $seatingCapacity, genderType: $genderType, token: $token, employees: $employees)';
  }

  @override
  bool operator ==(covariant SalonDetails other) {
    if (identical(this, other)) return true;

    return other.cid == cid &&
        other.salonName == salonName &&
        other.ownerName == ownerName &&
        other.mobileNumber == mobileNumber &&
        other.gpsLocation == gpsLocation &&
        other.state == state &&
        other.city == city &&
        other.address == address &&
        other.pincode == pincode &&
        other.openingTime == openingTime &&
        other.closingTime == closingTime &&
        other.slotInterval == slotInterval &&
        other.seatingCapacity == seatingCapacity &&
        other.genderType == genderType &&
        other.token == token &&
        listEquals(other.employees, employees);
  }

  @override
  int get hashCode {
    return cid.hashCode ^
        salonName.hashCode ^
        ownerName.hashCode ^
        mobileNumber.hashCode ^
        gpsLocation.hashCode ^
        state.hashCode ^
        city.hashCode ^
        address.hashCode ^
        pincode.hashCode ^
        openingTime.hashCode ^
        closingTime.hashCode ^
        slotInterval.hashCode ^
        seatingCapacity.hashCode ^
        genderType.hashCode ^
        token.hashCode ^
        employees.hashCode;
  }
}
