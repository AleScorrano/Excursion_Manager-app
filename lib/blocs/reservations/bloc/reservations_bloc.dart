import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sacs_app/models/excursion_model.dart';
import 'package:sacs_app/models/reservation_model.dart';
import 'package:sacs_app/repositories/excursion_repository.dart';
import 'package:sacs_app/repositories/reservation_repository.dart';

part 'reservations_event.dart';
part 'reservations_state.dart';

class ReservationsBloc extends Bloc<ReservationsEvent, ReservationsState> {
  final ExcursionRepository excursionRepository;
  final ReservationRepository reservationRepository;

  ReservationsBloc({
    required this.excursionRepository,
    required this.reservationRepository,
  }) : super(ReservationsInitial()) {
    on<ReservationsEvent>(
      (event, emit) async {
        if (event is CreateReservationsEvent) {
          emit(OnCreateReservationState());

          await reservationRepository.create(
              event.reservation, event.excursion);
        }
        if (event is UpdateReservationEvent) {
          emit(OnCreateReservationState());
          await reservationRepository.update(event.reservation);
        }
      },
    );
  }

  void addReservation(
          {required Reservation reservation, required Excursion excursion}) =>
      add(CreateReservationsEvent(
          reservation: reservation, excursion: excursion));

  void updateReservation({required Reservation reservation}) =>
      add(UpdateReservationEvent(
        reservation: reservation,
      ));
}
