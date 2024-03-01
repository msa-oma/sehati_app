import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sehati_app/featurs/auth/data/doctor_model.dart';

import '../../../../core/funcs/routing.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/text_style.dart';
import '../../../../core/widgets/custom_dialog.dart';
import '../../../doctor/home/nav_bar.dart';
import '../../data/specialization.dart';
import '../view_model/auth_cubit.dart';
import '../view_model/auth_state.dart';

class DoctorUploadData extends StatefulWidget {
  const DoctorUploadData({super.key});

  @override
  State<DoctorUploadData> createState() => _DoctorUploadDataState();
}

class _DoctorUploadDataState extends State<DoctorUploadData> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _phone1 = TextEditingController();
  final TextEditingController _phone2 = TextEditingController();
  String _specialization = specialization[0];

  late String _startTime =
      DateFormat('hh').format(DateTime(2023, 9, 7, 10, 00));
  late String _endTime = DateFormat('hh').format(DateTime(2023, 9, 7, 22, 00));

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _imagePath;
  File? file;
  String? profileUrl;

  User? user;

  Future<void> _getUser() async {
    user = FirebaseAuth.instance.currentUser;
  }

// 1) instance from FirebaseStorage with bucket Url..
  final FirebaseStorage _storage =
      FirebaseStorage.instanceFor(bucket: 'gs://sehati-app-hms.appspot.com');

// method to upload and get link of image
  Future<String> uploadImageToFireStore(File image) async {
    //2) choose file location (path)
    var ref = _storage.ref().child('doctors/${_auth.currentUser!.uid}');
    //3) choose file type (image/jpeg)
    var metadata = SettableMetadata(contentType: 'image/jpeg');
    // 4) upload image to Firebase Storage
    await ref.putFile(image, metadata);
    // 5) get image url
    String url = await ref.getDownloadURL();
    return url;
  }

  Future<void> _pickImage() async {
    _getUser();
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
        // to upload the file (image) to firebase storage
        file = File(pickedFile.path);
      });
    }
    profileUrl = await uploadImageToFireStore(file!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is UploadDoctorDataSuccessState) {
          pushAndRemoveUntil(
              context,
              //DoctorMainPage()
              const DoctorMainPage());
        } else if (state is UploadDoctorDataErrorState) {
          Navigator.pop(context);
          showErrorDialog(context, state.error);
        } else {
          showLoadingDialog(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إكمال عملية التسجيل'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            // backgroundColor: AppColors.lightBg,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: (_imagePath != null)
                                  ? FileImage(File(_imagePath!))
                                      as ImageProvider
                                  : const AssetImage('assets/doctor.png'),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await _pickImage();
                            },
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                size: 20,
                                // color: AppColors.color1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                        child: Row(
                          children: [
                            Text(
                              'التخصص',
                              style: getbodyStyle(color: AppColors.black),
                            )
                          ],
                        ),
                      ),
                      // choose your Specialization
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                            color: AppColors.blueSoftSky,
                            borderRadius: BorderRadius.circular(20)),
                        child: DropdownButton(
                          isExpanded: true,
                          iconEnabledColor: AppColors.blueLagoon,
                          icon: const Icon(Icons.expand_circle_down_outlined),
                          value: _specialization,
                          onChanged: (String? newValue) {
                            setState(() {
                              _specialization = newValue ?? specialization[0];
                            });
                          },
                          items: specialization.map((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              'نبذة تعريفية',
                              style: getbodyStyle(color: AppColors.black),
                            )
                          ],
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        maxLines: 5,
                        controller: _bio,
                        style: TextStyle(color: AppColors.black),
                        decoration: const InputDecoration(
                            hintText:
                                'سجل المعلومات الطبية العامة مثل تعليمك الأكاديمي وخبراتك السابقة...'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'من فضلك أدخل النبذة التعريفية';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Divider(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              'عنوان العيادة',
                              style: getbodyStyle(color: AppColors.black),
                            )
                          ],
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _address,
                        style: TextStyle(color: AppColors.black),
                        decoration: const InputDecoration(
                          hintText: '5 شارع مصدق - الدقي - الجيزة',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'من فضلك أدخل عنوان العيادة';
                          } else {
                            return null;
                          }
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    'ساعات العمل من',
                                    style: getbodyStyle(color: AppColors.black),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    'إلى',
                                    style: getbodyStyle(color: AppColors.black),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          // ---------- Start Time ----------------
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () async {
                                      await showStartTimePicker();
                                    },
                                    icon: const Icon(
                                      Icons.watch_later_outlined,
                                      color: AppColors.blueLagoon,
                                    )),
                                hintText: _startTime,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),

                          // ---------- End Time ----------------
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () async {
                                      await showEndTimePicker();
                                    },
                                    icon: const Icon(
                                      Icons.watch_later_outlined,
                                      color: AppColors.blueLagoon,
                                    )),
                                hintText: _endTime,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              'رقم الهاتف 1',
                              style: getbodyStyle(color: AppColors.black),
                            )
                          ],
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _phone1,
                        style: TextStyle(color: AppColors.black),
                        decoration: const InputDecoration(
                          hintText: '+20xxxxxxxxxx',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'من فضلك ادخل الرقم';
                          } else {
                            return null;
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              'رقم الهاتف 2 (اختياري)',
                              style: getbodyStyle(color: AppColors.black),
                            )
                          ],
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _phone2,
                        style: TextStyle(color: AppColors.black),
                        decoration: const InputDecoration(
                          hintText: '+20xxxxxxxxxx',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.only(top: 25.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  context.read<AuthCubit>().uploadDoctorData(DoctorModel(
                      id: user!.uid,
                      name: user?.displayName ?? '',
                      image: profileUrl ?? '',
                      specialization: _specialization,
                      rating: 3,
                      email: user!.email!,
                      phone1: _phone1.text,
                      phone2: _phone2.text,
                      bio: _bio.text,
                      openHour: int.parse(_startTime),
                      closeHour: int.parse(_endTime),
                      address: _address.text));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blueLagoon,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "التسجيل",
                style: getTitleStyle(fontSize: 16, color: AppColors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  showStartTimePicker() async {
    final datePicked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      // builder: (context, child) {
      //   return Theme(
      //     data: ThemeData(
      //       timePickerTheme: TimePickerThemeData(
      //           helpTextStyle: TextStyle(color: AppColors.color1),
      //           backgroundColor: Theme.of(context).scaffoldBackgroundColor),
      //       colorScheme: ColorScheme.light(
      //         background: Theme.of(context).scaffoldBackgroundColor,
      //         primary: AppColors.color1, // header background color
      //         secondary: AppColors.black,
      //         onSecondary: AppColors.black,
      //         onPrimary: AppColors.black, // header text color
      //         onSurface: AppColors.black, // body text color
      //         surface: AppColors.black, // body text color
      //       ),
      //       textButtonTheme: TextButtonThemeData(
      //         style: TextButton.styleFrom(
      //           foregroundColor: AppColors.color1, // button text color
      //         ),
      //       ),
      //     ),
      //     child: child!,
      //   );
      // },
    );

    if (datePicked != null) {
      setState(() {
        _startTime = datePicked.hour.toString();
      });
    }
  }

  showEndTimePicker() async {
    final timePicker = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
          DateTime.now().add(const Duration(minutes: 15))),
    );

    if (timePicker != null) {
      setState(() {
        _endTime = timePicker.hour.toString();
      });
    }
  }
}
