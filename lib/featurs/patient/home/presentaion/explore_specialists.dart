import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sehati_app/featurs/auth/data/doctor_model.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/text_style.dart';
import '../../../../core/widgets/doctor_card.dart';
import '../../search/presentaion/view/doctor_profile.dart';

class ExploreList extends StatefulWidget {
  final String specialization;
  const ExploreList({super.key, required this.specialization});

  @override
  State<ExploreList> createState() => _ExploreListState();
}

class _ExploreListState extends State<ExploreList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.specialization,
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('doctor')
            .where('specialization', isEqualTo: widget.specialization)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.blueLagoon),
            );
          }
          return snapshot.data!.docs.isEmpty
              ? Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/no-search.svg',
                          width: 250,
                        ),
                        Text(
                          'لا يوجد دكتور بهذا التخصص حاليا',
                          style: getbodyStyle(),
                        ),
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(15),
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: snapshot.data?.size,
                    itemBuilder: (context, index) {
                      DocumentSnapshot doctor = snapshot.data!.docs[index];
                      return DoctorCard(
                          name: doctor['name'],
                          image: doctor['image'],
                          specialization: doctor['specialization'],
                          rating: doctor['rating'],
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DoctorProfile(
                                    doctorModel: DoctorModel(
                                        id: doctor.id,
                                        name: doctor['name'],
                                        image: doctor['image'],
                                        specialization:
                                            doctor['specialization'],
                                        rating: doctor['rating'],
                                        email: doctor['email'],
                                        phone1: doctor['phone1'],
                                        phone2: doctor['phone2'],
                                        bio: doctor['bio'],
                                        openHour: doctor['openHour'],
                                        closeHour: doctor['closeHour'],
                                        address: doctor['address'])),
                              ),
                            );
                          });
                    },
                  ),
                );
        },
      ),
    );
  }
}
