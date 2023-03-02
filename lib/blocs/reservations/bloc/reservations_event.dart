part of 'reservations_bloc.dart';

abstract class ReservationsEvent extends Equatable {
  const ReservationsEvent();

  @override
  List<Object> get props => [];
}

class CreateReservationsEvent extends ReservationsEvent {
  final Reservation reservation;
  final Excursion excursion;

  CreateReservationsEvent({
    required this.reservation,
    required this.excursion,
  });
  @override
  List<Object> get props => [reservation, excursion];
}

class DeleteReservationEvent extends ReservationsEvent {
  final Reservation reservation;

  DeleteReservationEvent({required this.reservation});
  @override
  List<Object> get props => [reservation];
}

class UpdateReservationEvent extends ReservationsEvent {
  final Reservation reservation;

  UpdateReservationEvent({required this.reservation});

  @override
  List<Object> get props => [reservation];
}
