import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sacs_app/models/excursion_model.dart';
import 'package:sacs_app/models/reservation_model.dart';
import 'package:sacs_app/pages/widgets/dialog/reservation_dialog.dart';
import 'package:sacs_app/theme.dart';
import 'package:sacs_app/widgets/reservation_form.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import '../cubits/auth/cubit/auth_cubit.dart';

class ReservationCard extends StatelessWidget {
  final Excursion excursion;
  final Reservation reservation;
  const ReservationCard({
    super.key,
    required this.reservation,
    required this.excursion,
  });

  @override
  Widget build(BuildContext context) {
    if (reservation.clientName == 'mock') {
      return SizedBox();
    }
    return ExpandableNotifier(
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 3,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            cardCollapsed(context),
            ExpandablePanel(
              header: header(context),
              theme: ExpandableThemeData(
                  useInkWell: false,
                  collapseIcon: Icons.arrow_drop_up,
                  expandIcon: Icons.arrow_drop_down,
                  iconColor: CustomTheme.complementaryColor1,
                  fadeCurve: Curves.bounceIn,
                  sizeCurve: Curves.easeInCirc,
                  iconPadding: EdgeInsets.all(0)),
              collapsed: SizedBox(),
              expanded: expanded(context),
              builder: (context, collapsed, expanded) =>
                  Expandable(collapsed: collapsed, expanded: expanded),
            ),
          ],
        ),
      ),
    );
  }

  Widget header(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 2.0),
        child: Text(
          '', //'@${Provider.of<AuthCubit>(context).firebaseAuth.currentUser!.displayName ?? '-'}',
          style: TextStyle(
            color: CustomTheme.primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      );

  Widget expanded(BuildContext context) => Container(
        padding: EdgeInsets.only(
          left: 9,
          bottom: 8,
        ),
        width: double.maxFinite,
        color: Colors.white,
        child: Column(
          children: [
            Divider(
              indent: 8,
              endIndent: 8,
              color: CustomTheme.complementaryColor1,
            ),
            textInfoExpanded(context,
                label: 'aggiunta',
                value:
                    '${DateFormat('dd MMM yyy').format(reservation.created_at)}'),
            textInfoExpanded(context,
                label: 'aggiornata',
                value:
                    '${DateFormat('dd MMM yyy').format(reservation.updated_at)}'),
            textInfoExpanded(context,
                label: 'totale',
                value:
                    '€ ${reservation.pricePerPassengers * reservation.numberOfPassengers}'),
            textInfoExpanded(context, label: 'metodo', value: 'Gabbiotto'),
            textInfoExpanded(context, label: 'luogo', value: 'pescoluse'),
            textInfoExpanded(context, label: 'codice', value: 'ab123z568'),
            textInfoExpanded(context,
                label: 'utente',
                value:
                    '${Provider.of<AuthCubit>(context).firebaseAuth.currentUser!.displayName ?? '-'}'),
            reservation.notes != null
                ? noteWidget(reservation.notes!)
                : SizedBox(),
            Container(
              margin: EdgeInsets.only(right: 4.0, top: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade200.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  viewTicketButton(),
                  sendWhatsappButton(),
                  sendEmailButton(),
                  viewDocumentButton(),
                  Expanded(child: SizedBox()),
                  editButton(context),
                  removeButton(),
                ],
              ),
            ),
          ],
        ),
      );
  Widget viewTicketButton() => IconButton(
        onPressed: () => print(reservation.checkInCode),
        icon: Icon(
          FontAwesomeIcons.ticket,
          color: Colors.purpleAccent.shade400,
        ),
      );

  Widget sendWhatsappButton() => Container(
        child: IconButton(
            onPressed: () async {
              final link = WhatsAppUnilink(
                phoneNumber: '393924672629',
                text: "Hey! I'm inquiring about the apartment listing",
              );
              await launchUrl(link.asUri());
            },
            icon: Icon(
              FontAwesomeIcons.whatsapp,
              color: Colors.green,
            )),
      );

  Widget scanQRButton() => IconButton(
      onPressed: () {},
      icon: Icon(
        FontAwesomeIcons.qrcode,
        color: Colors.blueGrey,
      ));

  Widget sendEmailButton() => IconButton(
      onPressed: () {},
      icon: Icon(
        FontAwesomeIcons.envelope,
        color: Colors.redAccent.shade700,
      ));

  Widget viewDocumentButton() => IconButton(
      onPressed: () {},
      icon: Icon(
        Icons.file_open,
        color: Colors.orangeAccent.shade700,
      ));

  Widget editButton(BuildContext context) => IconButton(
        onPressed: () => showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => NewReservationDialog(
            child: ReservationForm(
              mode: ReservationFormMode.update,
              excursion: excursion,
              reservation: reservation,
            ),
          ),
        ),
        icon: Icon(
          FontAwesomeIcons.edit,
          color: Colors.amber.shade700,
          size: 20,
        ),
      );

  Widget removeButton() => IconButton(
      onPressed: () {},
      icon: Icon(
        FontAwesomeIcons.trash,
        color: Colors.red.shade600,
        size: 20,
      ));

  Widget textInfoExpanded(BuildContext context,
          {required String label, required String value}) =>
      Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: CustomTheme.primaryColor.withOpacity(0.7),
            ),
          ),
        ],
      );

  Widget cardCollapsed(BuildContext context) => Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: Colors.white,
        child: SizedBox(
          height: 80,
          width: double.maxFinite,
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: excursion.color,
                  borderRadius: BorderRadius.circular(8),
                ),
                width: 3,
                height: 70,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${reservation.clientName} ${reservation.clientSurname}',
                      style: TextStyle(
                        color: CustomTheme.primaryColorDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      reservation.email ?? '-',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      reservation.phoneNumber ?? '-',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      '€ ${reservation.pricePerPassengers.toString()}',
                      style: TextStyle(
                        color: Colors.green.shade600,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: SizedBox()),
              Padding(
                padding: const EdgeInsets.only(
                  top: 4,
                  right: 12,
                  bottom: 4,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      scanQRButton(),
                      Expanded(child: SizedBox()),
                      CircleAvatar(
                        backgroundColor: CustomTheme.secondaryColorDark,
                        //CustomTheme.complementaryColor1.withOpacity(0.2),
                        foregroundColor: Colors.white,
                        radius: 14,
                        child: Text(
                          reservation.numberOfPassengers.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );

  Widget noteWidget(String notes) => Padding(
        padding: const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 8.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 8, top: 4, bottom: 4),
              decoration: BoxDecoration(
                  color: Colors.yellow.shade100.withOpacity(0.7),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8))),
              height: 24,
              width: double.maxFinite,
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.noteSticky,
                    size: 14,
                    color: Colors.amber.shade700,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'NOTE',
                    style: TextStyle(
                        color: Colors.amber.shade700,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              width: double.maxFinite,
              padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
              ),
              height: 60,
              decoration: BoxDecoration(
                color: Colors.yellow.shade100.withOpacity(0.7),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8)),
              ),
              child: SingleChildScrollView(
                child: Text(
                  notes,
                  style: TextStyle(
                    color: CustomTheme.primaryColor.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget mockCard() => Card(
        elevation: 0,
        color: Colors.grey.shade400.withOpacity(0.4),
        child: SizedBox(
          width: double.maxFinite,
          height: 80,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                Icon(
                  FontAwesomeIcons.warning,
                  color: Colors.red,
                ),
                Text(
                  'Errore durante il download',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade600),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('Elimina'),
                ),
              ],
            ),
          ),
        ),
      );
}




/* 
Provider.of<AuthCubit>(context)
                              .firebaseAuth
                              .currentUser!
                              .displayName ??
                          '-',

*/