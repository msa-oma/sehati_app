class DoctorModel {
  final String id;
  final String name;
  final String image;
  final String specialization;
  final int rating;
  final String email;
  final String phone1;
  final String phone2;
  final String bio;
  final String openHour;
  final String closeHour;
  final String address;

  DoctorModel(
      {required this.id,
      required this.name,
      required this.image,
      required this.specialization,
      required this.rating,
      required this.email,
      required this.phone1,
      required this.phone2,
      required this.bio,
      required this.openHour,
      required this.closeHour,
      required this.address});
}
