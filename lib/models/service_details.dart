// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ServiceDetails {
  final String key;
  final String uid;
  final String serviceName;
  final String description;
  final String imageUrl;
  final int servicePrice;
  final int finalPrice;
  final int serviceDuration;
  final bool enabled;
  final int priority;
  ServiceDetails({
    required this.key,
    required this.uid,
    required this.serviceName,
    required this.description,
    required this.imageUrl,
    required this.servicePrice,
    required this.finalPrice,
    required this.serviceDuration,
    required this.enabled,
    required this.priority,
  });

  ServiceDetails copyWith({
    String? key,
    String? uid,
    String? serviceName,
    String? description,
    String? imageUrl,
    int? servicePrice,
    int? finalPrice,
    int? serviceDuration,
    bool? enabled,
    int? priority,
  }) {
    return ServiceDetails(
      key: key ?? this.key,
      uid: uid ?? this.uid,
      serviceName: serviceName ?? this.serviceName,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      servicePrice: servicePrice ?? this.servicePrice,
      finalPrice: finalPrice ?? this.finalPrice,
      serviceDuration: serviceDuration ?? this.serviceDuration,
      enabled: enabled ?? this.enabled,
      priority: priority ?? this.priority,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'key': key,
      'uid': uid,
      'serviceName': serviceName,
      'description': description,
      'imageUrl': imageUrl,
      'servicePrice': servicePrice,
      'finalPrice': finalPrice,
      'serviceDuration': serviceDuration,
      'enabled': enabled,
      'priority': priority,
    };
  }

  factory ServiceDetails.fromMap(Map<String, dynamic> map) {
    return ServiceDetails(
      key: map['key'] as String,
      uid: map['uid'] as String,
      serviceName: map['serviceName'] as String,
      description: map['description'] as String,
      imageUrl: map['imageUrl'] as String,
      servicePrice: map['servicePrice'] as int,
      finalPrice: map['finalPrice'] as int,
      serviceDuration: map['serviceDuration'] as int,
      enabled: map['enabled'] as bool,
      priority: map['priority'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ServiceDetails.fromJson(String source) =>
      ServiceDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ServiceDetails(key: $key, uid: $uid, serviceName: $serviceName, description: $description, imageUrl: $imageUrl, servicePrice: $servicePrice, finalPrice: $finalPrice, serviceDuration: $serviceDuration, enabled: $enabled, priority: $priority)';
  }

  @override
  bool operator ==(covariant ServiceDetails other) {
    if (identical(this, other)) return true;

    return other.key == key &&
        other.uid == uid &&
        other.serviceName == serviceName &&
        other.description == description &&
        other.imageUrl == imageUrl &&
        other.servicePrice == servicePrice &&
        other.finalPrice == finalPrice &&
        other.serviceDuration == serviceDuration &&
        other.enabled == enabled &&
        other.priority == priority;
  }

  @override
  int get hashCode {
    return key.hashCode ^
        uid.hashCode ^
        serviceName.hashCode ^
        description.hashCode ^
        imageUrl.hashCode ^
        servicePrice.hashCode ^
        finalPrice.hashCode ^
        serviceDuration.hashCode ^
        enabled.hashCode ^
        priority.hashCode;
  }
}
