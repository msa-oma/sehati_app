import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sehati_app/core/widgets/custom_btn.dart';
import 'package:sehati_app/featurs/intro/presentation/view/welcome_view.dart';

import '../../../core/funcs/routing.dart';

class DoctorProfilePage extends StatefulWidget {
  const DoctorProfilePage({super.key});

  @override
  State<DoctorProfilePage> createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomButton(
            text: "sign out",
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                pushAndRemoveUntil(context, const WelcomeView());
              }
            }),
      ),
    );
  }
}
