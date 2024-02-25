import 'package:flutter/material.dart';

import 'onboarrding_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  // User? user;
  // Future<void> _getUser() async {
  //   user = FirebaseAuth.instance.currentUser;
  // }

  @override
  void initState() {
    super.initState();
    // _getUser();
    Future.delayed(
      const Duration(seconds: 4),
      () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const OnboardingView()
            // (user != null) ? const PatientMainPage() : const WelcomeView(),
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/logo.png',
          width: 250,
        ),
      ),
    );
  }
}
