import 'dart:convert';

import 'package:dart_geohash/dart_geohash.dart';
import 'package:erazor/controllers/firebase_controller.dart';
import 'package:erazor/models/customer_location.dart';
import 'package:erazor/theme/theme.dart';
import 'package:erazor/ui/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:routemaster/routemaster.dart';

// final finalLocationProvider =
//     StateProvider<LatLng>((ref) => const LatLng(0, 0));

// final finalAddressProvider = StateProvider<String>((ref) => '');

// final latlnghashProvider = StateProvider<LocationDetails>(
//     (ref) => LocationDetails(uid: '', lat: 0.0, lng: 0.0, geohash: ''));

class GoogleMapScreen extends ConsumerStatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GoogleMapScreenState();
}

class _GoogleMapScreenState extends ConsumerState<GoogleMapScreen> {
  late GoogleMapController mapController;
  var mapTextController = TextEditingController();
  //GeoHasher geohasher = GeoHasher();
  final geo = GeoFlutterFire();
  final houseController = TextEditingController();
  final sectorController = TextEditingController();

  List<dynamic> placesList = [];

  //Position? _currentPosition;

  //LatLng _center = const LatLng(28.644800, 77.216721);

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void fetchSuggestions(String input, String sessionToken) async {
    String API_KEY = 'AIzaSyD0Rt39qxznXX1nx7lWUnqrcWtHBc796us';
    String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseUrl?input=$input&key=$API_KEY&sessiontoken=$sessionToken';

    var response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      setState(() {
        placesList = jsonDecode(response.body.toString())['predictions'];
      });
    } else {
      throw Exception('Failed to load data!');
    }
  }

  @override
  void initState() {
    //_getCurrentPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String sToken = ref.watch(customerDetailsProvider)!.cid;
    //Position pos = ref.watch(currentLocationProvider)!;
    //LatLng centerFixed = ref.read(currentLocationProviderFixed)!;
    LatLng center = ref.watch(currentLocationProvider)!;

    //String currentAddressFixed = ref.read(currentAddressProviderFixed)!;
    String currentAddress = ref.watch(currentAddressProvider)!;
    //String finalAddress = ref.watch(finalAddressProvider);

    //LatLng center = LatLng(pos.latitude, pos.longitude);
    //LatLng finalCenter = ref.watch(finalLocationProvider);

    mapTextController.text = currentAddress;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30))),
          title: const Text(
            'Choose your location',
            //style: Theme.of(context).textTheme.displayMedium,
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    surfaceTintColor: Colors.white,
                    insetPadding: const EdgeInsets.all(24),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Add complete address!',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextField(
                            style: Theme.of(context).textTheme.bodySmall,
                            controller: houseController,
                            onChanged: (text) => setState(() {}),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Blue001, width: 2)),
                                label: Text(
                                  'House/Flat Number',
                                  style: Theme.of(context).textTheme.bodySmall,
                                )),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            style: Theme.of(context).textTheme.bodySmall,
                            controller: sectorController,
                            onChanged: (text) => setState(() {}),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Blue001, width: 2)),
                                label: Text(
                                  'Sector/Locality',
                                  style: Theme.of(context).textTheme.bodySmall,
                                )),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                ref
                                    .watch(firebaseControllerProvider.notifier)
                                    .insertLocation(
                                        context: context,
                                        location: CustomerLocationDetails(
                                            key: '',
                                            uid: '',
                                            geoPoint: geo
                                                .point(
                                                    latitude: center.latitude,
                                                    longitude: center.longitude)
                                                .data,
                                            houseNumber: houseController.text,
                                            locality: sectorController.text));

                                Routemaster.of(context).pop();
                                Routemaster.of(context).replace('/');
                              },
                              child: Text('Confirm Location',
                                  style:
                                      Theme.of(context).textTheme.labelSmall))
                        ],
                      ),
                    ),
                  );
                });
          },
          label: Text(
            'Add complete address',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              // markers: {
              //   Marker(
              //       markerId: const MarkerId('myLocation'),
              //       position: center,
              //       draggable: true)
              // },
              initialCameraPosition: CameraPosition(target: center, zoom: 18.0),
              onCameraMove: (position) {
                //center = position.target;
                ref
                    .watch(currentLocationProvider.notifier)
                    .update((state) => position.target);
                //mapController.animateCamera(CameraUpdate.newCameraPosition(position));
              },
              onCameraIdle: () async {
                await placemarkFromCoordinates(
                        center.latitude, center.longitude)
                    .then((value) {
                  ref.watch(currentAddressProvider.notifier).update((state) =>
                          //currentAddress =
                          '${value[0].street}, ${value[0].subLocality}, ${value[0].locality}, ${value[0].administrativeArea}'
                      //print('curr $currentAddress');
                      );
                }).catchError((e) {
                  debugPrint(e);
                });
              },
            ),
            const Center(
              child: Icon(
                Icons.location_on,
                size: 40,
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              left: 10,
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextField(
                        style: Theme.of(context).textTheme.bodySmall,
                        controller: mapTextController,
                        onChanged: (text) => setState(() {
                          ref
                              .watch(currentAddressProvider.notifier)
                              .update((state) => text);
                          //currentAddress = text;
                          fetchSuggestions(text, sToken);
                        }),
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Blue001, width: 2))),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: placesList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                placesList[index]['description'],
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              onTap: () async {
                                var locations = await locationFromAddress(
                                    placesList[index]['description']);
                                var lat = locations.first.latitude;
                                var lng = locations.first.longitude;
                                setState(() {
                                  mapController.animateCamera(
                                      CameraUpdate.newCameraPosition(
                                          CameraPosition(
                                              target: LatLng(lat, lng),
                                              zoom: 18)));
                                });
                                placesList.clear();
                              },
                            );
                          })
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
