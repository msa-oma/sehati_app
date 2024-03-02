import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sehati_app/core/services/app_local_storage.dart';
import 'package:sehati_app/featurs/doctor/home/nav_bar.dart';

import '../../../patient/home/presentaion/nav_bar.dart';
import 'onboarding_view.dart';
import 'welcome_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  User? user;
  late bool isOnboardingSkippedOrEnded;
  late int? userIndex;
  Future<void> _getUser() async {
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  void initState() {
    super.initState();
    AppLocal.getCachedDataX(AppLocal.isOnBoaringScreenEndedKey).then((value) {
      isOnboardingSkippedOrEnded = value ?? false;
      AppLocal.getCachedDataX(AppLocal.userIndex)
          .then((value) => userIndex = value);
    });

    _getUser();

    Future.delayed(
      const Duration(seconds: 4),
      () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) {
            if (!isOnboardingSkippedOrEnded) {
              return const OnboardingView();
            } else if (userIndex == 0) {
              return (user != null)
                  ? const DoctorMainPage()
                  : const WelcomeView();
            }
            return (user != null)
                ? const PatientMainPage()
                : const WelcomeView();
          },
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
