import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:erazor/common/error_text.dart';
import 'package:erazor/common/loader.dart';
import 'package:erazor/controllers/firebase_controller.dart';
import 'package:erazor/models/booked_person.dart';
import 'package:erazor/models/booked_service.dart';
import 'package:erazor/models/salon_details.dart';
import 'package:erazor/models/slot_details.dart';
import 'package:erazor/theme/theme.dart';
import 'package:erazor/ui/SlotsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intl/intl.dart';

class Bookings extends ConsumerStatefulWidget {
  const Bookings({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookingsState();
}

class _BookingsState extends ConsumerState<Bookings> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30))),
        title: const Text('Bookings'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                    onTap: () {
                      setState(() {
                        index = 0;
                      });
                    },
                    child: Text(
                      'upcoming',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: index == 0 ? Blue001 : Colors.black,
                          letterSpacing: 0),
                    )),
                InkWell(
                    onTap: () {
                      setState(() {
                        index = 1;
                      });
                    },
                    child: Text(
                      'history',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: index == 1 ? Blue001 : Colors.black,
                          letterSpacing: 0),
                    )),
              ],
            ),
            index == 0 ? const Upcoming() : const History()
          ],
        ),
      ),
    );
  }
}

class Upcoming extends ConsumerStatefulWidget {
  const Upcoming({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpcomingState();
}

class _UpcomingState extends ConsumerState<Upcoming> {
  @override
  Widget build(BuildContext context) {
    DateTime timeNow = DateTime.now();
    String stringTime = DateFormat.Hm().format(timeNow);
    Timestamp currentDate = Timestamp.fromDate(timeNow.copyWith(
        hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0));
    //late List<SlotDetails> bookedSlots;
    List<SlotDetails> bookedSlots = [];

    List<String> list = [];

    return ref.watch(bookedSlotsProvider).when(
        data: (data) {
          bookedSlots = data;
          bookedSlots.forEach((element) {
            list.add(element.bid);
          });

          List<String> listBID = list.toSet().toList();

          return
              // cardCount != 0
              //     ?
              Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                //physics: AlwaysScrollableScrollPhysics(),
                itemCount: listBID.length,
                itemBuilder: (context, index) {
                  List<SlotDetails> tempSlots = [];
                  for (var element in bookedSlots) {
                    if (element.bid == listBID[index]) {
                      tempSlots.add(element);
                    }
                  }

                  //late List<BookedService> bookedServices;
                  List<BookedService> bookedServices = [];

                  ref
                      .watch(servicesBIDProvider(listBID[index]))
                      .whenData((value) => bookedServices = value);

                  //late BookedPerson bookedPerson;
                  BookedPerson? bookedPerson;

                  ref
                      .watch(personBIDProvider(listBID[index]))
                      .whenData((value) => bookedPerson = value[0]);

                  SalonDetails? salon;

                  ref
                      .watch(salonProvider(tempSlots[0].uid))
                      .whenData((value) => salon = value);

                  //if (
                  return (tempSlots[0].slotTime.compareTo(stringTime) == 1 &&
                              tempSlots[0].slotDate == currentDate) ||
                          (tempSlots[0].slotDate.seconds > currentDate.seconds)
                      ?
                      //) {
                      //setState(() {
                      // print('card before $cardCount');
                      // cardCount++;
                      // print('card after $cardCount');
                      //});
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 10),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(24))),
                            elevation: 10,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            tempSlots[0].salon,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          Text(
                                            DateFormat.MMMEd().format(
                                                tempSlots[0].slotDate.toDate()),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ],
                                      ),
                                      ElevatedButton(
                                          onPressed: () async {
                                            for (var element in tempSlots) {
                                              ref
                                                  .watch(
                                                      firebaseControllerProvider
                                                          .notifier)
                                                  .cancelSlot(
                                                      context: context,
                                                      key: element.key);
                                            }
                                            for (var element
                                                in bookedServices) {
                                              ref
                                                  .watch(
                                                      firebaseControllerProvider
                                                          .notifier)
                                                  .deleteBookedService(
                                                      context: context,
                                                      key: element.key);
                                            }

                                            ref
                                                .watch(
                                                    firebaseControllerProvider
                                                        .notifier)
                                                .deleteBookedPerson(
                                                    context: context,
                                                    key: bookedPerson!.key);

                                            //HttpsCallable notifySalon =
                                            // try {
                                            final notifySalon =
                                                await FirebaseFunctions
                                                        .instanceFor(
                                                            region:
                                                                'asia-south1')
                                                    .httpsCallable(
                                                        'notifySalon',
                                                        options:
                                                            HttpsCallableOptions(
                                                                timeout:
                                                                    const Duration(
                                                                        seconds:
                                                                            5)))
                                                    .call({
                                              'customer': bookedPerson!.name,
                                              'date': DateFormat.MMMEd().format(
                                                  tempSlots[0]
                                                      .slotDate
                                                      .toDate()),
                                              'time': tempSlots[0].slotTime,
                                              'token': salon!.token
                                            });
                                            print('notifysalon $notifySalon');
                                            // } on FirebaseFunctionsException catch (error) {
                                            //   print(error);
                                            // }
                                          },
                                          style: const ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Colors.black)),
                                          child: Text(
                                            'Cancel',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall,
                                          )),
                                    ],
                                  ),
                                  const Divider(
                                    height: 20,
                                  ),
                                  SizedBox(
                                    height: 80,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: tempSlots.length,
                                        itemBuilder: (context, i) {
                                          return SlotItem(
                                              time: tempSlots[i].slotTime,
                                              isSelected: true);
                                        }),
                                  ),
                                  const Divider(
                                    height: 20,
                                  ),
                                  Text(
                                    'Customer: ${bookedPerson?.name ?? ''}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '${bookedPerson?.gender ?? ''}, ${bookedPerson?.age ?? ''}',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  Text(
                                    '${bookedPerson?.mobileNumber ?? ''}',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  const Divider(
                                    height: 20,
                                  ),
                                  Text(
                                    'Stylist: ${tempSlots[0].employee}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: bookedServices.length,
                                      itemBuilder: (context, i) {
                                        return Row(
                                          children: [
                                            Text(
                                              bookedServices[i].serviceName,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              '|',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              '\u{20B9}${bookedServices[i].servicePrice}',
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.normal,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              '\u{20B9}${bookedServices[i].finalPrice}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              '|',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            const Icon(
                                              Icons.access_time,
                                              size: 15,
                                              color: Blue001,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              '${bookedServices[i].serviceDuration} mins',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                          ],
                                        );
                                      }),
                                  const SizedBox(
                                    height: 5,
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      :
                      //}
                      //else {
                      const SizedBox(
                          height: 0,
                        );
                  //}
                }),
          )
              // : Center(
              //     child: Text(
              //       'No bookings here!',
              //       style: Theme.of(context).textTheme.bodySmall,
              //     ),
              //   )
              ;
        },
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: const Loader()));
  }
}

class History extends ConsumerStatefulWidget {
  const History({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HistoryState();
}

class _HistoryState extends ConsumerState<History> {
  @override
  Widget build(BuildContext context) {
    DateTime timeNow = DateTime.now();
    String stringTime = DateFormat.Hm().format(timeNow);
    Timestamp currentDate = Timestamp.fromDate(timeNow.copyWith(
        hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0));
    //late List<SlotDetails> bookedSlots;
    List<SlotDetails> bookedSlots = [];

    List<String> list = [];

    return ref.watch(bookedSlotsProvider).when(
        data: (data) {
          bookedSlots = data;
          bookedSlots.forEach((element) {
            list.add(element.bid);
          });

          List<String> listBID = list.toSet().toList().reversed.toList();

          return
              // cardCount != 0
              //     ?
              Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                //physics: AlwaysScrollableScrollPhysics(),
                itemCount: listBID.length,
                itemBuilder: (context, index) {
                  List<SlotDetails> tempSlots = [];
                  for (var element in bookedSlots) {
                    if (element.bid == listBID[index]) {
                      tempSlots.add(element);
                    }
                  }

                  //late List<BookedService> bookedServices;
                  List<BookedService> bookedServices = [];

                  ref
                      .watch(servicesBIDProvider(listBID[index]))
                      .whenData((value) => bookedServices = value);

                  //late BookedPerson bookedPerson;
                  BookedPerson? bookedPerson;

                  ref
                      .watch(personBIDProvider(listBID[index]))
                      .whenData((value) => bookedPerson = value[0]);

                  SalonDetails? salon;

                  ref
                      .watch(salonProvider(tempSlots[0].uid))
                      .whenData((value) => salon = value);

                  //if (
                  return (tempSlots[0].slotTime.compareTo(stringTime) == -1 &&
                              tempSlots[0].slotDate == currentDate) ||
                          (tempSlots[0].slotDate.seconds < currentDate.seconds)
                      ?
                      //) {
                      //setState(() {
                      // print('card before $cardCount');
                      // cardCount++;
                      // print('card after $cardCount');
                      //});
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 10),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(24))),
                            elevation: 10,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            tempSlots[0].salon,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          Text(
                                            DateFormat.MMMEd().format(
                                                tempSlots[0].slotDate.toDate()),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ],
                                      ),
                                      // Important stuff
                                      // ElevatedButton(
                                      //     onPressed: () {},
                                      //     style: const ButtonStyle(
                                      //         backgroundColor:
                                      //             MaterialStatePropertyAll(
                                      //                 Colors.black)),
                                      //     child: Text(
                                      //       tempSlots[0].status,
                                      //       style: Theme.of(context)
                                      //           .textTheme
                                      //           .labelSmall,
                                      //     )),
                                    ],
                                  ),
                                  const Divider(
                                    height: 20,
                                  ),
                                  SizedBox(
                                    height: 80,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: tempSlots.length,
                                        itemBuilder: (context, i) {
                                          return SlotItem(
                                              time: tempSlots[i].slotTime,
                                              isSelected: true);
                                        }),
                                  ),
                                  // const SingleChildScrollView(
                                  //   scrollDirection: Axis.horizontal,
                                  //   child: Row(
                                  //     children: [
                                  //       SlotItem(time: '09:30', isSelected: true),
                                  //       SlotItem(time: '10:00', isSelected: true),
                                  //       SlotItem(time: '10:30', isSelected: true),
                                  //     ],
                                  //   ),
                                  // ),
                                  const Divider(
                                    height: 20,
                                  ),
                                  Text(
                                    'Customer: ${bookedPerson?.name ?? ''}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '${bookedPerson?.gender ?? ''}, ${bookedPerson?.age ?? ''}',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  Text(
                                    '${bookedPerson?.mobileNumber ?? ''}',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  const Divider(
                                    height: 20,
                                  ),
                                  Text(
                                    'Stylist: ${tempSlots[0].employee}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: bookedServices.length,
                                      itemBuilder: (context, i) {
                                        return Row(
                                          children: [
                                            Text(
                                              bookedServices[i].serviceName,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              '|',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              '\u{20B9}${bookedServices[i].servicePrice}',
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.normal,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              '\u{20B9}${bookedServices[i].finalPrice}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              '|',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            const Icon(
                                              Icons.access_time,
                                              size: 15,
                                              color: Blue001,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              '${bookedServices[i].serviceDuration} mins',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                          ],
                                        );
                                      }),
                                  const SizedBox(
                                    height: 5,
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      :
                      //}
                      //else {
                      const SizedBox(
                          height: 0,
                        );
                  //}
                }),
          )
              // : Center(
              //     child: Text(
              //       'No bookings here!',
              //       style: Theme.of(context).textTheme.bodySmall,
              //     ),
              //   )
              ;
        },
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: const Loader()));
  }
}

// class BookingItem extends ConsumerStatefulWidget {
//   final int num;
//   const BookingItem({super.key, required this.num});
//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _BookingItemState();
// }
// class _BookingItemState extends ConsumerState<BookingItem> {
//   int cardCount = 0;
//   @override
//   Widget build(BuildContext context) {
//     DateTime timeNow = DateTime.now();
//     String stringTime = DateFormat.Hm().format(timeNow);
//     Timestamp currentDate = Timestamp.fromDate(timeNow.copyWith(
//         hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0));
//     //late List<SlotDetails> bookedSlots;
//     List<SlotDetails> bookedSlots = [];
//     List<String> list = [];
//     print('card out $cardCount');
//     return ref.watch(bookedSlotsProvider).when(
//         data: (data) {
//           bookedSlots = data;
//           bookedSlots.forEach((element) {
//             list.add(element.bid);
//           });
//           List<String> listBID = list.toSet().toList();
//           return
//               // cardCount != 0
//               //     ?
//               Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 //physics: AlwaysScrollableScrollPhysics(),
//                 itemCount: listBID.length,
//                 itemBuilder: (context, index) {
//                   List<SlotDetails> tempSlots = [];
//                   for (var element in bookedSlots) {
//                     if (element.bid == listBID[index]) {
//                       tempSlots.add(element);
//                     }
//                   }
//                   //late List<BookedService> bookedServices;
//                   List<BookedService> bookedServices = [];
//                   ref
//                       .watch(servicesBIDProvider(listBID[index]))
//                       .whenData((value) => bookedServices = value);
//                   //late BookedPerson bookedPerson;
//                   BookedPerson? bookedPerson;
//                   ref
//                       .watch(personBIDProvider(listBID[index]))
//                       .whenData((value) => bookedPerson = value[0]);
//                   SalonDetails? salon;
//                   ref
//                       .watch(salonProvider(tempSlots[0].uid))
//                       .whenData((value) => salon = value);
//                   //if (
//                   return (tempSlots[0].slotTime.compareTo(stringTime) ==
//                                   widget.num &&
//                               tempSlots[0].slotDate == currentDate) ||
//                           (widget.num == 1
//                               ? tempSlots[0].slotDate.seconds >
//                                   currentDate.seconds
//                               : tempSlots[0].slotDate.seconds <
//                                   currentDate.seconds)
//                       ?
//                       //) {
//                       //setState(() {
//                       // print('card before $cardCount');
//                       // cardCount++;
//                       // print('card after $cardCount');
//                       //});
//                       Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 0, vertical: 10),
//                           child: Card(
//                             shape: RoundedRectangleBorder(
//                                 side: BorderSide(
//                                   color: Colors.grey.shade300,
//                                 ),
//                                 borderRadius: const BorderRadius.all(
//                                     Radius.circular(24))),
//                             elevation: 10,
//                             child: Padding(
//                               padding: const EdgeInsets.all(10.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             tempSlots[0].salon,
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .bodyMedium,
//                                           ),
//                                           Text(
//                                             DateFormat.MMMEd().format(
//                                                 tempSlots[0].slotDate.toDate()),
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .bodyMedium,
//                                           ),
//                                         ],
//                                       ),
//                                       if (widget.num == 1)
//                                         ElevatedButton(
//                                             onPressed: () async {
//                                               for (var element in tempSlots) {
//                                                 ref
//                                                     .watch(
//                                                         firebaseControllerProvider
//                                                             .notifier)
//                                                     .cancelSlot(
//                                                         context: context,
//                                                         key: element.key);
//                                               }
//                                               for (var element
//                                                   in bookedServices) {
//                                                 ref
//                                                     .watch(
//                                                         firebaseControllerProvider
//                                                             .notifier)
//                                                     .deleteBookedService(
//                                                         context: context,
//                                                         key: element.key);
//                                               }
//                                               ref
//                                                   .watch(
//                                                       firebaseControllerProvider
//                                                           .notifier)
//                                                   .deleteBookedPerson(
//                                                       context: context,
//                                                       key: bookedPerson!.key);
//                                               //HttpsCallable notifySalon =
//                                               // try {
//                                               final notifySalon =
//                                                   await FirebaseFunctions
//                                                           .instanceFor(
//                                                               region:
//                                                                   'asia-south1')
//                                                       .httpsCallable(
//                                                           'notifySalon',
//                                                           options: HttpsCallableOptions(
//                                                               timeout:
//                                                                   const Duration(
//                                                                       seconds:
//                                                                           5)))
//                                                       .call({
//                                                 'customer': bookedPerson!.name,
//                                                 'date': DateFormat.MMMEd()
//                                                     .format(tempSlots[0]
//                                                         .slotDate
//                                                         .toDate()),
//                                                 'time': tempSlots[0].slotTime,
//                                                 'token': salon!.token
//                                               });
//                                               print('notifysalon $notifySalon');
//                                               // } on FirebaseFunctionsException catch (error) {
//                                               //   print(error);
//                                               // }
//                                             },
//                                             style: const ButtonStyle(
//                                                 backgroundColor:
//                                                     MaterialStatePropertyAll(
//                                                         Colors.black)),
//                                             child: Text(
//                                               'Cancel',
//                                               style: Theme.of(context)
//                                                   .textTheme
//                                                   .labelSmall,
//                                             )),
//                                       if (widget.num == -1)
//                                         ElevatedButton(
//                                             onPressed: () {},
//                                             style: const ButtonStyle(
//                                                 backgroundColor:
//                                                     MaterialStatePropertyAll(
//                                                         Colors.black)),
//                                             child: Text(
//                                               tempSlots[0].status,
//                                               style: Theme.of(context)
//                                                   .textTheme
//                                                   .labelSmall,
//                                             )),
//                                     ],
//                                   ),
//                                   const Divider(
//                                     height: 20,
//                                   ),
//                                   SizedBox(
//                                     height: 80,
//                                     child: ListView.builder(
//                                         shrinkWrap: true,
//                                         scrollDirection: Axis.horizontal,
//                                         itemCount: tempSlots.length,
//                                         itemBuilder: (context, i) {
//                                           return SlotItem(
//                                               time: tempSlots[i].slotTime,
//                                               isSelected: true);
//                                         }),
//                                   ),
//                                   // const SingleChildScrollView(
//                                   //   scrollDirection: Axis.horizontal,
//                                   //   child: Row(
//                                   //     children: [
//                                   //       SlotItem(time: '09:30', isSelected: true),
//                                   //       SlotItem(time: '10:00', isSelected: true),
//                                   //       SlotItem(time: '10:30', isSelected: true),
//                                   //     ],
//                                   //   ),
//                                   // ),
//                                   const Divider(
//                                     height: 20,
//                                   ),
//                                   Text(
//                                     'Customer: ${bookedPerson?.name ?? ''}',
//                                     style:
//                                         Theme.of(context).textTheme.bodyMedium,
//                                   ),
//                                   const SizedBox(
//                                     height: 10,
//                                   ),
//                                   Text(
//                                     '${bookedPerson?.gender ?? ''}, ${bookedPerson?.age ?? ''}',
//                                     style:
//                                         Theme.of(context).textTheme.bodySmall,
//                                   ),
//                                   Text(
//                                     '${bookedPerson?.mobileNumber ?? ''}',
//                                     style:
//                                         Theme.of(context).textTheme.bodySmall,
//                                   ),
//                                   const Divider(
//                                     height: 20,
//                                   ),
//                                   Text(
//                                     'Stylist: ${tempSlots[0].employee}',
//                                     style:
//                                         Theme.of(context).textTheme.bodyMedium,
//                                   ),
//                                   const SizedBox(
//                                     height: 10,
//                                   ),
//                                   ListView.builder(
//                                       shrinkWrap: true,
//                                       physics:
//                                           const NeverScrollableScrollPhysics(),
//                                       itemCount: bookedServices.length,
//                                       itemBuilder: (context, i) {
//                                         return Row(
//                                           children: [
//                                             Text(
//                                               bookedServices[i].serviceName,
//                                               style: Theme.of(context)
//                                                   .textTheme
//                                                   .bodySmall,
//                                             ),
//                                             const SizedBox(
//                                               width: 10,
//                                             ),
//                                             Text(
//                                               '|',
//                                               style: Theme.of(context)
//                                                   .textTheme
//                                                   .bodyMedium,
//                                             ),
//                                             const SizedBox(
//                                               width: 10,
//                                             ),
//                                             Text(
//                                               '\u{20B9}${bookedServices[i].servicePrice}',
//                                               style: const TextStyle(
//                                                   fontSize: 15,
//                                                   fontWeight: FontWeight.normal,
//                                                   decoration: TextDecoration
//                                                       .lineThrough),
//                                             ),
//                                             const SizedBox(
//                                               width: 5,
//                                             ),
//                                             Text(
//                                               '\u{20B9}${bookedServices[i].finalPrice}',
//                                               style: Theme.of(context)
//                                                   .textTheme
//                                                   .bodySmall,
//                                             ),
//                                             const SizedBox(
//                                               width: 10,
//                                             ),
//                                             Text(
//                                               '|',
//                                               style: Theme.of(context)
//                                                   .textTheme
//                                                   .bodyMedium,
//                                             ),
//                                             const SizedBox(
//                                               width: 10,
//                                             ),
//                                             const Icon(
//                                               Icons.access_time,
//                                               size: 15,
//                                               color: Blue001,
//                                             ),
//                                             const SizedBox(
//                                               width: 5,
//                                             ),
//                                             Text(
//                                               '${bookedServices[i].serviceDuration} mins',
//                                               style: Theme.of(context)
//                                                   .textTheme
//                                                   .bodySmall,
//                                             ),
//                                           ],
//                                         );
//                                       }),
//                                   const SizedBox(
//                                     height: 5,
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         )
//                       :
//                       //}
//                       //else {
//                       const SizedBox(
//                           height: 0,
//                         );
//                   //}
//                 }),
//           )
//               // : Center(
//               //     child: Text(
//               //       'No bookings here!',
//               //       style: Theme.of(context).textTheme.bodySmall,
//               //     ),
//               //   )
//               ;
//         },
//         error: (error, stackTrace) => ErrorText(error: error.toString()),
//         loading: () => SizedBox(
//             height: MediaQuery.of(context).size.height * 0.6,
//             child: const Loader()));
//   }
// }
