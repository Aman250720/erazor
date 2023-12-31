// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BookedService {
  final String key;
  final String cid;
  final String bid;
  final String serviceName;
  final int servicePrice;
  final int finalPrice;
  final int serviceDuration;
  BookedService({
    required this.key,
    required this.cid,
    required this.bid,
    required this.serviceName,
    required this.servicePrice,
    required this.finalPrice,
    required this.serviceDuration,
  });

  BookedService copyWith({
    String? key,
    String? cid,
    String? bid,
    String? serviceName,
    int? servicePrice,
    int? finalPrice,
    int? serviceDuration,
  }) {
    return BookedService(
      key: key ?? this.key,
      cid: cid ?? this.cid,
      bid: bid ?? this.bid,
      serviceName: serviceName ?? this.serviceName,
      servicePrice: servicePrice ?? this.servicePrice,
      finalPrice: finalPrice ?? this.finalPrice,
      serviceDuration: serviceDuration ?? this.serviceDuration,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'key': key,
      'cid': cid,
      'bid': bid,
      'serviceName': serviceName,
      'servicePrice': servicePrice,
      'finalPrice': finalPrice,
      'serviceDuration': serviceDuration,
    };
  }

  factory BookedService.fromMap(Map<String, dynamic> map, String key) {
    return BookedService(
      key: key,
      cid: map['cid'] as String,
      bid: map['bid'] as String,
      serviceName: map['serviceName'] as String,
      servicePrice: map['servicePrice'] as int,
      finalPrice: map['finalPrice'] as int,
      serviceDuration: map['serviceDuration'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'BookedService(key: $key, cid: $cid, bid: $bid, serviceName: $serviceName, servicePrice: $servicePrice, finalPrice: $finalPrice, serviceDuration: $serviceDuration)';
  }

  @override
  bool operator ==(covariant BookedService other) {
    if (identical(this, other)) return true;

    return other.key == key &&
        other.cid == cid &&
        other.bid == bid &&
        other.serviceName == serviceName &&
        other.servicePrice == servicePrice &&
        other.finalPrice == finalPrice &&
        other.serviceDuration == serviceDuration;
  }

  @override
  int get hashCode {
    return key.hashCode ^
        cid.hashCode ^
        bid.hashCode ^
        serviceName.hashCode ^
        servicePrice.hashCode ^
        finalPrice.hashCode ^
        serviceDuration.hashCode;
  }
}
