import 'package:flutter/material.dart';
import 'package:sehati_app/core/services/app_local_storage.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/text_style.dart';
import '../../../auth/presentation/view/login_view.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: .7,
            child: Image.asset(
              'assets/welcome-bg.png',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
          ),
          // Container(
          //   decoration: const BoxDecoration(
          //     image: DecorationImage(
          //       fit: BoxFit.cover,
          //       opacity: .7,
          //       image: AssetImage(
          //         'assets/welcome-bg.png',
          //       ),
          //     ),
          //   ),
          // ),

          Positioned(
            top: 100,
            right: 25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أهلاً بك',
                  style: getTitleStyle(fontSize: 38),
                ),
                Text(
                  'سجل واحجز عند دكتورك وانت في البيت',
                  style: getbodyStyle(),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 80,
            left: 25,
            right: 25,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.blueLagoon.withOpacity(.5),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.3),
                    blurRadius: 15,
                    offset: const Offset(5, 5),
                  )
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'سجل الآن كـ',
                    style: getbodyStyle(fontSize: 18, color: AppColors.white),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Column(
                    children: [
                      //register as doctor btn
                      GestureDetector(
                        onTap: () {
                          AppLocal.cacheDataX(AppLocal.userIndex, 0);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginView(index: 0),
                              ));
                        },
                        child: Container(
                            height: 70,
                            decoration: BoxDecoration(
                                color: AppColors.blueSoftSky.withOpacity(.7),
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: Text(
                                'دكتور',
                                style: getTitleStyle(
                                    color: AppColors.blackCharcoal),
                              ),
                            )),
                      ),
                      const SizedBox(
                        height: 15,
                      ),

                      //register as patient btn
                      GestureDetector(
                        onTap: () {
                          AppLocal.cacheDataX(AppLocal.userIndex, 1);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginView(index: 1),
                              ));
                        },
                        child: Container(
                            height: 70,
                            decoration: BoxDecoration(
                                color: AppColors.blueSoftSky.withOpacity(.7),
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: Text(
                                'مريض',
                                style: getTitleStyle(
                                    color: AppColors.blackCharcoal),
                              ),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
