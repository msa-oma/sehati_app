import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/text_style.dart';
import '../../data/onboarding_model.dart';

class OnboardingItem extends StatelessWidget {
  const OnboardingItem({
    super.key,
    required this.model,
  });

  final OnboardingModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // image
        const Spacer(
          flex: 1,
        ),
        SvgPicture.asset(
          model.imgPath,
          width: 300,
        ),
        const Spacer(
          flex: 1,
        ),
        Text(
          model.title,
          style: getTitleStyle(),
        ),
        const Gap(20),
        Text(
          model.body,
          textAlign: TextAlign.center,
          style: getbodyStyle(),
        ),
        const Spacer(
          flex: 2,
        )
      ],
    );
  }
}
