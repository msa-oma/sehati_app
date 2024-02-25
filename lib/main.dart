import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sehati_app/featurs/intro/presentation/view/splash_view.dart';

import 'core/utils/app_colors.dart';
import 'core/utils/text_style.dart';
import 'featurs/auth/presentation/view_model/auth_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: ' ', //put your FireBase api key
        appId: 'com.example.se7ety_2_21',
        messagingSenderId: '892515892327',
        projectId: 'se7ety-1ae1c'),
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AuthCubit(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              scaffoldBackgroundColor: AppColors.white,
              snackBarTheme:
                  SnackBarThemeData(backgroundColor: AppColors.redColor),
              appBarTheme: AppBarTheme(
                  titleTextStyle: getTitleStyle(color: AppColors.white),
                  centerTitle: true,
                  elevation: 0.0,
                  actionsIconTheme:
                      const IconThemeData(color: AppColors.blueLagoon),
                  backgroundColor: AppColors.blueLagoon),
              inputDecorationTheme: InputDecorationTheme(
                contentPadding: const EdgeInsets.only(
                    left: 20, top: 10, bottom: 10, right: 20),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                suffixIconColor: AppColors.blueLagoon,
                prefixIconColor: AppColors.blueLagoon,
                fillColor: AppColors.blueSoftSky,
                hintStyle: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              dividerTheme: const DividerThemeData(
                color: AppColors.blackCharcoal,
                indent: 10,
                endIndent: 10,
              ),
              fontFamily: GoogleFonts.cairo().fontFamily),
          home: const SplashView(),
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: child!,
            );
          },
        ));
  }
}
