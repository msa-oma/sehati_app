import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/funcs/email_validate.dart';
import '../../../../core/funcs/routing.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/text_style.dart';
import '../../../../core/widgets/custom_dialog.dart';
import '../../../patient/home/presentaion/nav_bar.dart';
import '../view_model/auth_cubit.dart';
import '../view_model/auth_state.dart';
import 'doctor_upload_view.dart';
import 'signup_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key, required this.index});
  final int index;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

// Related to the password field
  bool isVisable = true;

  String handleUserType() {
    return widget.index == 0 ? 'دكتور' : 'مريض';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
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
        } else if (state is LoginErrorState) {
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      height: 200,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'سجل دخول الآن كـ "${handleUserType()}"',
                      style: getTitleStyle(),
                    ),
                    const SizedBox(height: 30),
                    //for Email
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      textAlign: TextAlign.end,
                      decoration: const InputDecoration(
                        hintText: 'msa@example.com',
                        prefixIcon: Icon(Icons.email_rounded),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'من فضلك ادخل الايميل';
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
                    //for password
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
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(top: 5, right: 10),
                      child: Text(
                        'نسيت كلمة السر ؟',
                        style: getsmallStyle(),
                      ),
                    ),
                    //login btn
                    Container(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await context.read<AuthCubit>().login(
                                  _emailController.text,
                                  _passwordController.text);
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
                            "تسجيل الدخول",
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
                            'ليس لدي حساب ؟',
                            style: getbodyStyle(color: AppColors.blackCharcoal),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (context) =>
                                      RegisterView(index: widget.index),
                                ));
                              },
                              child: Text(
                                'سجل الان',
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
