import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erazor/common/failure.dart';
import 'package:erazor/common/type_defs.dart';
import 'package:erazor/models/customer_details.dart';
import 'package:erazor/providers/firebase_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  Stream<User?> get authStateChange => _auth.authStateChanges();
  CollectionReference get _customers => _firestore.collection('customers');

  FutureEither<CustomerDetails> signInWithGoogle() async {
    try {
      UserCredential userCredential;
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        googleProvider
            .addScope('https://www.googleapis.com/auth/contacts.readonly');

        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        //if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        userCredential = await _auth.signInWithCredential(credential);
      }

      CustomerDetails customer;

      if (userCredential.additionalUserInfo!.isNewUser) {
        customer = CustomerDetails(
            cid: userCredential.user!.uid,
            name: '',
            age: 0,
            gender: '',
            mobileNumber: 0,
            email: userCredential.user!.email ?? '',
            token: '');
        await _customers.doc(userCredential.user!.uid).set(customer.toMap());
      } else {
        customer = await fetchC(userCredential.user!.uid).first;
      }
      return right(customer);
    } on FirebaseAuthException catch (e) {
      throw e.message!; // Displaying the error message
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<CustomerDetails> fetchC(String uid) {
    return _customers.doc(uid).snapshots().map((event) =>
        CustomerDetails.fromMap(event.data() as Map<String, dynamic>));
  }

  void logOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
