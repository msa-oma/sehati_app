import 'package:flutter/material.dart';
import 'package:sehati_app/core/services/app_local_storage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/funcs/routing.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/text_style.dart';
import '../../../../core/widgets/custom_btn.dart';
import '../../data/onboarding_model.dart';
import '../widgets/onboarding_item.dart';
import 'welcome_view.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  List<OnboardingModel> pages = [
    OnboardingModel(
        imgPath: 'assets/onboarding1.svg',
        title: 'ابحث عن دكتور متخصص',
        body:
            'اكتشف مجموعة واسعة من الأطباء الخبراء والمتخصصين في مختلف المجالات.'),
    OnboardingModel(
        imgPath: 'assets/onboarding2.svg',
        title: 'سهولة الحجز',
        body: 'احجز المواعيد بضغطة زرار في أي وقت وفي أي مكان.'),
    OnboardingModel(
        imgPath: 'assets/onboarding3.svg',
        title: 'آمن وسري',
        body: 'كن مطمئنًا لأن خصوصيتك وأمانك هما أهم أولوياتنا.')
  ];

  var pageController = PageController();
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        actions: [
          TextButton(
              onPressed: () {
                AppLocal.cacheDataX(AppLocal.isOnBoaringScreenEndedKey, true);
                pushWithReplacment(context, const WelcomeView());
              },
              child: Text(
                'تخطي',
                style: getbodyStyle(color: AppColors.blueLagoon),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    index = value;
                  });
                },
                controller: pageController,
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  return OnboardingItem(model: pages[index]);
                },
              ),
            ),
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  SmoothPageIndicator(
                    controller: pageController,
                    count: 3,
                    effect: const WormEffect(
                      activeDotColor: AppColors.blueLagoon,
                      dotHeight: 10,
                    ),
                  ),
                  const Spacer(),

                  // if it's last page
                  (index == pages.length - 1)
                      ? CustomButton(
                          text: 'هيا بنا',
                          onPressed: () {
                            AppLocal.cacheDataX(
                                AppLocal.isOnBoaringScreenEndedKey, true);

                            pushWithReplacment(context, const WelcomeView());
                          },
                        )
                      : const SizedBox()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
