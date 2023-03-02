import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sacs_app/error/add_reservation_error.dart';
import 'package:sacs_app/error/get_reservations_error.dart';
import 'package:sacs_app/error/update_reservation_error.dart';
import 'package:sacs_app/extensions/future_map.dart';
import 'package:sacs_app/mappers/reservation_firebase_mapper.dart';
import 'package:sacs_app/models/excursion_model.dart';
import 'package:sacs_app/models/reservation_model.dart';

class ReservationRepository {
  final FirebaseFirestore firebaseFireStore;
  final ReservaTionFireBaseMapper reservationMapper;

  ReservationRepository({
    required this.firebaseFireStore,
    required this.reservationMapper,
  });

  Future<Stream<List<Reservation>>> getReservationsStream(
      String excursionId) async {
    return await firebaseFireStore
        .collection('Reservations')
        .where('excursion_Reference', isEqualTo: excursionId)
        .snapshots()
        .asyncMap(
          (snapshots) => snapshots.docs
              .futureMap<Reservation>(
                (reservationSnapshot) async =>
                    await reservationMapper.fromFirebase(
                  reservationSnapshot.data(),
                ),
              )
              .onError(
                (error, stackTrace) => throw GetReservationsError(
                  error.toString(),
                ),
              ),
        );
  }

  Future<void> create(Reservation reservation, Excursion excursion) async {
    await firebaseFireStore
        .collection('Reservations')
        .doc(reservation.reservationId)
        .set(reservationMapper.toFirebase(reservation))
        .onError(
          (error, stackTrace) => throw AddReservationError(error),
        );

    var reservationsReference = firebaseFireStore
        .collection('Reservations')
        .doc(reservation.reservationId);

    var referenceArray = List.from((await firebaseFireStore
            .collection('Excursions')
            .doc(excursion.excursionCode)
            .get()
            .onError(
              (error, stackTrace) => throw AddReservationError(error),
            ))
        .data()!['reservations_reference']);

    referenceArray.add(reservationsReference);

    await firebaseFireStore
        .collection('Excursions')
        .doc(excursion.excursionCode)
        .update(
      {
        'reservations_reference': FieldValue.arrayUnion(referenceArray),
        'total_passengers':
            FieldValue.increment(reservation.numberOfPassengers),
      },
    ).onError((error, stackTrace) => throw AddReservationError(error));
  }

  Future<void> update(Reservation reservation) async {
    await firebaseFireStore
        .collection('Reservations')
        .doc(reservation.reservationId)
        .update(reservationMapper.toFirebase(reservation))
        .onError(
          (error, stackTrace) => throw UpdateReservationError(error.toString()),
        );
  }
}
