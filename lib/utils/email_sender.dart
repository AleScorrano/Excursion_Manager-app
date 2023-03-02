import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailSender {
  final smtpServer = gmail('alescorrano94@gmail.com', 'Hogrippato030894');

  sendEmail() async {
    final message = Message()
      ..from = Address('alescorrano94@gmail.com', 'Alessandro')
      ..recipients.add('alescorrano94@gmail.com')
      ..subject = 'Email di prova'
      ..text = 'Messaggio di prova';

    var connnection = PersistentConnection(smtpServer);

    await connnection.send(message);

    await connnection.close();
  }
}
