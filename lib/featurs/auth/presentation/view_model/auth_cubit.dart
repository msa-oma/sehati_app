import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/doctor_model.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitSatete());

  // login
  login(String email, String password) async {
    emit(RegisterLoadingState());

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(RegisterSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(LoginErrorState(error: 'لا يوجد حساب على هذا الايميل'));
      } else if (e.code == 'wrong-password') {
        emit(LoginErrorState(error: 'كلمة المرور التي أدخلتها غير صحيحة'));
      } else {
        emit(LoginErrorState(error: 'حدثت مشكلة في تسجيل الدخول حاول لاحقاً'));
      }
    }
  }

  // register as doctor
  registerDoctor(String name, String email, String password) async {
    emit(RegisterLoadingState());
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = credential.user!;
      await user.updateDisplayName(name);

      // firestore
      FirebaseFirestore.instance.collection('doctors').doc(user.uid).set({
        'name': name,
        'image': null,
        'specialization': null,
        'rating': null,
        'email': user.email,
        'phone1': null,
        'phone2': null,
        'bio': null,
        'openHour': null,
        'closeHour': null,
        'address': null,
      }, SetOptions(merge: true));
      emit(RegisterSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(RegisterErrorState(error: 'كلمة المرور ضعيفة'));
      } else if (e.code == 'email-already-in-use') {
        emit(RegisterErrorState(error: 'الحساب موجود بالفعل'));
      }
    } catch (e) {
      emit(RegisterErrorState(error: 'حدثت مشكلة في التسجيل حاول لاحقاً'));
    }
  }
  // register as patient

  registerPatient(String name, String email, String password) async {
    emit(RegisterLoadingState());
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // User from Auth && Firestore

      User user = credential.user!;
      await user.updateDisplayName(name);

      FirebaseFirestore.instance.collection('patient').doc(user.uid).set({
        'name': name,
        'email': user.email,
        'image': '',
        'bio': '',
        'city': '',
        'phone': '',
        'age': null,
      }, SetOptions(merge: true));

      emit(RegisterSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(RegisterErrorState(error: 'كلمة المرور ضعيفة'));
      } else if (e.code == 'email-already-in-use') {
        emit(RegisterErrorState(error: 'الحساب موجود بالفعل'));
      } else {
        emit(RegisterErrorState(error: 'حدثت مشكلة في التسجيل حاول لاحقاً'));
      }
    }
  }

  uploadDoctorData(DoctorModel doctor) {
    emit(UploadDoctorDataLoadingState());

    try {
      FirebaseFirestore.instance.collection('doctor').doc(doctor.id).set({
        'image': doctor.image,
        'specialization': doctor.specialization,
        'rating': doctor.rating,
        'phone1': doctor.phone1,
        'phone2': doctor.phone2,
        'bio': doctor.bio,
        'openHour': doctor.openHour,
        'closeHour': doctor.closeHour,
        'address': doctor.address,
      }, SetOptions(merge: true));

      emit(UploadDoctorDataSuccessState());
    } catch (e) {
      emit(UploadDoctorDataErrorState(error: 'حدثت مشكلة ما حاول لاحقاً'));
    }
  }
  //
}
