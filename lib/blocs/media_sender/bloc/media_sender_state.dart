part of 'media_sender_bloc.dart';

abstract class MediaSenderState extends Equatable {
  const MediaSenderState();

  @override
  List<Object> get props => [];
}

class MediaSenderInitial extends MediaSenderState {}

class OnCreatePdfState extends MediaSenderState {}

class WaitingForSaveFileState extends MediaSenderState {}

class FileSavedState extends MediaSenderState {
  final Excursion excursion;
  final Reservation reservation;
  final File file;

  FileSavedState({
    required this.excursion,
    required this.reservation,
    required this.file,
  });
  @override
  List<Object> get props => [excursion, reservation, file];
}

class OnSendingEmailState extends MediaSenderState {}

class EmailSendedState extends MediaSenderState {}

class OpeningWhatsappState extends MediaSenderState {}

class WhatsappOpenedState extends MediaSenderState {}

class ErrorCreateTicketState extends MediaSenderState {}
