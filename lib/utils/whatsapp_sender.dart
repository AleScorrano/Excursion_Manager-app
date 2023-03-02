import 'package:sacs_app/error/add_reservation_error.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class WhatsappSender {
  Future<bool> openWhatsappDesktop(String? phoneNumber) async {
    if (phoneNumber == null) {
      throw AddReservationError('numero non presente');
    }
    final link = WhatsAppUnilink(
      phoneNumber: phoneNumber,
      text: "Hey! I'm inquiring about the apartment listing",
    );
    return await launchUrl(
      link.asUri(),
    );
  }
}
