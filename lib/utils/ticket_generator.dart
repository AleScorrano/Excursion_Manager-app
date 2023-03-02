import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:sacs_app/models/excursion_model.dart';
import 'package:sacs_app/models/reservation_model.dart';

class TicketGenerator {
  static const primaryColor = PdfColor.fromInt(0xFF04588c);
  static const primaryColorlight = PdfColor.fromInt(0xFF4b84bc);
  static const secondaryColorDark = PdfColor.fromInt(0xFF007d8f);
  static const complementaryColor1 = PdfColor.fromInt(0xFFD99A4E);
  static const complementaryColor1Light = PdfColor.fromInt(0xFFF2D0A7);
  static const complementaryColor2 = PdfColor.fromInt(0xFFF2F2F0);

  Future<Uint8List> createPDF(
      {required Excursion excursion, required Reservation reservation}) async {
    final logo = pw.MemoryImage(
      (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List(),
    );
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        orientation: pw.PageOrientation.natural,
        pageFormat: PdfPageFormat.a5,
        margin: pw.EdgeInsets.all(18),
        build: (pw.Context context) {
          return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Partition(
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Image(logo, width: 120, height: 120),
                    headerInfo(),
                  ],
                ),
              ),
              pw.Padding(
                padding: pw.EdgeInsets.only(top: 12, bottom: 0),
                child: pw.Container(
                  padding: pw.EdgeInsets.all(4),
                  width: double.maxFinite,
                  decoration: pw.BoxDecoration(color: primaryColorlight),
                  child: pw.Center(
                    child: pw.Text(
                      'TOUR  ${excursion.getExcursionTipeToString(excursion.excursionTipe).toUpperCase()}',
                      style: pw.TextStyle(
                          letterSpacing: 1,
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                          color: complementaryColor2),
                    ),
                  ),
                ),
              ),
              pw.Table(
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(
                        color: complementaryColor2,
                        border: pw.Border.symmetric(
                            horizontal:
                                pw.BorderSide(color: primaryColorlight))),
                    children: [
                      textInfoClient('Nome e Cognome',
                          '${reservation.clientName}  ${reservation.clientSurname}'),
                      textInfoClient('n° Passeggeri / ridotti',
                          '${reservation.numberOfPassengers} / 0'),
                    ],
                  ),
                  pw.TableRow(
                    decoration: pw.BoxDecoration(
                        color: complementaryColor2,
                        border: pw.Border.symmetric(
                            horizontal:
                                pw.BorderSide(color: primaryColorlight))),
                    children: [
                      textInfoClient('Data',
                          '${DateFormat('dd MMMM yyy').format(excursion.startTime)}'),
                      textInfoClient('fascia oraria',
                          '${DateFormat('Hm').format(excursion.startTime)} - ${DateFormat('Hm').format(excursion.endTime)}'),
                    ],
                  ),
                  pw.TableRow(
                    decoration: pw.BoxDecoration(
                        color: complementaryColor2,
                        border: pw.Border.symmetric(
                            horizontal:
                                pw.BorderSide(color: primaryColorlight))),
                    children: [
                      textInfoClient('Totale', '${reservation.totalPrice}'),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              qrCode(reservation.checkInCode),
              pw.Expanded(child: pw.SizedBox()),
              infoFooter(),
            ],
          );
        },
      ),
    );

    //final file = File('example.pdf');  crea file nella path del progetto
    // await file.writeAsBytes(await pdf.save()); scrive il file.

    return pdf.save();
  }

  pw.Widget qrCode(String checkInCode) => pw.Column(
        children: [
          pw.Text(checkInCode),
          pw.SizedBox(height: 10),
          pw.BarcodeWidget(
            data: checkInCode,
            width: 150,
            height: 150,
            barcode: pw.Barcode.qrCode(),
            drawText: false,
          ),
        ],
      );

  pw.Widget headerInfo() => pw.Padding(
        padding: pw.EdgeInsets.only(left: 12),
        child: pw.Column(
          children: [
            headertext('di Lucia Marchese'),
            headertext('Via San Martino 55 - 73040 Morciano di Leuca (LE)'),
            headertext('E-mail: escursionisacslaura@gmail.com'),
            headertext('Sito web: www.escursionisacslaura.it'),
            headertext('P.iva: 03789810755'),
          ],
        ),
      );

  pw.Text headertext(String text) {
    return pw.Text(text, style: pw.TextStyle(fontSize: 8));
  }

  pw.Widget infoFooter() => pw.Text(
        '''
Documento valido per la validazione della prenotazione al momento dell'imbarco.
lo svoglimento del tour prevede una durata di cica tre ore in cui è prevista una sosta per il bagno e un piccolo aperitivo

in caso di condizioni meteo avverse verrete contattati da noi per riprogrammare l'escursione o effetuare il rimborso.

''',
        style: pw.TextStyle(fontSize: 8),
      );

  pw.Widget textInfoClient(String label, String text) => pw.Padding(
        padding: pw.EdgeInsets.only(left: 2, top: 2, bottom: 2),
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              label.toUpperCase(),
              style: pw.TextStyle(color: secondaryColorDark, fontSize: 8),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              text.toUpperCase(),
              style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: primaryColor),
            ),
          ],
        ),
      );
}
