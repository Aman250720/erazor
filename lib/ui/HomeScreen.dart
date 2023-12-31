import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:erazor/common/error_text.dart';
import 'package:erazor/common/loader.dart';
import 'package:erazor/controllers/firebase_controller.dart';
import 'package:erazor/models/customer_location.dart';
import 'package:erazor/models/salon_details.dart';
import 'package:erazor/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:routemaster/routemaster.dart';

//final currentLocationProvider = StateProvider<Position?>((ref) => null);
final currentLocationProvider = StateProvider<LatLng?>((ref) => null);

final currentAddressProvider = StateProvider<String?>((ref) => null);

final currentLocationProviderFixed = StateProvider<LatLng?>((ref) => null);

final currentAddressProviderFixed = StateProvider<String?>((ref) => null);

final displayAddress = StateProvider<CustomerLocationDetails?>((ref) => null);

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  //
  bool? serviceEnabled;
  LocationPermission? permission;
  Position? _currentPosition;
  LatLng? latLng;
  GeoFirePoint? center;
  bool isLoading = true;
  //
  //CustomerLocationDetails? displayLocation;
  List<String> listUid = [];

  int x = 5;

  GeoFlutterFire geo = GeoFlutterFire();

  Future<bool> _handleLocationPermission() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled!) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          'Location services are disabled. Please enable the services',
          style: Theme.of(context).textTheme.labelSmall,
        )));
      }
      await Geolocator.openLocationSettings();
      serviceEnabled = await Geolocator.isLocationServiceEnabled();

      setState(() {});
      //return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
            'Location permissions are denied',
            style: Theme.of(context).textTheme.labelSmall,
          )));
        }
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          'Location permissions are permanently denied, we cannot request permissions.',
          style: Theme.of(context).textTheme.labelSmall,
        )));
      }
      return false;
    }

    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;

    await Geolocator.getLastKnownPosition().then((position) {
      setState(() {
        latLng = LatLng(position!.latitude, position.longitude);
        center =
            geo.point(latitude: latLng!.latitude, longitude: latLng!.longitude);

        _currentPosition = position;
        ref
            .watch(currentLocationProvider.notifier)
            .update((state) => LatLng(position.latitude, position.longitude));
        ref
            .watch(currentLocationProviderFixed.notifier)
            .update((state) => LatLng(position.latitude, position.longitude));
        //_center = LatLng(position.latitude, position.longitude);
      });
    }).catchError((e) {
      debugPrint(e);
    });
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        latLng = LatLng(position.latitude, position.longitude);
        center =
            geo.point(latitude: latLng!.latitude, longitude: latLng!.longitude);

        _currentPosition = position;
        ref
            .watch(currentLocationProvider.notifier)
            .update((state) => LatLng(position.latitude, position.longitude));
        ref
            .watch(currentLocationProviderFixed.notifier)
            .update((state) => LatLng(position.latitude, position.longitude));
        //_center = LatLng(position.latitude, position.longitude);
      });
      //_getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });

    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((value) {
      ref.watch(currentAddressProvider.notifier).update((state) =>
          '${value[0].street}, ${value[0].subLocality}, ${value[0].locality}, ${value[0].administrativeArea}');
      ref.watch(currentAddressProviderFixed.notifier).update((state) =>
          '${value[0].street}, ${value[0].subLocality}, ${value[0].locality}, ${value[0].administrativeArea}');
    }).catchError((e) {
      debugPrint(e);
    });
  }

  //void orderCustomerLocations() {}

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    if (latLng != null) {
      isLoading = false;
    }

    CustomerLocationDetails? displayLocation = ref.watch(displayAddress);
    return isLoading
        ? const Loader()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            //child: SingleChildScrollView(
            child: ref.watch(customerLocationsProvider).when(
                data: (data) {
                  data.sort((a, b) {
                    return center!
                        .distance(
                            lat: a.geoPoint['geopoint'].latitude,
                            lng: a.geoPoint['geopoint'].longitude)
                        .compareTo(center!.distance(
                            lat: b.geoPoint['geopoint'].latitude,
                            lng: b.geoPoint['geopoint'].longitude));
                  });

                  // print('sexy ${data[0].geoPoint['geopoint'].longitude}');

                  if (data.isNotEmpty && displayLocation == null) {
                    displayLocation = data[0];
                  }

                  Future(() {
                    if (data.isNotEmpty && displayLocation == null) {
                      ref
                          .watch(displayAddress.notifier)
                          .update((state) => data[0]);
                    }
                  });
                  // if (data.isEmpty) {
                  //   x++;
                  //   print('yeey +$x');
                  //   Future.delayed(const Duration(milliseconds: 10), () {
                  //     showDialog(
                  //         //barrierColor: Colors.white,
                  //         barrierDismissible: false,
                  //         context: context,
                  //         builder: (context) {
                  //           return Dialog(
                  //             shape: RoundedRectangleBorder(
                  //                 borderRadius: BorderRadius.circular(10)),
                  //             child: Padding(
                  //               padding: const EdgeInsets.all(16.0),
                  //               child: Column(
                  //                 mainAxisSize: MainAxisSize.min,
                  //                 children: [
                  //                   ElevatedButton(
                  //                     onPressed: () {
                  //                       Routemaster.of(context).pop();
                  //                       Routemaster.of(context)
                  //                           .push('/google_maps');
                  //                     },
                  //                     child: Text(
                  //                       'Add your location',
                  //                       style: Theme.of(context)
                  //                           .textTheme
                  //                           .labelSmall,
                  //                     ),
                  //                   )
                  //                 ],
                  //               ),
                  //             ),
                  //           );
                  //         });
                  //   });
                  // }

                  //displayLocation ??= data[0];
                  return data.isNotEmpty
                      ? SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Dialog(
                                              insetPadding:
                                                  const EdgeInsets.all(24.0),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      'Saved addresses:',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium,
                                                    ),
                                                    const Divider(
                                                      height: 20,
                                                    ),
                                                    ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemCount: data.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                ref
                                                                    .watch(displayAddress
                                                                        .notifier)
                                                                    .update((state) =>
                                                                        data[
                                                                            index]);
                                                                // displayLocation =
                                                                //     data[index];
                                                                // ref
                                                                //     .watch(
                                                                //         displayAddress
                                                                //             .notifier)
                                                                //     .update((state) =>
                                                                //         data[index]);
                                                              });
                                                              Routemaster.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  const Icon(
                                                                    Icons
                                                                        .arrow_drop_down,
                                                                    color:
                                                                        Blue001,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Text(
                                                                    '${data[index].houseNumber} | ${data[index].locality}',
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodySmall,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                          // ListTile(
                                                          //   titleAlignment:
                                                          //       ListTileTitleAlignment
                                                          //           .center,
                                                          //   leading: const Icon(
                                                          //       Icons.arrow_drop_down),
                                                          //   title: Text(
                                                          //       '${data[index].houseNumber} | ${data[index].locality}'),
                                                          //   onTap: () {
                                                          //     displayLocation =
                                                          //         data[index];
                                                          //   },
                                                          // );
                                                        }),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          if (serviceEnabled! &&
                                                              (permission ==
                                                                      LocationPermission
                                                                          .whileInUse ||
                                                                  permission ==
                                                                      LocationPermission
                                                                          .always) &&
                                                              _currentPosition !=
                                                                  null) {
                                                            ref
                                                                .watch(
                                                                    currentLocationProvider
                                                                        .notifier)
                                                                .update((state) =>
                                                                    ref.watch(
                                                                        currentLocationProviderFixed));
                                                            ref
                                                                .watch(
                                                                    currentAddressProvider
                                                                        .notifier)
                                                                .update((state) =>
                                                                    ref.watch(
                                                                        currentAddressProviderFixed));
                                                            Routemaster.of(
                                                                    context)
                                                                .push(
                                                                    '/google_maps');
                                                          } else {
                                                            _handleLocationPermission();
                                                          }
                                                          Routemaster.of(
                                                                  context)
                                                              .pop();
                                                        },
                                                        child: Text(
                                                          'Add another address',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .labelSmall,
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on,
                                              color: Blue001,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              displayLocation?.houseNumber ??
                                                  '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            )
                                          ],
                                        ),
                                        Text(
                                          displayLocation?.locality ?? '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 24),
                                    child: Image.asset(
                                      'assets/images/erazor.png',
                                      width: 110,
                                      color: Blue001,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextField(
                                style: Theme.of(context).textTheme.displaySmall,
                                decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 14, horizontal: 0),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Blue001, width: 2),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      color: Blue001,
                                    ),
                                    suffixIcon: const Icon(
                                      Icons.clear,
                                      color: Blue001,
                                    ),
                                    hintText: 'Salon name or service...',
                                    hintStyle:
                                        Theme.of(context).textTheme.bodySmall,
                                    border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)))),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              // const Divider(
                              //   indent: 15,
                              //   endIndent: 15,
                              // ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 60, child: Divider()),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Salons around you',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const SizedBox(width: 60, child: Divider()),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              //
                              ref
                                  .watch(salonLocationsProvider(LatLng(
                                      displayLocation!
                                          .geoPoint['geopoint'].latitude,
                                      displayLocation!
                                          .geoPoint['geopoint'].longitude)))
                                  .when(
                                      data: (locations) {
                                        return ListView.builder(
                                            itemCount: locations.length,
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, int i) {
                                              double distance = geo
                                                  .point(
                                                      latitude: displayLocation!
                                                          .geoPoint['geopoint']
                                                          .latitude,
                                                      longitude:
                                                          displayLocation!
                                                              .geoPoint[
                                                                  'geopoint']
                                                              .longitude)
                                                  .haversineDistance(
                                                      lat: locations[i]
                                                          .geoPoint['geopoint']
                                                          .latitude,
                                                      lng: locations[i]
                                                          .geoPoint['geopoint']
                                                          .longitude);
                                              return ref
                                                  .watch(salonProvider(
                                                      locations[i].uid))
                                                  .when(
                                                      data: (value) {
                                                        return Column(
                                                          children: [
                                                            InkWell(
                                                                onTap: () {
                                                                  ref
                                                                      .watch(salonLocal
                                                                          .notifier)
                                                                      .update((state) =>
                                                                          value);
                                                                  Routemaster.of(
                                                                          context)
                                                                      .push(
                                                                          '/salon');
                                                                },
                                                                child: SalonItem(
                                                                    distance:
                                                                        distance,
                                                                    salon:
                                                                        value)),
                                                            const SizedBox(
                                                              height: 24,
                                                            )
                                                          ],
                                                        );
                                                      },
                                                      error:
                                                          (error, stackTrace) {
                                                        return ErrorText(
                                                            error: error
                                                                .toString());
                                                      },
                                                      loading: () =>
                                                          Container());
                                            });

                                        // final list = locations.sort((a, b) {
                                        //   return center
                                        //       .distance(
                                        //           lat: a.geoPoint['geopoint']
                                        //               .latitude,
                                        //           lng: a.geoPoint['geopoint']
                                        //               .longitude)
                                        //       .compareTo(center.distance(
                                        //           lat: b.geoPoint['geopoint']
                                        //               .latitude,
                                        //           lng: b.geoPoint['geopoint']
                                        //               .longitude));
                                        // });
                                      },
                                      error: (error, stackTrace) {
                                        return ErrorText(
                                            error: error.toString());
                                      },
                                      loading: () => Container()),
                              /*
                            ref.watch(salonsProvider).when(
                                  data: (data) {
                                    return ListView.builder(
                                        itemCount: data.length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, int i) {
                                          return InkWell(
                                              onTap: () {
                                                ref
                                                    .watch(salonLocal.notifier)
                                                    .update((state) => data[i]);
                                                Routemaster.of(context)
                                                    .push('/salon');
                                              },
                                              child: SalonItem(salon: data[i]));
                                        });
                                  },
                                  error: (error, stackTrace) =>
                                      ErrorText(error: error.toString()),
                                  loading: () => const Loader(),
                                ),
                                */
                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        )
                      : SizedBox(
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    Routemaster.of(context)
                                        .push('/google_maps');
                                  },
                                  child: Text(
                                    'Add your location',
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  )),
                            ],
                          ),
                        );
                },
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString()),
                loading: () => const Center(child: Loader()))
            //),
            );
  }
}

class SalonItem extends ConsumerWidget {
  final SalonDetails salon;
  final double distance;

  const SalonItem({super.key, required this.salon, required this.distance});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int random = Random().nextInt(10);
    return Stack(children: [
      Card(
        elevation: 5,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Column(
          children: [
            ref.watch(salonImagesProvider(salon.cid)).when(
                  data: (data) {
                    return data.isNotEmpty
                        ? CarouselSlider(
                            items: data.map((e) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15)),
                                      image: DecorationImage(
                                        image: NetworkImage(e.url),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                            options: CarouselOptions(
                              enableInfiniteScroll: data.length > 1,
                              viewportFraction: 1,
                              aspectRatio: 4 / 3,
                              //height: 200,
                              autoPlay: data.length > 1,
                              //enlargeCenterPage: true,
                            ))
                        : ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15)),
                            child: Image.asset('assets/images/login_img.jpeg'),
                          );
                  },
                  error: (error, stackTrace) =>
                      ErrorText(error: error.toString()),
                  //loading: () => const Center(child: Loader()),
                  loading: () => SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 4 / 3,
                    //child: const Center(child: Loader()),
                  ),
                ),
            // Image.asset(
            //   'assets/images/login_img.jpeg',
            //   //width: double.infinity,
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        salon.salonName,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        '${distance.toStringAsFixed(1)} km',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '4.$random',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const Icon(
                        Icons.star,
                        color: Blue001,
                        size: 20,
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          //color: Blue001,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              salon.genderType,
              style: Theme.of(context).textTheme.bodySmall,
              // style: const TextStyle(
              //   fontSize: 15,
              //   fontWeight: FontWeight.w500,
              //   //color: Colors.white,
              // ),
            ),
          ),
        ),
      )
    ]);
  }
}
