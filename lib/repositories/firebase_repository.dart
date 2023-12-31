import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erazor/common/failure.dart';
import 'package:erazor/common/type_defs.dart';
import 'package:erazor/models/booked_person.dart';
import 'package:erazor/models/booked_service.dart';
import 'package:erazor/models/customer_details.dart';
import 'package:erazor/models/family_details.dart';
import 'package:erazor/models/customer_location.dart';
import 'package:erazor/models/salon_details.dart';
import 'package:erazor/models/salon_images.dart';
import 'package:erazor/models/salon_location.dart';
import 'package:erazor/models/service_details.dart';
import 'package:erazor/models/slot_details.dart';
import 'package:erazor/providers/firebase_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final firebaseRepositoryProvider = Provider(
  (ref) => FirebaseRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    storage: ref.read(storageProvider),
  ),
);

class FirebaseRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  FirebaseRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required FirebaseStorage storage,
  })  : _auth = auth,
        _firestore = firestore,
        _storage = storage;

  CollectionReference get _customers => _firestore.collection('customers');
  CollectionReference get _salons => _firestore.collection('salons');
  CollectionReference get _services => _firestore.collection('services');
  CollectionReference get _slots => _firestore.collection('slots');
  CollectionReference get _bookedServices =>
      _firestore.collection('booked_services');
  CollectionReference get _bookedPerson =>
      _firestore.collection('booked_person');
  CollectionReference get _family => _firestore.collection('family');
  CollectionReference get _salonImages => _firestore.collection('salon_images');
  CollectionReference get _customerLocations =>
      _firestore.collection('customer_locations');
  CollectionReference get _salonLocations =>
      _firestore.collection('salon_locations');

  FutureVoid insertC(CustomerDetails customer) async {
    try {
      return right(_customers.doc(customer.cid).set(customer.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<CustomerDetails> fetchC(String uid) {
    return _customers.doc(uid).snapshots().map((event) =>
        CustomerDetails.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureVoid editC(CustomerDetails customer, String uid) async {
    try {
      return right(_customers.doc(uid).update(customer.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<SalonDetails>> fetchSalons() {
    return _salons.snapshots().map((event) => event.docs.map((e) {
          return SalonDetails.fromMap(e.data() as Map<String, dynamic>);
        }).toList());
  }

  Stream<List<ServiceDetails>> fetchServices(String uid) {
    return _services
        .where('uid', isEqualTo: uid)
        .where('enabled', isEqualTo: true)
        .orderBy('priority')
        .snapshots()
        .map((event) => event.docs.map((e) {
              return ServiceDetails.fromMap(e.data() as Map<String, dynamic>);
            }).toList());
  }

  Stream<SalonDetails> fetchSalon(String uid) {
    return _salons.doc(uid).snapshots().map(
        (event) => SalonDetails.fromMap(event.data() as Map<String, dynamic>));
  }

  Stream<List<SlotDetails>> fetchSlots(
      String uid, String employee, Timestamp slotDate) {
    return _slots
        .where('uid', isEqualTo: uid)
        .where('employee', isEqualTo: employee)
        .where('slotDate', isEqualTo: slotDate)
        .where('enabled', isEqualTo: true)
        .where('booked', isEqualTo: false)
        .orderBy('slotTime')
        .snapshots()
        .map((event) => event.docs.map((e) {
              return SlotDetails.fromMap(
                  e.data() as Map<String, dynamic>, e.id);
            }).toList());
  }

  FutureVoid insertBookedService(BookedService bookedService) async {
    try {
      return right(_bookedServices.doc().set(bookedService.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid deleteBookedService(String key) async {
    try {
      return right(_bookedServices.doc(key).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid insertBookedPerson(BookedPerson bookedPerson) async {
    try {
      return right(_bookedPerson.doc().set(bookedPerson.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid deleteBookedPerson(String key) async {
    try {
      return right(_bookedPerson.doc(key).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid bookSlot(String key, bool booked, String bid, String cid) async {
    try {
      return right(
          _slots.doc(key).update({'booked': booked, 'bid': bid, 'cid': cid}));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid cancelSlot(String key) async {
    try {
      return right(
          _slots.doc(key).update({'booked': false, 'bid': '', 'cid': ''}));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid insertFamily(FamilyDetails familyDetails) async {
    try {
      return right(_family.doc().set(familyDetails.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<FamilyDetails>> fetchFamily(String uid) {
    return _family
        .where('cid', isEqualTo: uid)
        .snapshots()
        .map((event) => event.docs.map((e) {
              return FamilyDetails.fromMap(
                  e.data() as Map<String, dynamic>, e.id);
            }).toList());
  }

  FutureVoid editFamily(FamilyDetails member, String key) async {
    try {
      return right(_family.doc(key).update(member.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid deleteFamily(String key) async {
    try {
      return right(_family.doc(key).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<SlotDetails>> fetchBookedSlots(String cid) {
    return _slots
        .where('cid', isEqualTo: cid)
        .where('booked', isEqualTo: true)
        .orderBy('slotDate')
        .orderBy('slotTime')
        .snapshots()
        .map((event) => event.docs.map((e) {
              return SlotDetails.fromMap(
                  e.data() as Map<String, dynamic>, e.id);
            }).toList());
  }

  Stream<List<SlotDetails>> fetchSlotsWithBID(String bid) {
    return _slots
        .where('bid', isEqualTo: bid)
        .where('booked', isEqualTo: true)
        .orderBy('slotDate')
        .orderBy('slotTime')
        .snapshots()
        .map((event) => event.docs.map((e) {
              return SlotDetails.fromMap(
                  e.data() as Map<String, dynamic>, e.id);
            }).toList());
  }

  Stream<List<BookedService>> fetchServicesWithBID(String bid) {
    return _bookedServices
        .where('bid', isEqualTo: bid)
        .snapshots()
        .map((event) => event.docs.map((e) {
              return BookedService.fromMap(
                  e.data() as Map<String, dynamic>, e.id);
            }).toList());
  }

  Stream<List<BookedPerson>> fetchPersonWithBID(String bid) {
    return _bookedPerson
        .where('bid', isEqualTo: bid)
        .snapshots()
        .map((event) => event.docs.map((e) {
              return BookedPerson.fromMap(
                  e.data() as Map<String, dynamic>, e.id);
            }).toList());
  }

  Stream<List<SalonImageDetails>> fetchSalonImages(String uid) {
    return _salonImages
        .where('uid', isEqualTo: uid)
        .orderBy('order')
        .orderBy('date')
        .snapshots()
        .map((event) => event.docs.map((e) {
              return SalonImageDetails.fromMap(
                  e.data() as Map<String, dynamic>, e.id);
            }).toList());
  }

  FutureVoid updateToken(String cid, String token) async {
    try {
      return right(_customers.doc(cid).update({'token': token}));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid insertLocation(CustomerLocationDetails location) async {
    try {
      return right(_customerLocations.doc().set(location.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<CustomerLocationDetails>> fetchCustomerLocations(String uid) {
    return _customerLocations
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((event) => event.docs.map((e) {
              return CustomerLocationDetails.fromMap(
                  e.data() as Map<String, dynamic>, e.id);
            }).toList());
  }

  Stream<List<SalonLocationDetails>> fetchSalonLocations(LatLng latLng) {
    GeoFlutterFire geo = GeoFlutterFire();
    GeoFirePoint center =
        geo.point(latitude: latLng.latitude, longitude: latLng.longitude);
    double radius = 20;

    return geo
        .collection(collectionRef: _salonLocations)
        .within(center: center, radius: radius, field: 'salonGeopoint')
        .map((event) {
      return event.map((e) {
        print('yodadadada');
        print('yoda ${e.data()}');
        return SalonLocationDetails.fromMap(e.data() as Map<String, dynamic>);
      }).toList();
    });

    // return unsorted
    // .sort((a, b) {
    //   return center
    //       .distance(
    //           lat: a.geoPoint['geopoint'].latitude, lng: a.geoPoint['geopoint'].longitude)
    //       .compareTo(center.distance(
    //           lat: b.geoPoint['geopoint'].latitude,
    //           lng: b.geoPoint['geopoint'].longitude));
    // });
  }

  FutureVoid editLocation(
      String houseNumber, String locality, String key) async {
    try {
      return right(_customerLocations
          .doc(key)
          .update({'houseNumber': houseNumber, 'locality': locality}));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid deleteLocation(String key) async {
    try {
      return right(_customerLocations.doc(key).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
