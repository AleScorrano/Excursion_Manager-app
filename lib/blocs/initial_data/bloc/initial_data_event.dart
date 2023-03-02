part of 'initial_data_bloc.dart';

abstract class DownloadDataEvent extends Equatable {
  const DownloadDataEvent();

  @override
  List<Object> get props => [];
}

class OnDownloadDataEvent extends DownloadDataEvent {}
