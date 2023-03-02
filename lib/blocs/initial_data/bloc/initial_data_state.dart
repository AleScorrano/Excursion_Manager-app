part of 'initial_data_bloc.dart';

abstract class DownloadDataState extends Equatable {
  const DownloadDataState();

  @override
  List<Object> get props => [];
}

class OnDownloadDataState extends DownloadDataState {}

class DataFetchedState extends DownloadDataState {
  Stream<List<Excursion>> excursions;

  DataFetchedState({required this.excursions});
}

class ErrorDownloadDataState extends DownloadDataState {
  final Object? error;

  ErrorDownloadDataState(this.error);
}
