import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sehati_app/featurs/doctor/home/nav_bar.dart';

import '../../../patient/home/presentaion/nav_bar.dart';
import 'onboarrding_view.dart';
import 'welcome_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  User? user;
  Future<void> _getUser() async {
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  void initState() {
    super.initState();

    _getUser();
    Future.delayed(
      const Duration(seconds: 4),
      () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) =>
              //todo: handle onboarding appearents with shared preferences
              // const OnboardingView()

              //ToDO: handel this whether user is doctor or patient
              (user != null) ? const DoctorMainPage() : const WelcomeView(),
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
