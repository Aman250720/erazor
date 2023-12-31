import 'package:erazor/controllers/firebase_controller.dart';
import 'package:erazor/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();
  final mobileController = TextEditingController();

  final List<String> gender = ['Male', 'Female', 'Others'];

  bool enableButton() {
    bool enable = nameController.text.isNotEmpty &&
        ageController.text.isNotEmpty &&
        int.parse(ageController.text) < 120 &&
        mobileController.text.isNotEmpty &&
        (mobileController.text.length == 10) &&
        genderController.text.isNotEmpty;

    return enable;
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    ageController.dispose();
    genderController.dispose();
    mobileController.dispose();
  }

  void insertC() {
    ref.read(firebaseControllerProvider.notifier).insertC(
        context: context,
        name: nameController.text,
        age: int.parse(ageController.text),
        gender: genderController.text,
        mobileNumber: int.parse(mobileController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30))),
        centerTitle: true,
        title: const Text('Register with us'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: nameController,
                style: Theme.of(context).textTheme.bodySmall,
                onChanged: (text) => setState(() {}),
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  label: Text(
                    'Name',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Blue001, width: 2)),
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: Theme.of(context).textTheme.bodySmall,
                controller: ageController,
                onChanged: (text) => setState(() {}),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  errorText: (int.parse(ageController.text) > 120 ||
                          ageController.text.isEmpty)
                      ? null
                      : 'Invalid age!',
                  errorStyle: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.normal),
                  border: const OutlineInputBorder(),
                  label: Text(
                    'Age',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Blue001, width: 2)),
                ),
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
                    surfaceTintColor: MaterialStatePropertyAll(Colors.white),
                    backgroundColor: MaterialStatePropertyAll(Colors.white)),
                dropdownMenuEntries: gender.map((String gender) {
                  return DropdownMenuEntry(
                      value: gender,
                      label: gender,
                      style: ButtonStyle(
                          textStyle: MaterialStatePropertyAll(
                            Theme.of(context).textTheme.bodySmall,
                          ),
                          backgroundColor:
                              const MaterialStatePropertyAll(Colors.white)));
                }).toList(),
                onSelected: (value) => setState(() {}),
              ),
              const SizedBox(height: 30),
              TextField(
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: mobileController,
                style: Theme.of(context).textTheme.bodySmall,
                onChanged: (text) => setState(() {}),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  errorText: (mobileController.text.length == 10 ||
                          mobileController.text.isEmpty)
                      ? null
                      : 'Invalid mobile number!',
                  errorStyle: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.normal),
                  border: const OutlineInputBorder(),
                  label: Text(
                    'Mobile Number',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Blue001, width: 2)),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: enableButton()
                      ? ElevatedButton(
                          onPressed: insertC,
                          child: Text(
                            'Register',
                            style: Theme.of(context).textTheme.labelSmall,
                          ))
                      : ElevatedButton(
                          style: ButtonStyle(
                              elevation: const MaterialStatePropertyAll(0),
                              surfaceTintColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              backgroundColor: MaterialStatePropertyAll(
                                  Colors.grey.shade300)),
                          onPressed: null,
                          child: Text(
                            'Register',
                            style: Theme.of(context).textTheme.labelSmall,
                          ))),
            ],
          ),
        ),
      ),
    );
  }
}
