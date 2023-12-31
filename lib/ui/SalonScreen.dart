import 'dart:math';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:erazor/common/error_text.dart';
import 'package:erazor/common/loader.dart';
import 'package:erazor/controllers/firebase_controller.dart';
import 'package:erazor/models/cart_details.dart';
import 'package:erazor/models/family_details.dart';
import 'package:erazor/models/salon_details.dart';
import 'package:erazor/models/service_details.dart';
import 'package:erazor/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

final cartProvider = StateProvider<CartDetails>((ref) => CartDetails(
    serviceCount: 0,
    initialAmount: 0,
    finalAmount: 0,
    totalDuration: 0,
    serviceList: [],
    selectedDate: DateTime.now(),
    slotsList: [],
    member: FamilyDetails(
        key: '', cid: '', name: '', age: 0, gender: '', mobileNumber: 0)));

class SalonScreen extends ConsumerStatefulWidget {
  //final String uid;
  const SalonScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SalonScreenState();
}

class _SalonScreenState extends ConsumerState<SalonScreen> {
  int serviceCount = 0;
  int initialAmount = 0;
  int finalAmount = 0;
  int totalDuration = 0;
  List<ServiceDetails> serviceList = [];

/*
  void snacky(context) {
    final snacky = SnackBar(
        duration: const Duration(days: 1),
        behavior: SnackBarBehavior.floating,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$serviceCount services'),
                Row(
                  children: [
                    Text(
                      '\u{20B9}$initialAmount',
                      style: const TextStyle(
                          decoration: TextDecoration.lineThrough),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text('\u{20B9}$finalAmount'),
                  ],
                )
              ],
            ),
            InkWell(
                onTap: () {
                  ref.watch(cartProvider.notifier).update((state) {
                    CartDetails cart = CartDetails(
                        serviceCount: serviceCount,
                        initialAmount: initialAmount,
                        finalAmount: finalAmount,
                        totalDuration: totalDuration,
                        serviceList: serviceList,
                        selectedDate: '',
                        slotsList: []);
                    return cart;
                  });
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  Routemaster.of(context).push('/slots');
                },
                child: const Text('Next'))
          ],
        ));
    if (serviceCount > 0) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snacky);
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }
*/
  void play() async {}

  @override
  Widget build(BuildContext context) {
    SalonDetails salon = ref.watch(salonLocal)!;
    CartDetails cart = ref.watch(cartProvider);
    int random = Random().nextInt(10);

    // if (cart.serviceList.isNotEmpty) {
    //   serviceList = cart.serviceList;
    //   serviceCount = cart.serviceCount;
    //   initialAmount = cart.initialAmount;
    //   finalAmount = cart.finalAmount;
    //   totalDuration = cart.totalDuration;
    // }

    //player.setSource(AssetSource('assets/audio/audio.mp3'));

    return SafeArea(
      child: Scaffold(
        bottomSheet: serviceCount > 0
            ? BottomSheet(
                backgroundColor: Colors.white,
                onClosing: () {},
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 10,
                      color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$serviceCount services',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '\u{20B9}$initialAmount',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          decorationColor: Colors.white),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      '\u{20B9}$finalAmount',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            InkWell(
                                onTap: () {
                                  ref
                                      .watch(cartProvider.notifier)
                                      .update((state) {
                                    CartDetails cart = CartDetails(
                                        serviceCount: serviceCount,
                                        initialAmount: initialAmount,
                                        finalAmount: finalAmount,
                                        totalDuration: totalDuration,
                                        serviceList: serviceList,
                                        selectedDate: DateTime.now(),
                                        slotsList: [],
                                        member: FamilyDetails(
                                            key: '',
                                            cid: '',
                                            name: '',
                                            age: 0,
                                            gender: '',
                                            mobileNumber: 0));
                                    return cart;
                                  });
                                  //ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  Routemaster.of(context).replace('/slots');
                                },
                                child: const Text(
                                  'Next',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                )),
                          ],
                        ),
                      ),
                    ),
                  );
                })
            : null,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      salon.salonName,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      salon!.address,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          salon.genderType,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          '|',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Card(
                          color: Blue001,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            child: Row(
                              children: [
                                Text(
                                  '4.$random',
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                const Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 18,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ref.watch(salonImagesProvider(salon.cid)).when(
                  data: (data) {
                    return data.isNotEmpty
                        ? CarouselSlider(
                            items: data.map((e) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    //child: ,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(e.url),
                                          fit: BoxFit.cover),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                            options: CarouselOptions(
                              enableInfiniteScroll: data.length > 1,
                              viewportFraction: data.length > 2 ? 0.8 : 1,
                              aspectRatio: 16 / 9,
                              //height: 200,
                              autoPlay: data.length > 1,
                              enlargeCenterPage: true,
                            ))
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 16),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                'assets/images/login_img.jpeg',
                              ),
                            ),
                          );
                  },
                  error: (error, stackTrace) {
                    return ErrorText(error: error.toString());
                  },
                  loading: () => const Loader()),
              const SizedBox(
                height: 24,
              ),
              // const Padding(
              //   padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              //   child: Divider(),
              // ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(width: 100, child: Divider()),
                        Text(
                          'Services',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(width: 100, child: Divider()),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ref.watch(servicesProvider(salon.cid)).when(
                        data: (data) {
                          return data.isNotEmpty
                              ? ListView.builder(
                                  itemCount: data.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    ServiceDetails service = data[index];
                                    int discount = 100 -
                                        (service.finalPrice /
                                                service.servicePrice *
                                                100)
                                            .toInt();
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 0),
                                      child: Card(
                                        elevation: 10,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10,
                                              top: 5,
                                              right: 10,
                                              bottom: 20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Text(
                                                        service.serviceName,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium,
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                '\u{20B9}${service.servicePrice}',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .lineThrough),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(
                                                                '\u{20B9}${service.finalPrice}',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodySmall,
                                                              ),
                                                            ],
                                                          ),
                                                          Text(
                                                            '$discount% off!',
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Blue001),
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.access_time,
                                                            size: 15,
                                                            color: Blue001,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            '${service.serviceDuration} mins',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodySmall,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Stack(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    children: [
                                                      Image.asset(
                                                        'assets/images/login_img.jpeg',
                                                        height: 150,
                                                        width: 150,
                                                      ),
                                                      SizedBox(
                                                        height: 40,
                                                        width: 80,
                                                        child:
                                                            FloatingActionButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              if (serviceList
                                                                  .contains(
                                                                      service)) {
                                                                serviceCount -=
                                                                    1;
                                                                initialAmount -=
                                                                    service
                                                                        .servicePrice;
                                                                finalAmount -=
                                                                    service
                                                                        .finalPrice;
                                                                totalDuration -=
                                                                    service
                                                                        .serviceDuration;
                                                                serviceList
                                                                    .remove(
                                                                        service);

                                                                // ref
                                                                //     .watch(cartProvider)
                                                                //     .copyWith(
                                                                //       serviceCount:
                                                                //           serviceCount--,
                                                                //       initialAmount:
                                                                //           initialAmount -
                                                                //               service
                                                                //                   .servicePrice,
                                                                //       finalAmount:
                                                                //           finalAmount -
                                                                //               service
                                                                //                   .finalPrice,
                                                                //       totalDuration:
                                                                //           totalDuration -
                                                                //               service
                                                                //                   .serviceDuration,
                                                                //     );
                                                                // cart.serviceList
                                                                //     .remove(service);
                                                              } else {
                                                                serviceCount +=
                                                                    1;
                                                                initialAmount +=
                                                                    service
                                                                        .servicePrice;
                                                                finalAmount +=
                                                                    service
                                                                        .finalPrice;
                                                                totalDuration +=
                                                                    service
                                                                        .serviceDuration;
                                                                serviceList.add(
                                                                    service);

                                                                // ref
                                                                //     .watch(cartProvider)
                                                                //     .copyWith(
                                                                //       serviceCount:
                                                                //           serviceCount++,
                                                                //       initialAmount:
                                                                //           initialAmount +
                                                                //               service
                                                                //                   .servicePrice,
                                                                //       finalAmount:
                                                                //           finalAmount +
                                                                //               service
                                                                //                   .finalPrice,
                                                                //       totalDuration:
                                                                //           totalDuration +
                                                                //               service
                                                                //                   .serviceDuration,
                                                                //     );
                                                                // cart.serviceList.add(service);
                                                              }
                                                              //snacky(context);
                                                            });
                                                          },
                                                          child: serviceList
                                                                  .contains(
                                                                      service)
                                                              ? const Text(
                                                                  'Remove')
                                                              : const Text(
                                                                  'Add'),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              if (service.description !=
                                                  '') ...[
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  service.description,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                  textAlign: TextAlign.center,
                                                )
                                              ]
                                            ],
                                          ),
                                        ),
                                      ),
                                    );

                                    // ServiceItem(
                                    //   service: data[index],
                                    // );
                                  },
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 100, horizontal: 0),
                                  child: Text(
                                    'Salon is out of service!',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                );
                        },
                        error: (error, stackTrace) {
                          return ErrorText(error: error.toString());
                        },
                        loading: () => const Loader()),
                    const SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ref.watch(salonProvider(widget.uid)).when(
          //     data: (data) => Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Row(
          //               children: [
          //                 Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Text(data.salonName),
          //                     Text(data.address),
          //                   ],
          //                 )
          //               ],
          //             ),
          //             const SizedBox(
          //               height: 30,
          //             ),
          //             Image.asset('assets/images/login_img.jpeg'),
          //             const Padding(
          //               padding: EdgeInsets.symmetric(
          //                   vertical: 20, horizontal: 40),
          //               child: Divider(),
          //             ),
          //             const Text('Services'),
          //             const SizedBox(
          //               height: 20,
          //             ),
          //             ref.watch(servicesProvider(widget.uid)).when(
          //                 data: (data) => ListView.builder(
          //                       itemCount: data.length,
          //                       shrinkWrap: true,
          //                       physics:
          //                           const NeverScrollableScrollPhysics(),
          //                       itemBuilder: (context, index) {
          //                         ServiceDetails service = data[index];
          //                         return Card(
          //                           child: Padding(
          //                             padding: const EdgeInsets.only(
          //                                 left: 10,
          //                                 top: 5,
          //                                 right: 10,
          //                                 bottom: 20),
          //                             child: Row(
          //                               mainAxisAlignment:
          //                                   MainAxisAlignment.spaceAround,
          //                               crossAxisAlignment:
          //                                   CrossAxisAlignment.center,
          //                               children: [
          //                                 Column(
          //                                   crossAxisAlignment:
          //                                       CrossAxisAlignment.start,
          //                                   mainAxisAlignment:
          //                                       MainAxisAlignment
          //                                           .spaceAround,
          //                                   children: [
          //                                     Text(service.serviceName),
          //                                     const SizedBox(
          //                                       height: 10,
          //                                     ),
          //                                     Row(
          //                                       children: [
          //                                         Text(
          //                                           '\u{20B9}${service.servicePrice}',
          //                                           style: const TextStyle(
          //                                               decoration:
          //                                                   TextDecoration
          //                                                       .lineThrough),
          //                                         ),
          //                                         const SizedBox(
          //                                           width: 10,
          //                                         ),
          //                                         Text(
          //                                           '\u{20B9}${service.finalPrice}',
          //                                           style:
          //                                               const TextStyle(),
          //                                         ),
          //                                       ],
          //                                     ),
          //                                     const SizedBox(
          //                                       height: 10,
          //                                     ),
          //                                     Text(
          //                                         '${service.serviceDuration} mins'),
          //                                   ],
          //                                 ),
          //                                 Stack(
          //                                   alignment:
          //                                       Alignment.bottomCenter,
          //                                   children: [
          //                                     Image.asset(
          //                                       'assets/images/login_img.jpeg',
          //                                       height: 150,
          //                                       width: 150,
          //                                     ),
          //                                     SizedBox(
          //                                       height: 40,
          //                                       width: 80,
          //                                       child: FloatingActionButton(
          //                                         onPressed: () {
          //                                           setState(() {
          //                                             if (serviceList
          //                                                 .contains(
          //                                                     service)) {
          //                                               serviceCount -= 1;
          //                                               initialAmount -=
          //                                                   service
          //                                                       .servicePrice;
          //                                               finalAmount -=
          //                                                   service
          //                                                       .finalPrice;
          //                                               totalDuration -= service
          //                                                   .serviceDuration;
          //                                               serviceList.remove(
          //                                                   service);
          //                                             } else {
          //                                               serviceCount += 1;
          //                                               initialAmount +=
          //                                                   service
          //                                                       .servicePrice;
          //                                               finalAmount +=
          //                                                   service
          //                                                       .finalPrice;
          //                                               totalDuration += service
          //                                                   .serviceDuration;
          //                                               serviceList
          //                                                   .add(service);
          //                                             }
          //                                             snacky(context);
          //                                           });
          //                                         },
          //                                         child: serviceList
          //                                                 .contains(service)
          //                                             ? const Text('Remove')
          //                                             : const Text('Add'),
          //                                       ),
          //                                     )
          //                                   ],
          //                                 ),
          //                               ],
          //                             ),
          //                           ),
          //                         );
          //                         // ServiceItem(
          //                         //   service: data[index],
          //                         // );
          //                       },
          //                     ),
          //                 error: (error, stackTrace) {
          //                   print(error);
          //                   print(stackTrace);
          //                   return ErrorText(error: error.toString());
          //                 },
          //                 loading: () => const Loader()),
          //             const SizedBox(
          //               height: 50,
          //             ),
          //           ],
          //         ),
          //     error: (error, stackTrace) =>
          //         ErrorText(error: error.toString()),
          //     loading: () => const Loader())
        ),
      ),
    );
  }
}
