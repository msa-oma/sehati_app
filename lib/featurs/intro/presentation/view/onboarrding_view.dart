import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingState();
}

class _OnboardingState extends State<OnboardingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    const Spacer(
                      flex: 1,
                    ),
                    SvgPicture.asset("assetName"),
                  ],
                );
              },
            ),
          ),
          Row(
            children: [
              SmoothPageIndicator(
                controller: PageController(),
                count: 3,
              ),
              ElevatedButton(onPressed: () {}, child: Text(''))
            ],
          )
        ],
      ),
    );
  }
}
