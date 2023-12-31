import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:erazor/common/error_text.dart';
import 'package:erazor/common/snackbar.dart';
import 'package:erazor/controllers/auth_controller.dart';
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
import 'package:erazor/repositories/firebase_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:routemaster/routemaster.dart';

class MyParameter extends Equatable {
  const MyParameter({
    required this.uid,
    required this.employee,
    required this.slotDate,
  });

  final String uid;
  final String employee;
  final Timestamp slotDate;

  @override
  List<Object> get props => [uid, employee, slotDate];
}

final customerDetailsProvider = StateProvider<CustomerDetails?>((ref) => null);

final salonLocal = StateProvider<SalonDetails?>((ref) => null);

final customerProvider = StreamProvider((ref) {
  return ref.watch(firebaseControllerProvider.notifier).fetchC();
});

final salonsProvider = StreamProvider((ref) {
  return ref.watch(firebaseControllerProvider.notifier).fetchSalons();
});

final servicesProvider = StreamProvider.family((ref, String uid) {
  return ref.watch(firebaseControllerProvider.notifier).fetchServices(uid);
});

final salonProvider = StreamProvider.family((ref, String uid) {
  return ref.watch(firebaseControllerProvider.notifier).fetchSalon(uid);
});

final slotsProvider =
    StreamProvider.autoDispose.family<List<SlotDetails>, MyParameter>(
  (ref, args) {
    return ref
        .watch(firebaseControllerProvider.notifier)
        .fetchSlots(args.uid, args.employee, args.slotDate);
  },
);

final familyProvider = StreamProvider((ref) {
  return ref.watch(firebaseControllerProvider.notifier).fetchFamily();
});

final bookedSlotsProvider = StreamProvider((ref) {
  return ref.watch(firebaseControllerProvider.notifier).fetchBookedSlots();
});

final slotsBIDProvider = StreamProvider.family((ref, String bid) {
  return ref.watch(firebaseControllerProvider.notifier).fetchSlotsWithBID(bid);
});

final servicesBIDProvider = StreamProvider.family((ref, String bid) {
  return ref
      .watch(firebaseControllerProvider.notifier)
      .fetchServicesWithBID(bid);
});

final personBIDProvider = StreamProvider.family((ref, String bid) {
  return ref.watch(firebaseControllerProvider.notifier).fetchPersonWithBID(bid);
});

final salonImagesProvider = StreamProvider.family((ref, String uid) {
  return ref.watch(firebaseControllerProvider.notifier).fetchSalonImages(uid);
});

final customerLocationsProvider = StreamProvider((ref) {
  return ref
      .watch(firebaseControllerProvider.notifier)
      .fetchCustomerLocations();
});

final salonLocationsProvider = StreamProvider.family((ref, LatLng latLng) {
  return ref
      .watch(firebaseControllerProvider.notifier)
      .fetchSalonLocations(latLng);
});

final firebaseControllerProvider =
    StateNotifierProvider<FirebaseController, bool>((ref) {
  final firebaseRepository = ref.watch(firebaseRepositoryProvider);
  //final storageRepository = ref.watch(storageRepositoryProvider);
  return FirebaseController(
    firebaseRepository: firebaseRepository,
    //storageRepository: storageRepository,
    ref: ref,
  );
});

class FirebaseController extends StateNotifier<bool> {
  final FirebaseRepository _firebaseRepository;
  final Ref _ref;
  //final StorageRepository _storageRepository;
  FirebaseController({
    required FirebaseRepository firebaseRepository,
    required Ref ref,
    //required StorageRepository storageRepository,
  })  : _firebaseRepository = firebaseRepository,
        _ref = ref,
        //_storageRepository = storageRepository,
        super(false);

  void insertC({
    required BuildContext context,
    required String name,
    required int age,
    required String gender,
    required int mobileNumber,
  }) async {
    state = true;
    final user = _ref.watch(authStateChangeProvider).value;
    final fcm = _ref.watch(messagingProvider);
    final token = await fcm.getToken();

    final CustomerDetails customer = CustomerDetails(
        cid: user!.uid,
        name: name,
        age: age,
        gender: gender,
        mobileNumber: mobileNumber,
        email: user.email ?? '',
        token: token ?? '');

    final res = await _firebaseRepository.insertC(customer);
    state = false;
    res.fold((l) => showSnackBar(context, 'Some error occurred!'), (r) {
      showSnackBar(context, 'Registered successfully!');
      //Routemaster.of(context).push('/');
    });
  }

  Stream<CustomerDetails> fetchC() {
    final user = _ref.watch(authStateChangeProvider).value;
    return _firebaseRepository.fetchC(user!.uid);
  }

  void editC({
    required BuildContext context,
    required String name,
    required int age,
    required String gender,
    required int mobileNumber,
  }) async {
    state = true;
    final user = _ref.watch(authStateChangeProvider).value;
    final fcm = _ref.watch(messagingProvider);
    final token = await fcm.getToken();

    final CustomerDetails customer = CustomerDetails(
        cid: user!.uid,
        name: name,
        age: age,
        gender: gender,
        mobileNumber: mobileNumber,
        email: user.email ?? '',
        token: token ?? '');

    final res = await _firebaseRepository.editC(customer, user.uid);
    state = false;
    res.fold((l) => showSnackBar(context, 'Some error occurred!'), (r) {
      showSnackBar(context, 'Profile updated!');
      //Routemaster.of(context).push('/');
      _ref.watch(customerDetailsProvider.notifier).update((state) => customer);
    });
  }

  Stream<List<SalonDetails>> fetchSalons() {
    return _firebaseRepository.fetchSalons();
  }

  Stream<List<ServiceDetails>> fetchServices(String uid) {
    return _firebaseRepository.fetchServices(uid);
  }

  Stream<SalonDetails> fetchSalon(String uid) {
    return _firebaseRepository.fetchSalon(uid);
  }

  Stream<List<SlotDetails>> fetchSlots(
      String uid, String employee, Timestamp slotDate) {
    return _firebaseRepository.fetchSlots(uid, employee, slotDate);
  }

  void insertBookedService({
    required BuildContext context,
    required String bid,
    required String serviceName,
    required int servicePrice,
    required int finalPrice,
    required int serviceDuration,
  }) async {
    state = true;
    final user = _ref.watch(authStateChangeProvider).value;

    final BookedService bookedService = BookedService(
        key: '',
        cid: user!.uid,
        bid: bid,
        serviceName: serviceName,
        servicePrice: servicePrice,
        finalPrice: finalPrice,
        serviceDuration: serviceDuration);

    final res = await _firebaseRepository.insertBookedService(bookedService);
    state = false;
    res.fold((l) => showSnackBar(context, 'Some error occurred!'), (r) {
      showSnackBar(context, 'Success!');
    });
  }

  void deleteBookedService({
    required BuildContext context,
    required String key,
  }) async {
    state = true;
    final res = await _firebaseRepository.deleteBookedService(key);
    state = false;
    res.fold((l) => showSnackBar(context, 'Some error occurred!'), (r) {
      showSnackBar(context, 'Success!');
    });
  }

  void insertBookedPerson({
    required BuildContext context,
    required String bid,
    required String name,
    required String gender,
    required int age,
    required int mobileNumber,
  }) async {
    state = true;
    final user = _ref.watch(authStateChangeProvider).value;
    final fcm = _ref.watch(messagingProvider);
    final token = await fcm.getToken();

    final BookedPerson bookedPerson = BookedPerson(
        key: '',
        cid: user!.uid,
        bid: bid,
        name: name,
        gender: gender,
        age: age,
        mobileNumber: mobileNumber,
        token: token ?? '');

    final res = await _firebaseRepository.insertBookedPerson(bookedPerson);
    state = false;
    res.fold((l) => showSnackBar(context, 'Some error occurred!'), (r) {
      showSnackBar(context, 'Success!');
    });
  }

  void deleteBookedPerson({
    required BuildContext context,
    required String key,
  }) async {
    state = true;
    final res = await _firebaseRepository.deleteBookedPerson(key);
    state = false;
    res.fold((l) => showSnackBar(context, 'Some error occurred!'), (r) {
      showSnackBar(context, 'Success!');
    });
  }

  void bookSlot(
      {required BuildContext context,
      required String key,
      required bool booked,
      required String bid}) async {
    state = true;
    final user = _ref.watch(authStateChangeProvider).value;

    final res = await _firebaseRepository.bookSlot(key, booked, bid, user!.uid);
    state = false;
    res.fold((l) => showSnackBar(context, 'Some error occurred!'), (r) {
      showSnackBar(context, 'Success!');
    });
  }

  void cancelSlot({required BuildContext context, required String key}) async {
    state = true;

    final res = await _firebaseRepository.cancelSlot(key);
    state = false;
    res.fold((l) => showSnackBar(context, 'Some error occurred!'), (r) {
      showSnackBar(context, 'Success!');
    });
  }

  void insertFamily({
    required BuildContext context,
    required String name,
    required int age,
    required String gender,
    required int mobileNumber,
  }) async {
    state = true;
    final user = _ref.watch(authStateChangeProvider).value;

    final FamilyDetails family = FamilyDetails(
        key: '',
        cid: user!.uid,
        name: name,
        age: age,
        gender: gender,
        mobileNumber: mobileNumber);

    final res = await _firebaseRepository.insertFamily(family);
    state = false;
    res.fold((l) => showSnackBar(context, 'Some error occurred!'), (r) {
      showSnackBar(context, 'Family member added!');
      //Routemaster.of(context).push('/');
    });
  }

  Stream<List<FamilyDetails>> fetchFamily() {
    final user = _ref.watch(authStateChangeProvider).value;
    return _firebaseRepository.fetchFamily(user!.uid);
  }

  void editFamily({
    required BuildContext context,
    required String key,
    required String name,
    required int age,
    required String gender,
    required int mobileNumber,
  }) async {
    state = true;
    final user = _ref.watch(authStateChangeProvider).value;

    final FamilyDetails family = FamilyDetails(
        key: key,
        cid: user!.uid,
        name: name,
        age: age,
        gender: gender,
        mobileNumber: mobileNumber);

    final res = await _firebaseRepository.editFamily(family, key);
    state = false;
    res.fold((l) => showSnackBar(context, 'Some error occurred!'), (r) {
      showSnackBar(context, 'Family member updated!');
      //Routemaster.of(context).push('/');
    });
  }

  void deleteFamily({
    required BuildContext context,
    required String key,
  }) async {
    state = true;
    final res = await _firebaseRepository.deleteFamily(key);
    state = false;
    res.fold((l) => showSnackBar(context, 'Some error occurred!'), (r) {
      showSnackBar(context, 'Member deleted!');
    });
  }

  Stream<List<SlotDetails>> fetchBookedSlots() {
    final user = _ref.watch(authStateChangeProvider).value;
    return _firebaseRepository.fetchBookedSlots(user!.uid);
  }

  Stream<List<SlotDetails>> fetchSlotsWithBID(String bid) {
    return _firebaseRepository.fetchSlotsWithBID(bid);
  }

  Stream<List<BookedService>> fetchServicesWithBID(String bid) {
    return _firebaseRepository.fetchServicesWithBID(bid);
  }

  Stream<List<BookedPerson>> fetchPersonWithBID(String bid) {
    return _firebaseRepository.fetchPersonWithBID(bid);
  }

  Stream<List<SalonImageDetails>> fetchSalonImages(String uid) {
    return _firebaseRepository.fetchSalonImages(uid);
  }

  void updateToken({required String token}) async {
    state = true;
    final user = _ref.watch(authStateChangeProvider).value;

    final res = await _firebaseRepository.updateToken(user!.uid, token);
    state = false;
    res.fold((l) => ErrorText(error: l.toString()), (r) => null);
  }

  void insertLocation({
    required BuildContext context,
    required CustomerLocationDetails location,
  }) async {
    state = true;
    final user = _ref.watch(authStateChangeProvider).value;
    final CustomerLocationDetails customerLocation = CustomerLocationDetails(
        key: '',
        uid: user!.uid,
        geoPoint: location.geoPoint,
        houseNumber: location.houseNumber,
        locality: location.locality);

    final res = await _firebaseRepository.insertLocation(customerLocation);
    state = false;
    res.fold((l) => showSnackBar(context, 'Some error occurred!'), (r) {
      showSnackBar(context, 'Address saved!');
    });
  }

  Stream<List<CustomerLocationDetails>> fetchCustomerLocations() {
    final user = _ref.watch(authStateChangeProvider).value;
    return _firebaseRepository.fetchCustomerLocations(user!.uid);
  }

  Stream<List<SalonLocationDetails>> fetchSalonLocations(LatLng latLng) {
    return _firebaseRepository.fetchSalonLocations(latLng);
  }

  void editLocation({
    required BuildContext context,
    required String key,
    required String houseNumber,
    required String locality,
  }) async {
    state = true;

    final res =
        await _firebaseRepository.editLocation(houseNumber, locality, key);
    state = false;
    res.fold((l) => showSnackBar(context, 'Some error occurred!'), (r) {
      showSnackBar(context, 'Location updated!');
      //Routemaster.of(context).push('/');
    });
  }

  void deleteLocation({
    required BuildContext context,
    required String key,
  }) async {
    state = true;
    final res = await _firebaseRepository.deleteLocation(key);
    state = false;
    res.fold((l) => showSnackBar(context, 'Some error occurred!'), (r) {
      showSnackBar(context, 'Location deleted!');
    });
  }
}
