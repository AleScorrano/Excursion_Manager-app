import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:sacs_app/utils/email_sender.dart';
import 'package:whatsapp/whatsapp.dart';

class QrScanPage extends StatelessWidget {
  final WhatsApp whatsapp = WhatsApp();
  final emailsender = EmailSender();

  QrScanPage({super.key});
  static const PdfColor green = PdfColor.fromInt(0xff9ce5d0);
  static const primaryColor = PdfColor.fromInt(0xFF04588c);
  static const primaryColorlight = PdfColor.fromInt(0xFF4b84bc);
  static const secondaryColorDark = PdfColor.fromInt(0xFF007d8f);
  static const complementaryColor1 = PdfColor.fromInt(0xFFD99A4E);
  static const complementaryColor1Light = PdfColor.fromInt(0xFFF2D0A7);
  static const complementaryColor2 = PdfColor.fromInt(0xFFF2F2F0);
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        ElevatedButton(onPressed: createPDF, child: Text('Crea pdf')),
        SizedBox(height: 30),
        ElevatedButton(onPressed: saveFile, child: Text('salva file')),
        SizedBox(height: 30),
        ElevatedButton(onPressed: sendWhatsapp, child: Text('whatsapp')),
        SizedBox(height: 30),
        ElevatedButton(
            onPressed: () async => await emailsender.sendEmail(),
            child: Text('invia email')),
      ],
    ));
  }

  Future<Uint8List> createPDF() async {
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
                      'TOUR  PERSONALIZZATO',
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
                      textInfoClient('Nome e Cognome', 'Alessandro Scorrano'),
                      textInfoClient('n° Passeggeri / ridotti', '3 / 0'),
                    ],
                  ),
                  pw.TableRow(
                    decoration: pw.BoxDecoration(
                        color: complementaryColor2,
                        border: pw.Border.symmetric(
                            horizontal:
                                pw.BorderSide(color: primaryColorlight))),
                    children: [
                      textInfoClient('Data', '23 Agosto 2023'),
                      textInfoClient('fascia oraria', '16:00 - 19:00'),
                    ],
                  ),
                  pw.TableRow(
                    decoration: pw.BoxDecoration(
                        color: complementaryColor2,
                        border: pw.Border.symmetric(
                            horizontal:
                                pw.BorderSide(color: primaryColorlight))),
                    children: [
                      textInfoClient('Totale', '60'),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              qrCode(),
              pw.Expanded(child: pw.SizedBox()),
              infoFooter(),
            ],
          );
        },
      ),
    );

    //final file = File('example.pdf');
    //await file.writeAsBytes(await pdf.save());
    return pdf.save();
  }

  pw.Widget qrCode() => pw.Column(
        children: [
          pw.Text('AB127292KJJOJ'),
          pw.SizedBox(height: 10),
          pw.BarcodeWidget(
            data: 'Parnella Charlesbois',
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

  void saveFile() async {
    var pdf = await createPDF();
    String? result = await FilePicker.platform.saveFile(
        fileName:
            'gino.pdf'); // nome file fare nome + cognome + data gg/mm/aa + codice Checkin
    if (result != null) {
      final directory = File(result);
      await directory.writeAsBytes(pdf);
    }
  }

  void sendWhatsapp() {
    whatsapp.setup(
        accessToken:
            "EAAHi95Sqsr0BAFcqAjhqdaB6ORYsZCc3fePtcUDX3CQg2eo3ZAY6PXH3tZB6QbGNBSaPXKmT2WTODKFDZAbrE0FZBUB7wghebErkXEXXLmbZA7ZCi1uZCCsdsDgdSbM2sjByC5Lp2nTKZBTGjv1eYd7DsD9tl0CIZB5SX7xw0uM7MFGNpMM9mS1tvv1NNomLiwYxtFtMqRyixsLgZDZD",
        fromNumberId: 109092295411202);
    whatsapp.messagesTemplate(
      to: 393924672629,
      templateName: "Hey, Flutter, follow me on https://example.com",
    );
  }
}
