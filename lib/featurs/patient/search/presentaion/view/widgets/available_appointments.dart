import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentService {
  final CollectionReference doctors =
      FirebaseFirestore.instance.collection('doctors');

  Future<List<DateTime>> getAvailableAppointments(
      DateTime selectedDate, String start, String end) async {
    int startHour = int.parse(start);
    int endHour = int.parse(end);

    List<DateTime> availableAppointments = [];
    for (int i = startHour; i < endHour; i++) {
      DateTime candidateTime =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day, i);
      // اذا كنا في نفس اليوم يباصي الساعات المتبقية من اليوم
      if (candidateTime.hour > DateTime.now().hour &&
          candidateTime.day == DateTime.now().day &&
          candidateTime.month == DateTime.now().month) {
        availableAppointments.add(candidateTime);
      }
      // اذا لم تكن في نفس اليوم باصي كل حجوزات الدكتور خلال يومه
      if (candidateTime.day != DateTime.now().day) {
        availableAppointments.add(candidateTime);
      }
    }

    return availableAppointments;
  }
}
