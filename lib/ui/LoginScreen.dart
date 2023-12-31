import 'package:erazor/common/loader.dart';
import 'package:erazor/controllers/auth_controller.dart';
import 'package:erazor/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signInWithGoogle(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/login_img.jpeg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.4,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Salon Services',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        Text(
                          'Booking App',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: const Divider()),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Login or Signup',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => signInWithGoogle(context, ref),
                            style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Blue001),
                                elevation: MaterialStatePropertyAll(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/google_logo.png',
                                  width: 30,
                                  height: 30,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Login with Google',
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: const Divider()),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          'By continuing, you agree to our',
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.normal),
                        ),
                        const Text(
                          'Terms of Service, Privacy Policy, Content Policy',
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.normal),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
