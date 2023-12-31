import 'package:erazor/controllers/firebase_controller.dart';
import 'package:erazor/models/customer_details.dart';
import 'package:erazor/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class ManageProfile extends ConsumerStatefulWidget {
  const ManageProfile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ManageProfileState();
}

class _ManageProfileState extends ConsumerState<ManageProfile> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();
  final mobileController = TextEditingController();

  final List<String> gender = ['Male', 'Female', 'Others'];

  bool enableButton() {
    bool enable = nameController.text.isNotEmpty &&
        ageController.text.isNotEmpty &&
        mobileController.text.isNotEmpty &&
        genderController.text.isNotEmpty;

    return enable;
  }

  void editProfile() {
    ref.read(firebaseControllerProvider.notifier).editC(
        context: context,
        name: nameController.text,
        age: int.parse(ageController.text),
        gender: genderController.text,
        mobileNumber: int.parse(mobileController.text));

    // nameController.clear();
    // ageController.clear();
    // mobileController.clear();
    // genderController.clear();

    Routemaster.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    CustomerDetails customer = ref.watch(customerDetailsProvider)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30))),
        title: const Text('Manage Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      customer.name,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Divider(
                      indent: 120,
                      endIndent: 120,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customer.age.toString(),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              customer.gender,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              customer.mobileNumber.toString(),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.account_circle,
                          size: 100,
                          color: Blue001,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      nameController.text = customer.name;
                      ageController.text = customer.age.toString();
                      genderController.text = customer.gender;
                      mobileController.text = customer.mobileNumber.toString();
                      showModalBottomSheet(
                          backgroundColor: Colors.white,
                          isScrollControlled: true,
                          showDragHandle: true,
                          context: context,
                          builder: (context) {
                            return SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 16,
                                    top: 16,
                                    right: 16,
                                    bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom +
                                        16),
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: nameController,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                      onChanged: (text) => setState(() {}),
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                          border: const OutlineInputBorder(),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Blue001,
                                                      width: 2)),
                                          label: Text(
                                            'Name',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          )),
                                    ),
                                    const SizedBox(height: 30),
                                    TextField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      controller: ageController,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                      onChanged: (text) => setState(() {}),
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          border: const OutlineInputBorder(),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Blue001,
                                                      width: 2)),
                                          label: Text(
                                            'Age',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          )),
                                    ),
                                    const SizedBox(height: 30),
                                    DropdownMenu(
                                      width: MediaQuery.of(context).size.width *
                                          0.91,
                                      initialSelection: genderController,
                                      controller: genderController,
                                      textStyle:
                                          Theme.of(context).textTheme.bodySmall,
                                      label: Text(
                                        'Gender',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      menuStyle: const MenuStyle(
                                          surfaceTintColor:
                                              MaterialStatePropertyAll(
                                                  Colors.white),
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.white)),
                                      dropdownMenuEntries:
                                          gender.map((String gender) {
                                        return DropdownMenuEntry(
                                            value: gender,
                                            label: gender,
                                            style: ButtonStyle(
                                              textStyle:
                                                  MaterialStatePropertyAll(
                                                Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                            ));
                                      }).toList(),
                                      onSelected: (value) => setState(() {}),
                                    ),
                                    const SizedBox(height: 30),
                                    TextField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      controller: mobileController,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                      onChanged: (text) => setState(() {}),
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                          border: const OutlineInputBorder(),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Blue001,
                                                      width: 2)),
                                          label: Text(
                                            'Mobile Number',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          )),
                                    ),
                                    const SizedBox(height: 30),
                                    SizedBox(
                                        width: double.infinity,
                                        height: 50,
                                        child: ElevatedButton(
                                            onPressed: enableButton()
                                                ? editProfile
                                                : null,
                                            child: Text(
                                              'Save',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall,
                                            ))),
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    child: Text(
                      'Edit Profile',
                      style: Theme.of(context).textTheme.labelSmall,
                    )))
          ],
        ),
      ),
    );
  }
}
