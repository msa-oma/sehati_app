class AuthStates {}

class AuthInitSatete extends AuthStates {}

// login

class LoginLoadingState extends AuthStates {}

class LoginSuccessState extends AuthStates {}

class LoginErrorState extends AuthStates {
  final String error;

  LoginErrorState({required this.error});
}

// register

class RegisterLoadingState extends AuthStates {}

class RegisterSuccessState extends AuthStates {}

class RegisterErrorState extends AuthStates {
  final String error;

  RegisterErrorState({required this.error});
}

// upload data

class UploadDoctorDataLoadingState extends AuthStates {}

class UploadDoctorDataSuccessState extends AuthStates {}

class UploadDoctorDataErrorState extends AuthStates {
  final String error;

  UploadDoctorDataErrorState({required this.error});
}
