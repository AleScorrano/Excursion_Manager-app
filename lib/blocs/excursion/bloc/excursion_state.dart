part of 'excursion_bloc.dart';

abstract class ExcursionState extends Equatable {
  const ExcursionState();

  @override
  List<Object> get props => [];
}

class ExcursionInitial extends ExcursionState {}

class OnAddingExcursionState extends ExcursionState {}

class ExcursionAddedState extends ExcursionState {}

class ErrorAddExcursionState extends ExcursionState {}
