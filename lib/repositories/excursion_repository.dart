import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sacs_app/exceptions/excursion_repository_exception.dart';
import 'package:sacs_app/extensions/future_map.dart';
import 'package:sacs_app/mappers/reservation_firebase_mapper.dart';
import 'package:sacs_app/models/excursion_model.dart';
import 'package:sacs_app/repositories/reservation_repository.dart';
import '../mappers/excursion_firebase_mapper.dart';

class ExcursionRepository {
  final FirebaseFirestore firebaseFirestore;
  final ExcursionMapper excursionMapper;
  final ReservationRepository reservationRepository;
  final ReservaTionFireBaseMapper reservationMapper;

  ExcursionRepository({
    required this.firebaseFirestore,
    required this.excursionMapper,
    required this.reservationRepository,
    required this.reservationMapper,
  });

  Future<void> create(Excursion excursion) async {
    firebaseFirestore
        .collection('Excursions')
        .doc(excursion.excursionCode)
        .set(excursionMapper.toFirebase(excursion))
        .onError(
          (error, stackTrace) => throw new ExcursionRepositoryError(error),
        );
  }

  Stream<List<Excursion>> excursions() {
    return firebaseFirestore.collection('Excursions').snapshots().asyncMap(
          (snapshot) => snapshot.docs.futureMap<Excursion>(
            (excursionSnapshot) async {
              try {
                final excursions = await excursionMapper
                    .fromFirebaseAsync(excursionSnapshot.data())
                    .onError(
                      (error, stackTrace) =>
                          throw new ExcursionRepositoryError(error),
                    );
                return excursions;
              } catch (e) {
                throw ExcursionRepositoryError(e);
              }
            },
          ),
        );
  }

  Stream<Excursion> getExcursion(String id) {
    bool isNull = false;

    final reference = firebaseFirestore
        .collection('Excursions')
        .where('excursion_code', isEqualTo: id, isNull: isNull);

    if (!isNull) {
      return reference.snapshots().asyncMap(
            (snapshot) => excursionMapper
                .fromFirebaseAsync(snapshot.docs.first.data())
                .onError(
                  (error, stackTrace) =>
                      throw new ExcursionRepositoryError(error),
                ),
          );
    }
  }

  Stream<List<int>> getTotalPassengers(String excursionId) {
    return firebaseFirestore
        .collection('Reservations')
        .where('excursion_Reference', isEqualTo: excursionId)
        .snapshots()
        .asyncMap(
      (snapshot) async {
        return await (snapshot.docs
            .map((e) => (e.data()['number_of_passengers'] as int))).toList();
      },
    );
  }
}


/*

 */
