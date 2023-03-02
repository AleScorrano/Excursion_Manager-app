import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sacs_app/models/excursion_model.dart';
import 'package:sacs_app/models/reservation_model.dart';
import 'package:sacs_app/utils/file_saver.dart';
import 'package:sacs_app/utils/ticket_generator.dart';
import 'package:sacs_app/utils/whatsapp_sender.dart';

part 'media_sender_event.dart';
part 'media_sender_state.dart';

class MediaSenderBloc extends Bloc<MediaSenderEvent, MediaSenderState> {
  final ticketGenerator = TicketGenerator();
  final fileSaver = FileSaver();
  final whatsappSender = WhatsappSender();
  MediaSenderBloc() : super(MediaSenderInitial()) {
    on<MediaSenderEvent>(
      (event, emit) async {
        if (event is CreatePdfEvent) {
          if (Platform.isMacOS || Platform.isWindows) {
            desktopSendingProcess(event);
          }
        }
      },
    );
  }

  emailSender(String? email) {
    //Todo implementare funzione.
  }

  void createTicket(
          {required Excursion excursion, required Reservation reservation}) =>
      add(
        CreatePdfEvent(excursion: excursion, reservation: reservation),
      );

  void resetState() => emit(MediaSenderInitial());

  Future<void> desktopSendingProcess(CreatePdfEvent event) async {
    emit(OnCreatePdfState());

    Uint8List ticket = await ticketGenerator.createPDF(
        excursion: event.excursion, reservation: event.reservation);

    if (ticket.isEmpty) {
      emit(ErrorCreateTicketState());
      return;
    }

    emit(WaitingForSaveFileState());
    File? file = await fileSaver.saveDesktopFile(
        ticket: ticket,
        reservation: event.reservation,
        excursion: event.excursion);
    if (file == null) {
      emit(ErrorCreateTicketState());
      return;
    }

    emit(
      FileSavedState(
          reservation: event.reservation,
          excursion: event.excursion,
          file: file),
    );
    emit(MediaSenderInitial());

    if (event.reservation.isNotifiedWithWhatsapp) {
      emit(OpeningWhatsappState());
      await whatsappSender
          .openWhatsappDesktop(event.reservation.phoneNumber)
          .whenComplete(() => emit(WhatsappOpenedState()));
    }
    if (event.reservation.isNotifiedWithEmail) {
      emit(OnSendingEmailState());
      emailSender(event.reservation.email);
    }
  }
}
