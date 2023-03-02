import 'package:timeago/timeago.dart';

class Reservation {
  String? email;
  String? phoneNumber;
  String? notes;
  String excurionReference;
  String reservationId;
  String clientName;
  String clientSurname;
  int numberOfPassengers;
  double pricePerPassengers;
  bool isPaid;
  bool isNotifiedWithWhatsapp;
  bool isNotifiedWithEmail;
  String reservedBy;
  DateTime created_at;
  DateTime updated_at;

  Reservation({
    this.email,
    this.phoneNumber,
    this.notes,
    required this.isNotifiedWithEmail,
    required this.pricePerPassengers,
    required this.isPaid,
    required this.isNotifiedWithWhatsapp,
    required this.excurionReference,
    required this.reservationId,
    required this.clientName,
    required this.clientSurname,
    required this.numberOfPassengers,
    required this.reservedBy,
    required this.created_at,
    required this.updated_at,
  });

  factory Reservation.mock(String id) => Reservation(
        isNotifiedWithEmail: false,
        pricePerPassengers: 0.0,
        isPaid: false,
        isNotifiedWithWhatsapp: false,
        excurionReference: '',
        reservationId: id,
        clientName: 'mock',
        clientSurname: '',
        numberOfPassengers: 0,
        reservedBy: '',
        created_at: DateTime.now(),
        updated_at: DateTime.now(),
      );

  double get totalPrice => numberOfPassengers * pricePerPassengers;

  String get checkInCode =>
      reservationId.substring(0, 9) +
      created_at.millisecondsSinceEpoch.toString().substring(9, 13);

  static ReservationDifferenceCheck compareReservation(
      {required Reservation original, required Reservation updated}) {
    if (original.clientName == updated.clientName &&
        original.clientSurname == updated.clientSurname &&
        original.email == updated.email &&
        original.phoneNumber == updated.phoneNumber &&
        original.pricePerPassengers == updated.pricePerPassengers &&
        original.numberOfPassengers == updated.numberOfPassengers &&
        original.notes == updated.notes) {
      return ReservationDifferenceCheck.none;
    } else if (original.clientName == updated.clientName &&
        original.clientSurname == updated.clientSurname &&
        original.email == updated.email &&
        original.phoneNumber == updated.phoneNumber &&
        original.pricePerPassengers == updated.pricePerPassengers &&
        original.numberOfPassengers == updated.numberOfPassengers &&
        original.notes != updated.notes) {
      return ReservationDifferenceCheck.onlyNotes;
    } else {
      return ReservationDifferenceCheck.different;
    }
  }
}

enum ReservationDifferenceCheck { none, onlyNotes, different }
