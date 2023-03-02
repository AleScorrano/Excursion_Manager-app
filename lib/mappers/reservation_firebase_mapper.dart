import 'package:sacs_app/mappers/firebase_mapper.dart';
import 'package:sacs_app/models/reservation_model.dart';

class ReservaTionFireBaseMapper extends FireBaseMapper<Reservation> {
  @override
  fromFirebase(Map<String, dynamic> map) => Reservation(
        email: map['email'] ?? null,
        phoneNumber: map['phone_Number'] ?? null,
        notes: map['notes'] ?? null,
        excurionReference: map['excursion_Reference'],
        reservationId: map['reservation_code'],
        clientName: map['client_name'],
        clientSurname: map['client_surname'],
        numberOfPassengers: map['number_of_passengers'],
        pricePerPassengers:
            map['price_Per_passengers'] ?? 10.0, // da sistemare!!!!!!!!,
        isPaid: map['isPaid'],
        isNotifiedWithWhatsapp: map['is_Notified_With_Whatsapp'],
        isNotifiedWithEmail: map['is_Notified_With_Email'],
        reservedBy: map['reserved_by'],
        created_at: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
        updated_at: DateTime.fromMillisecondsSinceEpoch(map['updated_at']),
      );

  @override
  Map<String, dynamic> toFirebase(Reservation reservation) => {
        'email': reservation.email ?? null,
        'phone_Number': reservation.phoneNumber ?? null,
        'notes': reservation.notes ?? null,
        'excursion_Reference': reservation.excurionReference,
        'reservation_code': reservation.reservationId,
        'client_name': reservation.clientName,
        'client_surname': reservation.clientSurname,
        'number_of_passengers': reservation.numberOfPassengers,
        'price_Per_passengers': reservation.pricePerPassengers,
        'isPaid': reservation.isPaid,
        'is_Notified_With_Whatsapp': reservation.isNotifiedWithWhatsapp,
        'is_Notified_With_Email': reservation.isNotifiedWithEmail,
        'reserved_by': reservation.reservedBy,
        'created_at': reservation.created_at.millisecondsSinceEpoch,
        'updated_at': reservation.updated_at.millisecondsSinceEpoch,
      };
}
