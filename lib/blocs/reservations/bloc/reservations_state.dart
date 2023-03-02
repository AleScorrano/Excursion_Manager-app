part of 'reservations_bloc.dart';

abstract class ReservationsState extends Equatable {
  const ReservationsState();

  @override
  List<Object> get props => [];
}

class ReservationsInitial extends ReservationsState {}

class OnCreateReservationState extends ReservationsState {}

class CreatedReservationState extends ReservationsState {}
