import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sacs_app/error/get_reservations_error.dart';
import 'package:sacs_app/mappers/firebase_mapper.dart';
import 'package:sacs_app/mappers/reservation_firebase_mapper.dart';
import 'package:sacs_app/models/reservation_model.dart';
import '../models/excursion_model.dart';

class ExcursionMapper extends FireBaseMapper<Excursion> {
  ReservaTionFireBaseMapper reservationMapper;
  ExcursionMapper({required this.reservationMapper});

  @override
  Excursion fromFirebase(Map<String, dynamic> map) => Excursion(
        excursionCode: map['excursion_code'],
        color: Color(map['color']).withOpacity(1),
        excursionTipe: getExcursionTypeByString(map['excursion_tipe']),
        excursionStart:
            DateTime.fromMillisecondsSinceEpoch(map['excursion_start']),
        maxPassengers: map['max_passengers'],
        excursionEnd: DateTime.fromMillisecondsSinceEpoch(map['excursion_end']),
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at']),
        reservations: [],
      );

  Future<Excursion> fromFirebaseAsync(Map<String, dynamic> map) async {
    List<Reservation>? reservations = await Future.wait(
      (map['reservations_reference'] as List).map(
        (reference) async {
          var document = await reference.get();
          if (!document.exists) {
            return Reservation.mock(document.id);
          }
          return reservationMapper.fromFirebase(document.data());
        },
      ),
    );

    try {
      return Excursion(
          excursionCode: map['excursion_code'],
          color: Color(map['color']).withOpacity(1),
          excursionTipe: getExcursionTypeByString(map['excursion_tipe']),
          excursionStart:
              DateTime.fromMillisecondsSinceEpoch(map['excursion_start']),
          excursionEnd:
              DateTime.fromMillisecondsSinceEpoch(map['excursion_end']),
          maxPassengers: map['max_passengers'],
          createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
          updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at']),
          reservationsReference: map['reservations_reference'],
          totalPassengers: reservations.fold(
              0,
              (previousValue, reservaton) =>
                  previousValue! + reservaton.numberOfPassengers),
          reservations: reservations);
    } catch (e) {
      throw GetReservationsError(e.toString());
    }
  }

  @override
  Map<String, dynamic> toFirebase(Excursion excursion) => {
        'color': excursion.color.value,
        'created_at': excursion.createdAt.millisecondsSinceEpoch,
        'updated_at': excursion.updatedAt.millisecondsSinceEpoch,
        'excursion_code': excursion.excursionCode,
        'excursion_start': excursion.startTime.millisecondsSinceEpoch,
        'excursion_end': excursion.endTime.millisecondsSinceEpoch,
        'excursion_tipe':
            excursion.getExcursionTipeToString(excursion.excursionTipe),
        'max_passengers': excursion.maxPassengers,
        'total_passengers': excursion.totalPassengers,
        'reservations_reference': [].cast<DocumentReference>(),
      };

  ExcursionTipe getExcursionTypeByString(String tipe) {
    if (tipe == 'Normale') {
      return ExcursionTipe.normal;
    } else if (tipe == 'Personal') {
      return ExcursionTipe.personalized;
    } else if (tipe == 'Tramonto') {
      return ExcursionTipe.sunset;
    }

    return ExcursionTipe.normal;
  }

  String getExcursionTipeByEnum(ExcursionTipe tipe) {
    switch (tipe) {
      case ExcursionTipe.normal:
        {
          return 'Normale';
        }

      case ExcursionTipe.personalized:
        {
          return 'Personalizzata';
        }

      case ExcursionTipe.sunset:
        {
          return 'Tramonto';
        }
    }
  }
}






/* */
