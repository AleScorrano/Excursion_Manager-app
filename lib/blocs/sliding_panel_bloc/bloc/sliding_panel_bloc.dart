import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sacs_app/mappers/excursion_firebase_mapper.dart';
import 'package:sacs_app/models/excursion_model.dart';
import 'package:sacs_app/models/reservation_model.dart';
import 'package:sacs_app/repositories/excursion_repository.dart';
import 'package:sacs_app/repositories/reservation_repository.dart';

part 'sliding_panel_bloc_event.dart';
part 'sliding_panel_bloc_state.dart';

class SlidingPanelBloc
    extends Bloc<SlidingPanelBlocEvent, SlidingPanelBlocState> {
  ExcursionRepository excursionRepository;
  ReservationRepository reservationRepository;
  SlidingPanelBloc({
    required this.excursionRepository,
    required this.reservationRepository,
  }) : super(SlidingPanelCloseState()) {
    on<SlidingPanelBlocEvent>((event, emit) {
      on<ClosePanelEvent>((event, emit) => emit(SlidingPanelCloseState()));
      on<MinimizePanelEvent>(
          (event, emit) => emit(SlidingPanelMinimizedState()));
      on<OpenPanelEvent>((event, emit) async {
        Stream<Excursion> excursionStream = await excursionRepository
            .getExcursion(event.excursion.excursionCode);
        Stream<List<Reservation>> reservationsStream =
            await reservationRepository
                .getReservationsStream(event.excursion.excursionCode);
        emit(SLidingPanelOpenState(excursionStream, reservationsStream));
      });
    });
  }

  void openPanel(Excursion excursion) async {
    Stream<Excursion> excursionStream =
        await excursionRepository.getExcursion(excursion.excursionCode);
    Stream<List<Reservation>> reservationsStream = await reservationRepository
        .getReservationsStream(excursion.excursionCode);
    emit(SLidingPanelOpenState(excursionStream, reservationsStream));
  }

  void minimizePanel() => emit(SlidingPanelMinimizedState());

  void closePanel() => emit(SlidingPanelCloseState());
}
