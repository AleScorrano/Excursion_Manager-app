import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:sacs_app/error/create_file_error.dart';
import 'package:sacs_app/models/excursion_model.dart';
import 'package:sacs_app/models/reservation_model.dart';

class FileSaver {
  Future<File?> saveDesktopFile({
    required Uint8List ticket,
    required Reservation reservation,
    required Excursion excursion,
  }) async {
    try {
      final String fileName =
          '${reservation.clientName}_${reservation.clientSurname}_${DateFormat('dd mm yy').format(excursion.startTime)}_${reservation.checkInCode}.pdf';
      String? path = await FilePicker.platform.saveFile(fileName: fileName);
      if (path != null) {
        final file = File(path);
        await file.writeAsBytes(ticket).onError(
              (error, stackTrace) => throw CreateFileError(error.toString()),
            );
        return file;
      } else {
        return null;
      }
    } catch (e) {
      throw CreateFileError(e.toString());
    }
  }
}
