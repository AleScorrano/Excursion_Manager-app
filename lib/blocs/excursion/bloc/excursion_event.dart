part of 'excursion_bloc.dart';

abstract class ExcursionEvent extends Equatable {
  const ExcursionEvent();

  @override
  List<Object> get props => [];
}

class UpdateExcursionEvent extends ExcursionEvent {}

class DeleteExcursionEvent extends ExcursionEvent {}

class AddExcursionsEvent extends ExcursionEvent {
  final Excursion excursion;

  AddExcursionsEvent({required this.excursion});

  @override
  List<Object> get props => [excursion];
}
