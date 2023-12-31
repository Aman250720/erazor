import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erazor/common/error_text.dart';
import 'package:erazor/common/loader.dart';
import 'package:erazor/controllers/firebase_controller.dart';
import 'package:erazor/models/cart_details.dart';
import 'package:erazor/models/family_details.dart';
import 'package:erazor/models/salon_details.dart';
import 'package:erazor/models/slot_details.dart';
import 'package:erazor/theme/theme.dart';
import 'package:erazor/ui/SalonScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';

class SlotsScreen extends ConsumerStatefulWidget {
  const SlotsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SlotsScreenState();
}

class _SlotsScreenState extends ConsumerState<SlotsScreen> {
  final List<String> dates = [];
  final List<DateTime> actualDates = [];

  int index = 0;
  final List<SlotDetails> selectedSlots = [];
  //String selectedDate = '';
  DateTime selectedDate = DateTime.now();

  late SalonDetails salon;
  late CartDetails cart;
  late int totalSlots;

  @override
  void initState() {
    DateTime currentDate = DateTime.now().copyWith(
        hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);

    for (int i = 0; i < 7; i++) {
      dates.add(DateFormat.MMMEd().format(currentDate.add(Duration(days: i))));
      actualDates.add(currentDate.add(Duration(days: i)));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SalonDetails salon = ref.watch(salonLocal)!;
    CartDetails cart = ref.watch(cartProvider);
    int totalSlots = (cart.totalDuration / salon.slotInterval).ceil();
    late List<FamilyDetails> family;
    ref.watch(familyProvider).whenData((value) => family = value);
    final customer = ref.watch(customerDetailsProvider);

    // if (cart.slotsList.isNotEmpty) {
    //   setState(() {
    //     index = dates.indexOf(cart.selectedDate);
    //     selectedSlots.replaceRange(0, selectedSlots.length, cart.slotsList);
    //   });
    // }

    DateTime timeNow = DateTime.now();
    String stringTime = DateFormat.Hm().format(timeNow);
    Timestamp currentDate = Timestamp.fromDate(timeNow.copyWith(
        hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0));

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30))),
          title: const Text('Slots Info'),
          centerTitle: true,
        ),
        bottomSheet: BottomSheet(
            backgroundColor: Colors.white,
            onClosing: () {},
            builder: (context) {
              String text = totalSlots == 1 ? 'slot' : 'slots';

              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  elevation: 10,
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        selectedSlots.isEmpty
                            ? Text(
                                'Select $totalSlots $text!',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              )
                            : Text(
                                '$totalSlots out of $totalSlots $text selected!',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                        InkWell(
                          onTap: selectedSlots.isNotEmpty
                              ? () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          backgroundColor: Colors.white,
                                          surfaceTintColor: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    'Select a customer:',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium,
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  const Divider(),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      ref
                                                          .watch(cartProvider
                                                              .notifier)
                                                          .update((state) => CartDetails(
                                                              serviceCount: cart
                                                                  .serviceCount,
                                                              initialAmount: cart
                                                                  .initialAmount,
                                                              finalAmount: cart
                                                                  .finalAmount,
                                                              totalDuration: cart
                                                                  .totalDuration,
                                                              serviceList: cart
                                                                  .serviceList,
                                                              selectedDate:
                                                                  selectedDate,
                                                              slotsList:
                                                                  selectedSlots,
                                                              member: FamilyDetails(
                                                                  key: customer
                                                                      .cid,
                                                                  cid:
                                                                      customer
                                                                          .cid,
                                                                  name: customer
                                                                      .name,
                                                                  age: customer
                                                                      .age,
                                                                  gender: customer
                                                                      .gender,
                                                                  mobileNumber:
                                                                      customer
                                                                          .mobileNumber)));
                                                      Routemaster.of(context)
                                                          .pop();
                                                      Routemaster.of(context)
                                                          .replace(
                                                              '/booking_summary');
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Icon(
                                                          Icons.arrow_drop_down,
                                                          color: Blue001,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          customer!.name,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  for (var member
                                                      in family) ...[
                                                    GestureDetector(
                                                        onTap: () {
                                                          ref.watch(cartProvider.notifier).update((state) => CartDetails(
                                                              serviceCount: cart
                                                                  .serviceCount,
                                                              initialAmount: cart
                                                                  .initialAmount,
                                                              finalAmount: cart
                                                                  .finalAmount,
                                                              totalDuration: cart
                                                                  .totalDuration,
                                                              serviceList: cart
                                                                  .serviceList,
                                                              selectedDate:
                                                                  selectedDate,
                                                              slotsList:
                                                                  selectedSlots,
                                                              member: FamilyDetails(
                                                                  key: member
                                                                      .key,
                                                                  cid: member
                                                                      .cid,
                                                                  name: member
                                                                      .name,
                                                                  age: member
                                                                      .age,
                                                                  gender: member
                                                                      .gender,
                                                                  mobileNumber:
                                                                      member
                                                                          .mobileNumber)));
                                                          Routemaster.of(
                                                                  context)
                                                              .replace(
                                                                  '/booking_summary');
                                                          Routemaster.of(
                                                                  context)
                                                              .pop();
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Icon(
                                                              Icons
                                                                  .arrow_drop_down,
                                                              color: Blue001,
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              member.name,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodySmall,
                                                            ),
                                                          ],
                                                        )),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                  ]
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                }
                              : null,
                          child: const Text(
                            'Next',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.normal),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.17,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    InkWell(
                      child: DateItem(
                        date: dates[0],
                        isSelected: index == 0,
                      ),
                      onTap: () {
                        setState(() {
                          index = 0;
                        });
                      },
                    ),
                    InkWell(
                      child: DateItem(
                        date: dates[1],
                        isSelected: index == 1,
                      ),
                      onTap: () {
                        setState(() {
                          index = 1;
                        });
                      },
                    ),
                    InkWell(
                      child: DateItem(
                        date: dates[2],
                        isSelected: index == 2,
                      ),
                      onTap: () {
                        setState(() {
                          index = 2;
                        });
                      },
                    ),
                    InkWell(
                      child: DateItem(
                        date: dates[3],
                        isSelected: index == 3,
                      ),
                      onTap: () {
                        setState(() {
                          index = 3;
                        });
                      },
                    ),
                    InkWell(
                      child: DateItem(
                        date: dates[4],
                        isSelected: index == 4,
                      ),
                      onTap: () {
                        setState(() {
                          index = 4;
                        });
                      },
                    ),
                    InkWell(
                      child: DateItem(
                        date: dates[5],
                        isSelected: index == 5,
                      ),
                      onTap: () {
                        setState(() {
                          index = 5;
                        });
                      },
                    ),
                    InkWell(
                      child: DateItem(
                        date: dates[6],
                        isSelected: index == 6,
                      ),
                      onTap: () {
                        setState(() {
                          index = 6;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 50,
                indent: 50,
                endIndent: 50,
              ),
              Column(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      //scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: salon.employees.length,
                      itemBuilder: (context, int i) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.chair_sharp,
                                    color: Blue001,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    salon.employees[i].name,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ref
                                  .watch(slotsProvider(MyParameter(
                                      uid: salon.cid,
                                      employee: salon.employees[i].name,
                                      slotDate: Timestamp.fromDate(
                                          actualDates[index]))))
                                  .when(
                                      data: (slotList) {
                                        print('slotlist $slotList');
                                        List<SlotDetails> data = [];
                                        slotList.forEach((element) {
                                          if (((element.slotTime.compareTo(
                                                          stringTime) ==
                                                      1) &&
                                                  (element.slotDate ==
                                                      currentDate)) ||
                                              (element.slotDate.seconds >
                                                  currentDate.seconds)) {
                                            data.add(element);
                                            print('elementt $element');
                                          }
                                        });
                                        print('slotlist data $data');

                                        return data.isEmpty
                                            ? SizedBox(
                                                width: double.infinity,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'No slots available!',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall,
                                                    ),
                                                    const SizedBox(
                                                      height: 30,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                    height: 80,
                                                    child: ListView.builder(
                                                        itemCount: data.length,
                                                        shrinkWrap: true,
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemBuilder:
                                                            (context, int ind) {
                                                          // bool isSelected =
                                                          //     false;
                                                          return InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                selectedDate =
                                                                    actualDates[
                                                                        index];
                                                                if (selectedSlots
                                                                    .contains(data[
                                                                        ind])) {
                                                                  selectedSlots
                                                                      .clear();
                                                                } else {
                                                                  selectedSlots
                                                                      .clear();
                                                                  for (int i =
                                                                          0;
                                                                      i < totalSlots;
                                                                      i++) {
                                                                    selectedSlots.add(
                                                                        data[ind +
                                                                            i]);
                                                                  }
                                                                }
                                                              });
                                                            },
                                                            child: SlotItem(
                                                              time: data[ind]
                                                                  .slotTime,
                                                              isSelected:
                                                                  selectedSlots
                                                                      .contains(
                                                                          data[
                                                                              ind]),
                                                            ),
                                                          );
                                                        }),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  )
                                                ],
                                              );
                                      },
                                      error: (error, stackTrace) =>
                                          ErrorText(error: error.toString()),
                                      loading: () => const Loader())
                            ],
                          ),
                        );
                      }),
                ],
              ),
              const SizedBox(
                height: 80,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DateItem extends ConsumerWidget {
  final String date;
  final bool isSelected;
  const DateItem({super.key, required this.date, required this.isSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Card(
        elevation: 10,
        color: isSelected ? Colors.black : Colors.white,
        child: Container(
          alignment: Alignment.center,
          //width: 100,
          constraints: const BoxConstraints(minWidth: 100),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
            child: Text(
              date,
              style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ),
      ),
    );
  }
}

class SlotItem extends ConsumerWidget {
  final String time;
  final bool isSelected;
  const SlotItem({super.key, required this.time, required this.isSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime timeNow = DateTime.now();
    String stringTime = DateFormat.Hm().format(timeNow);
    return
        //time.compareTo(stringTime) == 1?
        Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Card(
        surfaceTintColor: isSelected ? Blue001 : Colors.white,
        elevation: 10,
        color: isSelected ? Blue001 : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Text(
            time,
            style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.normal),
          )),
        ),
      ),
    );
    //: const SizedBox()
  }
}

// class SlotsBody extends ConsumerStatefulWidget {
//   final String slotDate;
//   const SlotsBody({super.key, required this.slotDate});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _SlotsBodyState();
// }

// class _SlotsBodyState extends ConsumerState<SlotsBody> {
//   @override
//   Widget build(BuildContext context) {
//     SalonDetails salon = ref.watch(salonLocal)!;

//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           ListView.builder(
//               shrinkWrap: true,
//               //scrollDirection: Axis.vertical,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: salon.employees.length,
//               itemBuilder: (context, int i) {
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(salon.employees[i].name),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       ref
//                           .watch(slotsProvider(MyParameter(
//                               uid: salon.cid,
//                               employee: salon.employees[i].name,
//                               slotDate: widget.slotDate)))
//                           .when(
//                               data: (data) {
//                                 return data.isEmpty
//                                     ? const SizedBox(
//                                         width: double.infinity,
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           children: [
//                                             Text('No slots available!'),
//                                             SizedBox(
//                                               height: 30,
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     : Column(
//                                         children: [
//                                           SizedBox(
//                                             height: 70,
//                                             child: ListView.builder(
//                                                 itemCount: data.length,
//                                                 shrinkWrap: true,
//                                                 scrollDirection:
//                                                     Axis.horizontal,
//                                                 itemBuilder:
//                                                     (context, int index) {
//                                                   return InkWell(
//                                                     onTap: () {},
//                                                     child: SlotItem(
//                                                       time:
//                                                           data[index].slotTime,
//                                                     ),
//                                                   );
//                                                 }),
//                                           ),
//                                           const SizedBox(
//                                             height: 20,
//                                           )
//                                         ],
//                                       );
//                               },
//                               error: (error, stackTrace) =>
//                                   ErrorText(error: error.toString()),
//                               loading: () => const Loader())
//                     ],
//                   ),
//                 );
//               }),
//         ],
//       ),
//     );
//   }
// }
