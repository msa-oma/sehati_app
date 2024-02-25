import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitSatete());

  // login

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
      user.updateDisplayName(name);

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
        emit(RegisterErrorState(error: 'كلمة السر ضعيفه'));
      } else if (e.code == 'email-already-in-use') {
        emit(RegisterErrorState(error: 'الحساب موجود بالفعل'));
      }
    } catch (e) {
      emit(RegisterErrorState(error: 'حدثت مشكله فالتسجيل حاول لاحقا'));
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
        emit(RegisterErrorState(error: 'حدثت مشكله فالتسجيل'));
      }
    }
  }
}
