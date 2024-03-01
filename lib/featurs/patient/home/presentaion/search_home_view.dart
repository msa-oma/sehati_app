import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/text_style.dart';
import '../../../../core/widgets/doctor_card.dart';
import '../../../auth/data/doctor_model.dart';
import '../../search/presentaion/view/doctor_profile.dart';

class SearchHomeView extends StatefulWidget {
  final String searchKey;
  const SearchHomeView({super.key, required this.searchKey});

  @override
  State<SearchHomeView> createState() => _SearchHomeViewState();
}

class _SearchHomeViewState extends State<SearchHomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blueLagoon,
        title: Text(
          'ابحث عن دكتورك',
          style: getTitleStyle(color: AppColors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('doctors')
              .orderBy('name')
              .startAt([widget.searchKey]).endAt(
                  ['${widget.searchKey}\uf8ff']).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return snapshot.data?.size == 0
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
                            'لا يوجد دكتور بهذا الاسم',
                            style: getbodyStyle(),
                          ),
                        ],
                      ),
                    ),
                  )
                : Scrollbar(
                    child: ListView.builder(
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
                                        address: doctor['address']),
                                  ),
                                ),
                              );
                            });
                      },
                    ),
                  );
          },
        ),
      ),
    );
  }
}
