part of 'sliding_panel_bloc.dart';

abstract class SlidingPanelBlocState extends Equatable {
  const SlidingPanelBlocState();

  @override
  List<Object> get props => [];
}

class SlidingPanelCloseState extends SlidingPanelBlocState {}

class SlidingPanelMinimizedState extends SlidingPanelBlocState {}

class SLidingPanelOpenState extends SlidingPanelBlocState {
  final Stream<Excursion> excursionStream;
  final Stream<List<Reservation>> reservationsStream;
  SLidingPanelOpenState(
    this.excursionStream,
    this.reservationsStream,
  );
}
