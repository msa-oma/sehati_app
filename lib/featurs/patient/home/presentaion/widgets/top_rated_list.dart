import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sehati_app/core/utils/app_colors.dart';

import '../../../../../core/widgets/doctor_card.dart';
import '../../../../auth/data/doctor_model.dart';
import '../../../search/presentaion/view/doctor_profile.dart';

class TopRatedList extends StatefulWidget {
  const TopRatedList({super.key});

  @override
  State<TopRatedList> createState() => _TopRatedListState();
}

class _TopRatedListState extends State<TopRatedList> {
  @override
  Widget build(BuildContext context) {
    // orderBy  للترتيب
    // where  للمقارنة
    // startAt and endAt  للسيرش
    return SafeArea(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('doctors')
            .orderBy('rating', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.blueLagoon),
            );
          } else {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              physics: const ClampingScrollPhysics(),
              // make listview scroll with single child scroll view
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot doctor = snapshot.data!.docs[index];
                if (doctor['name'] == null ||
                    doctor['image'] == null ||
                    doctor['specialization'] == null ||
                    doctor['rating'] == null) {
                  return const SizedBox();
                }
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
                                  specialization: doctor['specialization'],
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
            );
          }
        },
      ),
    );
  }
}
