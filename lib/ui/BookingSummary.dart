import 'package:cloud_functions/cloud_functions.dart';
import 'package:erazor/common/loader.dart';
import 'package:erazor/controllers/firebase_controller.dart';
import 'package:erazor/models/cart_details.dart';
import 'package:erazor/models/customer_details.dart';
import 'package:erazor/models/salon_details.dart';
import 'package:erazor/models/service_details.dart';
import 'package:erazor/theme/theme.dart';
import 'package:erazor/ui/MainScreen.dart';
import 'package:erazor/ui/SalonScreen.dart';
import 'package:erazor/ui/SlotsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

class BookingSummary extends ConsumerWidget {
  const BookingSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SalonDetails salon = ref.watch(salonLocal)!;
    CartDetails cart = ref.watch(cartProvider);
    //CustomerDetails customer = ref.watch(customerDetailsProvider)!;
    final bid = const Uuid().v4();

    void insertBookedService() {
      for (var element in cart.serviceList) {
        ref.watch(firebaseControllerProvider.notifier).insertBookedService(
            context: context,
            bid: bid,
            serviceName: element.serviceName,
            servicePrice: element.servicePrice,
            finalPrice: element.finalPrice,
            serviceDuration: element.serviceDuration);
      }
    }

    void insertBookedPerson() {
      ref.watch(firebaseControllerProvider.notifier).insertBookedPerson(
          context: context,
          bid: bid,
          name: cart.member.name,
          gender: cart.member.gender,
          age: cart.member.age,
          mobileNumber: cart.member.mobileNumber);
    }

    void bookSlot() {
      for (var element in cart.slotsList) {
        ref.watch(firebaseControllerProvider.notifier).bookSlot(
            context: context, key: element.key, booked: true, bid: bid);
      }
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30))),
          title: const Text('Booking Summary'),
          centerTitle: true,
        ),
        bottomSheet: BottomSheet(
            backgroundColor: Colors.white,
            onClosing: () {},
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 10,
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Total : ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal),
                            ),
                            Text(
                              '\u{20B9}${cart.initialAmount} ',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: Colors.white),
                            ),
                            Text(
                              ' \u{20B9}${cart.finalAmount}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    backgroundColor: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Booking confirmation!',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Are you sure, you want to confirm your booking?',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              ElevatedButton(
                                                  onPressed: () async {
                                                    insertBookedService();
                                                    insertBookedPerson();
                                                    bookSlot();
                                                    Routemaster.of(context)
                                                        .pop();
                                                    Routemaster.of(context).replace(
                                                        '/booking_confirmation');
                                                    final bookSlots = await FirebaseFunctions
                                                            .instanceFor(
                                                                region:
                                                                    'asia-south1')
                                                        .httpsCallable(
                                                            'bookSlots',
                                                            options: HttpsCallableOptions(
                                                                timeout:
                                                                    const Duration(
                                                                        seconds:
                                                                            5)))
                                                        .call({
                                                      'customer':
                                                          cart.member.name,
                                                      'date': DateFormat.MMMEd()
                                                          .format(cart
                                                              .selectedDate),
                                                      'time': cart.slotsList[0]
                                                          .slotTime,
                                                      'token': salon.token
                                                    });
                                                    // Routemaster.of(context)
                                                    //     .pop();
                                                    // Routemaster.of(context).push(
                                                    //     '/booking_confirmation');
                                                  },
                                                  child: Text(
                                                    'Confirm',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelSmall,
                                                  )),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Routemaster.of(context)
                                                        .popUntil((routeData) =>
                                                            false);
                                                  },
                                                  child: Text(
                                                    'Discard',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelSmall,
                                                  )),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: const Text(
                            'Proceed',
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          salon.salonName,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          salon.address,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    ref.watch(salonImagesProvider(salon.cid)).when(
                        data: (data) {
                          print('url ${data[0].url}');
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              data[0].url,
                              width: 150,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                        error: (error, StackTrace) {
                          return Image.asset(
                            'assets/images/login_img.jpeg',
                            width: 100,
                          );
                        },
                        loading: () => const Loader())
                  ],
                ),
                // const Divider(
                //   height: 50,
                // ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 60, child: Divider()),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Booking Details',
                      style: Theme.of(context).textTheme.bodyLarge,
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
                Card(
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Booking date : ',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              DateFormat.MMMEd().format(cart.selectedDate),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const Divider(
                          height: 20,
                        ),
                        Text(
                          'Time slots :',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(
                          height: 80,
                          child: ListView.builder(
                              itemCount: cart.slotsList.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return SlotItem(
                                    time: cart.slotsList[index].slotTime,
                                    isSelected: true);
                              }),
                        ),
                        const Divider(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text(
                              'Customer : ',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              cart.member.name,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              'Stylist : ',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              cart.slotsList[0].employee,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // const Divider(
                //   height: 50,
                // ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 60, child: Divider()),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Service Details',
                      style: Theme.of(context).textTheme.bodyLarge,
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
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cart.serviceCount,
                    itemBuilder: (context, index) {
                      int discount = 100 -
                          (cart.serviceList[index].finalPrice /
                                  cart.serviceList[index].servicePrice *
                                  100)
                              .toInt();
                      return Card(
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cart.serviceList[index].serviceName,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
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
                                        '${cart.serviceList[index].serviceDuration} mins',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '\u{20B9}${cart.serviceList[index].servicePrice}',
                                        style: const TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        '\u{20B9}${cart.serviceList[index].finalPrice}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '$discount% off!',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Blue001),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                const SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
