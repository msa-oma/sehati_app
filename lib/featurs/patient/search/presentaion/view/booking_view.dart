import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sehati_app/featurs/auth/data/doctor_model.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/text_style.dart';
import '../../../../../core/widgets/custom_alert_dialog.dart';
import '../../../../../core/widgets/custom_btn.dart';
import '../../../../../core/widgets/doctor_card.dart';
import '../../../appointments/my_appointments.dart';
import 'widgets/available_appointments.dart';

class BookingView extends StatefulWidget {
  final DoctorModel doctor;

  const BookingView({
    super.key,
    required this.doctor,
  });

  @override
  State<BookingView> createState() => _BookingViewState();
}

class _BookingViewState extends State<BookingView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController =
      TextEditingController(text: 'أدخل تاريخ الحجز');

  TimeOfDay currentTime = TimeOfDay.now();
  String? dateUTC;
  String? dateTime;

  Set<int> isSelected = {};

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

// get the remaining hours of the day
  List<int> times = [];
  getAvilableTimes(selectedDate) async {
    // to clear last times when clicking date dialog
    times.clear();
    AppointmentService()
        .getAvailableAppointments(
            selectedDate, widget.doctor.openHour, widget.doctor.closeHour)
        .then((avilableTimes) {
      for (var i in avilableTimes) {
        times.add(i.hour);
      }
    });
  }

  Future<void> selectDate(BuildContext context) async {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.blueLagoon,
            colorScheme: const ColorScheme.light(primary: AppColors.blueLagoon),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    ).then(
      (date) {
        if (date != null) {
          setState(
            () {
              // intl to format datetime
              _dateController.text = DateFormat('dd-MM-yyyy').format(date);
              dateUTC = DateFormat('yyyy-MM-dd').format(date);
              getAvilableTimes(date);
            },
          );
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: AppColors.white,
            )),
        elevation: 0,
        title: const Text(
          'احجز مع دكتورك',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              DoctorCard(
                  name: widget.doctor.name,
                  image: widget.doctor.image,
                  specialization: widget.doctor.specialization,
                  rating: widget.doctor.rating,
                  onPressed: () {}),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        '-- أدخل بيانات الحجز --',
                        style: getTitleStyle(),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'اسم المريض',
                            style: getbodyStyle(color: AppColors.black),
                          )
                        ],
                      ),
                    ),
                    TextFormField(
                      controller: _nameController,
                      validator: (value) {
                        if (value!.isEmpty) return 'من فضلك أدخل اسم المريض';
                        return null;
                      },
                      style: getbodyStyle(),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'رقم الهاتف',
                            style: getbodyStyle(color: AppColors.black),
                          )
                        ],
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: _phoneController,
                      style: getbodyStyle(),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'من فضلك أدخل رقم الهاتف';
                        } else if (value.length < 10) {
                          return 'يرجي إدخال رقم هاتف صحيح';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'وصف الحالة',
                            style: getbodyStyle(color: AppColors.black),
                          )
                        ],
                      ),
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      style: getbodyStyle(),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'تاريخ الحجز',
                            style: getbodyStyle(color: AppColors.black),
                          )
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 60,
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          TextFormField(
                            readOnly: true,
                            controller: _dateController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'من فضلك أدخل تاريخ الحجز';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            style: getbodyStyle(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: InkWell(
                              child: const CircleAvatar(
                                backgroundColor: AppColors.blueLagoon,
                                radius: 20,
                                child: Icon(
                                  Icons.date_range_outlined,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () {
                                selectDate(context);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'وقت الحجز',
                            style: getbodyStyle(color: AppColors.black),
                          )
                        ],
                      ),
                    ),

                    // available times chips
                    Wrap(spacing: 8.0, children: [
                      // the three dots indicates that u r working in design "separator"
                      for (int i = 0; i < times.length; i++) ...{
                        ChoiceChip(
                          backgroundColor: AppColors.blueSoftSky,
                          selectedColor: AppColors.blueLagoon,
                          label: Text(
                            '${times[i].toString()}:00',
                            style: TextStyle(
                              color: isSelected.contains(i)
                                  ? AppColors.white
                                  : AppColors.black,
                            ),
                          ),
                          selected: isSelected.contains(i),
                          onSelected: (selected) {
                            isSelected.clear();
                            setState(() {
                              isSelected.add(i);
                              // to add 0 before hours < 10 (9:00  ===> 09:00)
                              dateTime =
                                  '${(times[i] < 10) ? '0' : ''}${times[i].toString()}:00';
                            });
                          },
                        )
                      }
                    ]),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: CustomButton(
          text: 'تأكيد الحجز',
          onPressed: () {
            if (_formKey.currentState!.validate() && isSelected.first != -1) {
              _createAppointment();
              showAlertDialog(
                context,
                title: 'تم تسجيل الحجز !',
                ok: 'اضغط للانتقال',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyAppointments(),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _createAppointment() async {
    FirebaseFirestore.instance
        .collection('appointments')
        .doc('appointments')
        .collection('pending')
        .doc()
        .set({
      'patientID': user!.email,
      'doctorID': widget.doctor.email,
      'name': _nameController.text,
      'phone': _phoneController.text,
      'description': _descriptionController.text,
      'doctor': widget.doctor.name,
      'location': widget.doctor.address,
      'date': DateTime.parse('${dateUTC!} ${dateTime!}:00'),
      'isComplete': false,
      'rating': null
    }, SetOptions(merge: true));

    FirebaseFirestore.instance
        .collection('appointments')
        .doc('appointments')
        .collection('all')
        .doc()
        .set({
      'patientID': user!.email,
      'doctorID': widget.doctor.email,
      'name': _nameController.text,
      'phone': _phoneController.text,
      'description': _descriptionController.text,
      'doctor': widget.doctor.name,
      'location': widget.doctor.address,
      'date': DateTime.parse('${dateUTC!} ${dateTime!}:00'),
      'isComplete': false,
      'rating': null
    }, SetOptions(merge: true));
  }
}
