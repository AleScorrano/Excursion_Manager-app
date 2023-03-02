part of 'media_sender_bloc.dart';

abstract class MediaSenderEvent extends Equatable {
  const MediaSenderEvent();

  @override
  List<Object> get props => [];
}

class CreatePdfEvent extends MediaSenderEvent {
  final Excursion excursion;
  final Reservation reservation;

  CreatePdfEvent({required this.excursion, required this.reservation});
}

class SendEmailEvent extends MediaSenderEvent {
  final File pdf;

  SendEmailEvent({required this.pdf});
}

class OpenWhatsappEvent extends MediaSenderEvent {}
