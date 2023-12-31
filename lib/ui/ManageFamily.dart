import 'package:erazor/common/error_text.dart';
import 'package:erazor/common/loader.dart';
import 'package:erazor/controllers/firebase_controller.dart';
import 'package:erazor/models/family_details.dart';
import 'package:erazor/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class ManageFamily extends ConsumerStatefulWidget {
  const ManageFamily({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ManageFamilyState();
}

class _ManageFamilyState extends ConsumerState<ManageFamily> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();
  final mobileController = TextEditingController();

  final name_Controller = TextEditingController();
  final age_Controller = TextEditingController();
  final gender_Controller = TextEditingController();
  final mobile_Controller = TextEditingController();

  final List<String> gender = ['Male', 'Female', 'Others'];

  bool enableButton() {
    bool enable = nameController.text.isNotEmpty &&
        ageController.text.isNotEmpty &&
        mobileController.text.isNotEmpty &&
        genderController.text.isNotEmpty;

    return enable;
  }

  bool enable_Button() {
    bool enable = name_Controller.text.isNotEmpty &&
        age_Controller.text.isNotEmpty &&
        mobile_Controller.text.isNotEmpty &&
        gender_Controller.text.isNotEmpty;

    return enable;
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    ageController.dispose();
    genderController.dispose();
    mobileController.dispose();

    name_Controller.dispose();
    age_Controller.dispose();
    gender_Controller.dispose();
    mobile_Controller.dispose();
  }

  void insertFamily() {
    ref.read(firebaseControllerProvider.notifier).insertFamily(
        context: context,
        name: nameController.text,
        age: int.parse(ageController.text),
        gender: genderController.text,
        mobileNumber: int.parse(mobileController.text));

    nameController.clear();
    ageController.clear();
    mobileController.clear();
    genderController.clear();
    Routemaster.of(context).pop();
  }

  void editFamily(String key) {
    ref.read(firebaseControllerProvider.notifier).editFamily(
        context: context,
        key: key,
        name: name_Controller.text,
        age: int.parse(age_Controller.text),
        gender: gender_Controller.text,
        mobileNumber: int.parse(mobile_Controller.text));

    name_Controller.clear();
    age_Controller.clear();
    mobile_Controller.clear();
    gender_Controller.clear();
    Routemaster.of(context).pop();
  }

  void deleteFamily(String key) {
    ref
        .read(firebaseControllerProvider.notifier)
        .deleteFamily(context: context, key: key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30))),
          title: const Text('Manage Family Members'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton.extended(
          elevation: 10,
          onPressed: () {
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
                          bottom: MediaQuery.of(context).viewInsets.bottom + 16
                          //bottom: 16
                          ),
                      child: Column(
                        children: [
                          TextField(
                            controller: nameController,
                            style: Theme.of(context).textTheme.bodySmall,
                            onChanged: (text) => setState(() {}),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Blue001, width: 2)),
                                label: Text(
                                  'Name',
                                  style: Theme.of(context).textTheme.bodySmall,
                                )),
                          ),
                          const SizedBox(height: 30),
                          TextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: ageController,
                            style: Theme.of(context).textTheme.bodySmall,
                            onChanged: (text) => setState(() {}),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Blue001, width: 2)),
                                label: Text(
                                  'Age',
                                  style: Theme.of(context).textTheme.bodySmall,
                                )),
                          ),
                          const SizedBox(height: 30),
                          DropdownMenu(
                            width: MediaQuery.of(context).size.width * 0.91,
                            initialSelection: gender[0],
                            controller: genderController,
                            textStyle: Theme.of(context).textTheme.bodySmall,
                            label: Text(
                              'Gender',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            menuStyle: const MenuStyle(
                                surfaceTintColor:
                                    MaterialStatePropertyAll(Colors.white),
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.white)),
                            dropdownMenuEntries: gender.map((String gender) {
                              return DropdownMenuEntry(
                                  value: gender,
                                  label: gender,
                                  style: ButtonStyle(
                                    textStyle: MaterialStatePropertyAll(
                                      Theme.of(context).textTheme.bodySmall,
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
                            style: Theme.of(context).textTheme.bodySmall,
                            onChanged: (text) => setState(() {}),
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Blue001, width: 2)),
                                label: Text(
                                  'Mobile Number',
                                  style: Theme.of(context).textTheme.bodySmall,
                                )),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                  onPressed:
                                      enableButton() ? insertFamily : null,
                                  child: Text(
                                    'Save',
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ))),
                        ],
                      ),
                    ),
                  );
                });
          },
          label: const Text('Add family member'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: ref.watch(familyProvider).when(
            data: (data) => data.isNotEmpty
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                FamilyDetails member = data[index];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Family member ${index + 1}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Card(
                                      elevation: 10,
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  member.name,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      member.age.toString(),
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
                                                      member.gender,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  member.mobileNumber
                                                      .toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                              ],
                                            ),
                                            IconButton(
                                                //color: Blue001,
                                                onPressed: () {
                                                  name_Controller.text =
                                                      member.name;
                                                  age_Controller.text =
                                                      member.age.toString();
                                                  gender_Controller.text =
                                                      member.gender;
                                                  mobile_Controller.text =
                                                      member.mobileNumber
                                                          .toString();

                                                  showModalBottomSheet(
                                                      backgroundColor:
                                                          Colors.white,
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
                                                                bottom: MediaQuery.of(
                                                                            context)
                                                                        .viewInsets
                                                                        .bottom +
                                                                    16),
                                                            child: Column(
                                                              children: [
                                                                TextField(
                                                                  controller:
                                                                      name_Controller,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodySmall,
                                                                  onChanged: (text) =>
                                                                      setState(
                                                                          () {}),
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .name,
                                                                  decoration:
                                                                      InputDecoration(
                                                                          border:
                                                                              const OutlineInputBorder(),
                                                                          focusedBorder:
                                                                              const OutlineInputBorder(borderSide: BorderSide(color: Blue001, width: 2)),
                                                                          label: Text(
                                                                            'Name',
                                                                            style:
                                                                                Theme.of(context).textTheme.bodySmall,
                                                                          )),
                                                                ),
                                                                const SizedBox(
                                                                    height: 30),
                                                                TextField(
                                                                  inputFormatters: [
                                                                    FilteringTextInputFormatter
                                                                        .digitsOnly
                                                                  ],
                                                                  controller:
                                                                      age_Controller,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodySmall,
                                                                  onChanged: (text) =>
                                                                      setState(
                                                                          () {}),
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .number,
                                                                  decoration:
                                                                      InputDecoration(
                                                                          border:
                                                                              const OutlineInputBorder(),
                                                                          focusedBorder:
                                                                              const OutlineInputBorder(borderSide: BorderSide(color: Blue001, width: 2)),
                                                                          label: Text(
                                                                            'Age',
                                                                            style:
                                                                                Theme.of(context).textTheme.bodySmall,
                                                                          )),
                                                                ),
                                                                const SizedBox(
                                                                    height: 30),
                                                                DropdownMenu(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.91,
                                                                  initialSelection:
                                                                      member
                                                                          .gender,
                                                                  controller:
                                                                      gender_Controller,
                                                                  textStyle: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodySmall,
                                                                  label: Text(
                                                                    'Gender',
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodySmall,
                                                                  ),
                                                                  menuStyle: const MenuStyle(
                                                                      surfaceTintColor:
                                                                          MaterialStatePropertyAll(Colors
                                                                              .white),
                                                                      backgroundColor:
                                                                          MaterialStatePropertyAll(
                                                                              Colors.white)),
                                                                  dropdownMenuEntries:
                                                                      gender.map(
                                                                          (String
                                                                              gender) {
                                                                    return DropdownMenuEntry(
                                                                        value:
                                                                            gender,
                                                                        label:
                                                                            gender,
                                                                        style:
                                                                            ButtonStyle(
                                                                          textStyle:
                                                                              MaterialStatePropertyAll(
                                                                            Theme.of(context).textTheme.bodySmall,
                                                                          ),
                                                                        ));
                                                                  }).toList(),
                                                                  onSelected:
                                                                      (value) =>
                                                                          setState(
                                                                              () {}),
                                                                ),
                                                                const SizedBox(
                                                                    height: 30),
                                                                TextField(
                                                                  inputFormatters: [
                                                                    FilteringTextInputFormatter
                                                                        .digitsOnly
                                                                  ],
                                                                  controller:
                                                                      mobile_Controller,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodySmall,
                                                                  onChanged: (text) =>
                                                                      setState(
                                                                          () {}),
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .phone,
                                                                  decoration:
                                                                      InputDecoration(
                                                                          border:
                                                                              const OutlineInputBorder(),
                                                                          focusedBorder:
                                                                              const OutlineInputBorder(borderSide: BorderSide(color: Blue001, width: 2)),
                                                                          label: Text(
                                                                            'Mobile Number',
                                                                            style:
                                                                                Theme.of(context).textTheme.bodySmall,
                                                                          )),
                                                                ),
                                                                const SizedBox(
                                                                    height: 30),
                                                                SizedBox(
                                                                    width: double
                                                                        .infinity,
                                                                    height: 50,
                                                                    child: ElevatedButton(
                                                                        onPressed: () => enable_Button() ? editFamily(member.key) : null,
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
                                                icon: const Icon(Icons.edit)),
                                            IconButton(
                                                color: Colors.red,
                                                onPressed: () =>
                                                    deleteFamily(member.key),
                                                icon: const Icon(Icons.delete)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    )
                                  ],
                                );
                              }),
                          const SizedBox(
                            height: 60,
                          )
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      'No family member added yet!',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
            error: (error, stackTrace) {
              return ErrorText(error: error.toString());
            },
            loading: () => const Loader()));
  }
}
