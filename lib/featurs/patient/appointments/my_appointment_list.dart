import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/text_style.dart';
import '../../../core/widgets/no_scheduled.dart';

class MyAppointmentList extends StatefulWidget {
  const MyAppointmentList({super.key});

  @override
  State<MyAppointmentList> createState() => _MyAppointmentListState();
}

class _MyAppointmentListState extends State<MyAppointmentList> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  String? _documentID;

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  Future<void> deleteAppointment(
    String docID,
  ) {
    return FirebaseFirestore.instance
        .collection('appointments')
        .doc('appointments')
        .collection('pending')
        .doc(docID)
        .delete();
  }

  String _dateFormatter(String timestamp) {
    String formattedDate =
        DateFormat('dd-MM-yyyy').format(DateTime.parse(timestamp));
    return formattedDate;
  }

  String _timeFormatter(String timestamp) {
    String formattedTime =
        DateFormat('hh:mm').format(DateTime.parse(timestamp));
    return formattedTime;
  }

  showAlertDialog(BuildContext context, String doctorID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text("حذف الحجز"),
          content: const Text("هل متاكد من حذف هذا الحجز ؟"),
          actions: [
            // nooooooooooo
            TextButton(
              child: const Text("لا"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

            /// deleteeeeeeeeeee
            TextButton(
              child: const Text("نعم"),
              onPressed: () {
                deleteAppointment(
                  _documentID!,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _checkDiff(DateTime date) {
    var diff = DateTime.now().difference(date).inHours;
    if (diff > 2) {
      return true;
    } else {
      return false;
    }
  }

  _compareDate(String date) {
    if (_dateFormatter(DateTime.now().toString())
            .compareTo(_dateFormatter(date)) ==
        0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
        // to get my appointments (using my email)
        // to use where and orderby, you must add indexing from link in console
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .doc('appointments')
            .collection('pending')
            .where('patientID', isEqualTo: '${user!.email}')
            .orderBy('date', descending: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return snapshot.data?.size == 0
              ? const NoScheduledWidget()
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data?.size,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    if (_checkDiff(document['date'].toDate())) {
                      deleteAppointment(
                        document.id,
                      );
                    }
                    return Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(-3, 0),
                            blurRadius: 15,
                            color: Colors.grey.withOpacity(.1),
                          )
                        ],
                      ),
                      child: ExpansionTile(
                        childrenPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        expandedCrossAxisAlignment: CrossAxisAlignment.end,
                        backgroundColor: document['isComplete']
                            ? Colors.green
                            : AppColors.blueSoftSky,
                        collapsedBackgroundColor: AppColors.blueSoftSky,
                        title: Text(
                          'د. ${document['doctor']}',
                          style: getTitleStyle(),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 5, left: 5),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.calendar_month_rounded,
                                      color: AppColors.blueLagoon, size: 16),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    _dateFormatter(
                                        document['date'].toDate().toString()),
                                    style: getbodyStyle(),
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Text(
                                    _compareDate(document['date']
                                            .toDate()
                                            .toString())
                                        ? "اليوم"
                                        : "",
                                    style: getbodyStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.watch_later_outlined,
                                      color: AppColors.blueLagoon, size: 16),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    _timeFormatter(
                                      document['date'].toDate().toString(),
                                    ),
                                    style: getbodyStyle(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 5, right: 10, left: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "اسم المريض: " + document['name'],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_rounded,
                                        color: AppColors.blueLagoon, size: 16),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      document['location'],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          foregroundColor: AppColors.white,
                                          backgroundColor: AppColors.redColor),
                                      onPressed: () {
                                        _documentID = document.id;
                                        showAlertDialog(
                                            context, document['doctorID']);
                                      },
                                      child: const Text('حذف الحجز')),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
