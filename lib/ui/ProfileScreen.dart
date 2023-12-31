import 'package:erazor/controllers/auth_controller.dart';
import 'package:erazor/controllers/firebase_controller.dart';
import 'package:erazor/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customer = ref.watch(customerDetailsProvider);

    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30))),
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: Card(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.grey.shade400,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, ${customer!.name}!',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          customer.email,
                          style: Theme.of(context).textTheme.bodySmall,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: Card(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.grey.shade400,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Routemaster.of(context).push('/manage_profile');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Manage Profile',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const Icon(
                                Icons.keyboard_arrow_right,
                                color: Blue001,
                              )
                            ],
                          ),
                        ),
                        const Divider(
                          height: 40,
                        ),
                        InkWell(
                          onTap: () {
                            Routemaster.of(context).push('/manage_address');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Manage Addresses',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const Icon(
                                Icons.keyboard_arrow_right,
                                color: Blue001,
                              )
                            ],
                          ),
                        ),
                        const Divider(
                          height: 40,
                        ),
                        InkWell(
                          onTap: () {
                            Routemaster.of(context).push('/manage_family');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Manage Family Members',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const Icon(
                                Icons.keyboard_arrow_right,
                                color: Blue001,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: InkWell(
                  onTap: () {
                    ref.watch(authControllerProvider.notifier).logout();
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.grey.shade400,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15))),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          const Icon(Icons.logout),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Logout',
                            style: Theme.of(context).textTheme.bodyMedium,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: Card(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.grey.shade400,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contact Us!',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '+91 8690389703',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'info@erazor.in',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'DLF, Cyber Hub, Gurugram',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
