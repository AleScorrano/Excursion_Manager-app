import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class NewExcursionPage extends StatefulWidget {
  NewExcursionPage({super.key});

  @override
  State<NewExcursionPage> createState() => _NewExcursionPageState();
}

class _NewExcursionPageState extends State<NewExcursionPage> {
  var numberAndText =
      WhatsAppUnilink(phoneNumber: '393924672629', text: 'Messaggio prova');
  var phoneNumber = WhatsAppUnilink(phoneNumber: '393924672629');
  var text = WhatsAppUnilink(text: 'Messaggio Prova');
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Text('new Excursion Page'),
          ),
          ElevatedButton(
            onPressed: () async {
              final link = WhatsAppUnilink(
                phoneNumber: '393924672629',
                text: "Hey! I'm inquiring about the apartment listing",
              );
              // Convert the WhatsAppUnilink instance to a Uri.
              // The "launch" method is part of "url_launcher".
              await launchUrl(link.asUri());
            },
            child: Text('Invia'),
          ),
        ],
      ),
    );
  }
}


//whatsapp unilink dart
/* 
 final html =
                '''<html><head><title>whatsapp unilink example</title></head><body><a href="$numberAndText">With phone number and text.</a><br><a href="$phoneNumber">With phone number.</a><br><a href="$text">With text</a></body></html>''';
            print('Starting server...');
            final server =
                await HttpServer.bind(InternetAddress.loopbackIPv4, 3000);
            print('Server available on http://localhost:3000');

            await for (final request in server) {
              request.response
                ..statusCode = HttpStatus.ok
                ..headers.contentType = ContentType.html
                ..write(html);
              await request.response.close();
            }
*/


//whatsapp unilink diretto

/*
 final link = WhatsAppUnilink(
              phoneNumber: '393924672629',
              text: "Hey! I'm inquiring about the apartment listing",
            );
            // Convert the WhatsAppUnilink instance to a Uri.
            // The "launch" method is part of "url_launcher".
            await launchUrl(link.asUri(
 */






