part of 'sliding_panel_bloc.dart';

abstract class SlidingPanelBlocEvent extends Equatable {
  const SlidingPanelBlocEvent();

  @override
  List<Object> get props => [];
}

class ClosePanelEvent extends SlidingPanelBlocEvent {}

class OpenPanelEvent extends SlidingPanelBlocEvent {
  final Excursion excursion;
  OpenPanelEvent(
    this.excursion,
  );
}

class MinimizePanelEvent extends SlidingPanelBlocEvent {}
