import 'package:erazor/models/salon_details.dart';
import 'package:erazor/ui/BookingConfirmation.dart';
import 'package:erazor/ui/BookingSummary.dart';
import 'package:erazor/ui/GoogleMaps.dart';
import 'package:erazor/ui/HomeScreen.dart';
import 'package:erazor/ui/LoginScreen.dart';
import 'package:erazor/ui/MainScreen.dart';
import 'package:erazor/ui/ManageAddress.dart';
import 'package:erazor/ui/ManageFamily.dart';
import 'package:erazor/ui/ManageProfile.dart';
import 'package:erazor/ui/SalonScreen.dart';
import 'package:erazor/ui/SignupScreen.dart';
import 'package:erazor/ui/SlotsScreen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
});

final unregisteredRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: SignupScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: MainScreen()),
  '/salon': (routeData) => const MaterialPage(child: SalonScreen()),
  '/slots': (_) => const MaterialPage(child: SlotsScreen()),
  '/booking_summary': (_) => const MaterialPage(child: BookingSummary()),
  '/booking_confirmation': (_) =>
      const MaterialPage(child: BookingConfirmation()),
  '/manage_family': (_) => const MaterialPage(child: ManageFamily()),
  '/manage_profile': (_) => const MaterialPage(child: ManageProfile()),
  '/manage_address': (_) => const MaterialPage(child: ManageAddress()),
  '/google_maps': (_) => const MaterialPage(child: GoogleMapScreen()),
});
