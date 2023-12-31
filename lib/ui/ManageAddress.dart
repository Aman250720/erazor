import 'package:erazor/common/loader.dart';
import 'package:erazor/controllers/firebase_controller.dart';
import 'package:erazor/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class ManageAddress extends ConsumerStatefulWidget {
  const ManageAddress({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ManageAddressState();
}

class _ManageAddressState extends ConsumerState<ManageAddress> {
  final houseController = TextEditingController();
  final localityController = TextEditingController();

  void deleteLocation(String key) {
    ref
        .read(firebaseControllerProvider.notifier)
        .deleteLocation(context: context, key: key);
  }

  void editLocation(String key) {
    ref.read(firebaseControllerProvider.notifier).editLocation(
        context: context,
        key: key,
        houseNumber: houseController.text,
        locality: localityController.text);

    houseController.clear();
    localityController.clear();
    Routemaster.of(context).pop();
  }

  bool enableButton() {
    bool enable =
        houseController.text.isNotEmpty && localityController.text.isNotEmpty;

    return enable;
  }

  @override
  void dispose() {
    super.dispose();
    houseController.dispose();
    localityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30))),
        title: const Text('Manage Addresses'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Routemaster.of(context).push('/google_maps');
          },
          label: const Text('Add address')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: ref.watch(customerLocationsProvider).when(data: (data) {
        return data.isNotEmpty
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Card(
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data[index].houseNumber,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                          Text(
                                            data[index].locality,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () {
                                          houseController.text =
                                              data[index].houseNumber;
                                          localityController.text =
                                              data[index].locality;
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                  surfaceTintColor:
                                                      Colors.white,
                                                  insetPadding:
                                                      const EdgeInsets.all(24),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            24.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          'Change address!',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium,
                                                        ),
                                                        const SizedBox(
                                                          height: 16,
                                                        ),
                                                        TextField(
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall,
                                                          controller:
                                                              houseController,
                                                          onChanged: (text) =>
                                                              setState(() {}),
                                                          keyboardType:
                                                              TextInputType
                                                                  .name,
                                                          decoration:
                                                              InputDecoration(
                                                                  border:
                                                                      const OutlineInputBorder(),
                                                                  focusedBorder: const OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          color:
                                                                              Blue001,
                                                                          width:
                                                                              2)),
                                                                  label: Text(
                                                                    'House/Flat Number',
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodySmall,
                                                                  )),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        TextField(
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall,
                                                          controller:
                                                              localityController,
                                                          onChanged: (text) =>
                                                              setState(() {}),
                                                          keyboardType:
                                                              TextInputType
                                                                  .name,
                                                          decoration:
                                                              InputDecoration(
                                                                  border:
                                                                      const OutlineInputBorder(),
                                                                  focusedBorder: const OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          color:
                                                                              Blue001,
                                                                          width:
                                                                              2)),
                                                                  label: Text(
                                                                    'Sector/Locality',
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodySmall,
                                                                  )),
                                                        ),
                                                        const SizedBox(
                                                          height: 16,
                                                        ),
                                                        ElevatedButton(
                                                            onPressed: () =>
                                                                editLocation(
                                                                    data[index]
                                                                        .key),
                                                            child: Text(
                                                                'Save changes',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .labelSmall))
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                        child: const Icon(Icons.edit)),
                                    InkWell(
                                        onTap: () {
                                          deleteLocation(data[index].key);
                                        },
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                    const SizedBox(
                      height: 80,
                    )
                  ],
                ),
              )
            : Center(
                child: Text(
                  'No location added yet!',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              );
      }, error: (error, stackTrace) {
        return const Loader();
      }, loading: () {
        return const Loader();
      }),
    );
  }
}
