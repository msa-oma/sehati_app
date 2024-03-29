import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sehati_app/core/funcs/email_validate.dart';

import '../../../../core/funcs/routing.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/text_style.dart';
import '../../../../core/widgets/custom_dialog.dart';
import '../../../patient/home/presentaion/nav_bar.dart';
import '../view_model/auth_cubit.dart';
import '../view_model/auth_state.dart';
import 'doctor_upload_view.dart';
import 'login_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key, required this.index});
  final int index;

  @override
  State<RegisterView> createState() => _RegisterViewState();
  //_RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _displayName = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isVisable = true;

  String handleUserType(int index) {
    return index == 0 ? 'دكتور' : 'مريض';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is RegisterSuccessState) {
          if (widget.index == 0) {
            pushAndRemoveUntil(context, const DoctorUploadData());
          } else {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const PatientMainPage(),
              ),
              (route) => false,
            );
          }
        } else if (state is RegisterErrorState) {
          Navigator.pop(context);
          showErrorDialog(context, state.error);
        } else {
          showLoadingDialog(context);
        }
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(right: 16, left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/logo.png',
                      height: 200,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'سجل حساب جديد كـ "${handleUserType(widget.index)}"',
                      style: getTitleStyle(),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      controller: _displayName,
                      style: const TextStyle(color: AppColors.blackCharcoal),
                      decoration: InputDecoration(
                        hintText: 'الاسم',
                        hintStyle: getbodyStyle(color: Colors.grey),
                        prefixIcon: const Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) return 'من فضلك ادخل الاسم';
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      textAlign: TextAlign.end,
                      decoration: const InputDecoration(
                        hintText: 'msa@example.com',
                        prefixIcon: Icon(Icons.email_rounded),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ' من فضلك ادخل البريد الالكتروني ';
                        } else if (!emailValidate(value)) {
                          return 'من فضلك ادخل البريد الالكتروني صحيحا';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    TextFormField(
                      textAlign: TextAlign.end,
                      style: const TextStyle(color: AppColors.blackCharcoal),
                      obscureText: isVisable,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        hintText: '********',
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isVisable = !isVisable;
                              });
                            },
                            icon: Icon((isVisable)
                                ? Icons.remove_red_eye
                                : Icons.visibility_off_rounded)),
                        prefixIcon: const Icon(Icons.lock),
                      ),
                      controller: _passwordController,
                      validator: (value) {
                        if (value!.isEmpty) return 'من فضلك ادخل كلمة السر';
                        return null;
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (widget.index == 0) {
                                context.read<AuthCubit>().registerDoctor(
                                    _displayName.text,
                                    _emailController.text,
                                    _passwordController.text);
                              } else {
                                context.read<AuthCubit>().registerPatient(
                                    _displayName.text,
                                    _emailController.text,
                                    _passwordController.text);
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blueLagoon,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            "تسجيل حساب",
                            style: getTitleStyle(color: AppColors.white),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'لدي حساب ؟',
                            style: getbodyStyle(color: AppColors.blackCharcoal),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (context) =>
                                      LoginView(index: widget.index),
                                ));
                              },
                              child: Text(
                                'سجل دخول',
                                style:
                                    getbodyStyle(color: AppColors.blueLagoon),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
