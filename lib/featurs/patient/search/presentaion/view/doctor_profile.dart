import 'package:flutter/material.dart';
import 'package:sehati_app/featurs/auth/data/doctor_model.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/text_style.dart';
import '../../../../../core/widgets/custom_btn.dart';
import '../../../../../core/widgets/tile_widget.dart';
import 'booking_view.dart';
import 'widgets/contact_icon.dart';

class DoctorProfile extends StatefulWidget {
  final DoctorModel doctorModel;

  const DoctorProfile({super.key, required this.doctorModel});
  @override
  State<DoctorProfile> createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('بيانات الدكتور'),
        leading: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            splashRadius: 25,
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            // ------------ Header ---------------
            Row(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.white,
                      child: CircleAvatar(
                          backgroundColor: AppColors.white,
                          radius: 60,
                          backgroundImage:
                              NetworkImage(widget.doctorModel.image)
                                  as ImageProvider),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "د. ${widget.doctorModel.name}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: getTitleStyle(),
                      ),
                      Text(
                        widget.doctorModel.specialization,
                        style: getbodyStyle(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            widget.doctorModel.rating.toString(),
                            style: getbodyStyle(),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          const Icon(
                            Icons.star_rounded,
                            size: 20,
                            color: Colors.orange,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          IconTile(
                            onTap: () {},
                            backColor: AppColors.blueSoftSky,
                            imgAssetPath: Icons.phone,
                            num: '1',
                          ),
                          IconTile(
                            onTap: () {},
                            backColor: AppColors.blueSoftSky,
                            imgAssetPath: Icons.phone,
                            num: '2',
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              "نبذة تعريفية",
              style: getbodyStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.doctorModel.bio,
              style: getsmallStyle(),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.blueSoftSky,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TileWidget(
                      text:
                          '${widget.doctorModel.openHour} - ${widget.doctorModel.closeHour}',
                      icon: Icons.watch_later_outlined),
                  const SizedBox(
                    height: 15,
                  ),
                  TileWidget(
                      text: widget.doctorModel.address,
                      icon: Icons.location_on_rounded),
                ],
              ),
            ),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            Text(
              "معلومات الاتصال",
              style: getbodyStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.blueSoftSky,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TileWidget(text: widget.doctorModel.email, icon: Icons.email),
                  const SizedBox(
                    height: 15,
                  ),
                  TileWidget(text: widget.doctorModel.phone1, icon: Icons.call),
                  const SizedBox(
                    height: 15,
                  ),
                  TileWidget(text: widget.doctorModel.phone2, icon: Icons.call),
                ],
              ),
            ),
          ],
        )),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: CustomButton(
          text: 'احجز موعد الان',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookingView(doctor: widget.doctorModel),
              ),
            );
          },
        ),
      ),
    );
  }
}
