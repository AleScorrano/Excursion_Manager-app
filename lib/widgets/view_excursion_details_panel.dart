import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sacs_app/models/excursion_model.dart';
import 'package:sacs_app/models/reservation_model.dart';
import 'package:sacs_app/pages/widgets/dialog/reservation_dialog.dart';
import 'package:sacs_app/theme.dart';
import 'package:sacs_app/widgets/reservation_card.dart';
import 'package:sacs_app/widgets/reservation_form.dart';

class ExcursionDetailsPanel extends StatelessWidget {
  final Stream<Excursion> excursion;
  final Stream<List<Reservation>> reservations;

  const ExcursionDetailsPanel({
    super.key,
    required this.excursion,
    required this.reservations,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Excursion>(
        stream: excursion,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: CustomTheme.complementaryColor2,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
            child: Column(
              children: [
                header(snapshot.data!),
                labelReservationDivider(reservations),
                excursionList(context, snapshot.data!),
                newExcursionButton(context, snapshot.data!),
                SizedBox(height: 10),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      editExcursionButton(),
                      SizedBox(
                        width: 10,
                      ),
                      deleteExcursionButton(),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  Widget header(Excursion excursion) => Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: CustomTheme.seconadaryColorLight.withOpacity(0.2),
            borderRadius: BorderRadiusDirectional.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textDetailsWidget(
                    detail:
                        '${DateFormat('Hm').format(excursion.startTime)} - ${DateFormat('Hm').format(excursion.endTime)}'),
                textDetailsWidget(
                    detail: excursion
                        .getExcursionTipeToString(excursion.excursionTipe)),
                textDetailsWidget(
                  detail: DateFormat('dd MMMM yyy').format(excursion.startTime),
                ),
              ],
            ),
            Container(
              width: 1,
              height: 50,
              color: CustomTheme.secondaryColorDark,
            ),
            Column(
              children: [
                Text(
                  'Passeggeri',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: CustomTheme.secondaryColorDark),
                ),
                SizedBox(
                  height: 8,
                ),
                StreamBuilder<List<Reservation>>(
                    stream: reservations,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return SizedBox();
                      return Text(
                        '${snapshot.data!.fold(0, (previousValue, element) => previousValue + element.numberOfPassengers)}/${excursion.maxPassengers}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color:
                                CustomTheme.primaryColorDark.withOpacity(0.9)),
                      );
                    }),
              ],
            ),
          ],
        ),
      );

  Widget excursionList(BuildContext context, Excursion excursion) =>
      StreamBuilder<List<Reservation>>(
          stream: reservations,
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            if (snapshot.data!.length == 0) return _noReservationsWidget();
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  height: MediaQuery.of(context).size.height - 340,
                  child: ExpandableTheme(
                    data: ExpandableThemeData(
                      iconColor: Colors.red,
                      useInkWell: true,
                      hasIcon: true,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) => ReservationCard(
                          excursion: excursion,
                          reservation: snapshot.data![index]),
                      itemCount: snapshot.data!.length,
                    ),
                  ),
                ),
              ],
            );
          });

  Widget editExcursionButton() => Expanded(
        child: GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.amber.shade800,
            ),
            height: 38,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.edit,
                      size: 18,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        'Modifica',
                        style: TextStyle(
                          letterSpacing: 1,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget deleteExcursionButton() => Expanded(
        child: GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.red.shade800,
            ),
            height: 38,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.delete,
                      size: 18,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        'Elimina',
                        style: TextStyle(
                          letterSpacing: 1,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  Widget newExcursionButton(BuildContext context, Excursion excursion) =>
      GestureDetector(
        onTap: () => showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => NewReservationDialog(
            child: ReservationForm(
              mode: ReservationFormMode.create,
              excursion: excursion,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: CustomTheme.complementaryColor1,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  FontAwesomeIcons.add,
                  color: CustomTheme.complementaryColor1,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Prenotazione',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: CustomTheme.complementaryColor1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget labelReservationDivider(Stream<List<Reservation>> reservations) =>
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: StreamBuilder<List<Reservation>>(
                  stream: reservations,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return SizedBox();
                    if (snapshot.data!.length == 0) return SizedBox();
                    return Text(
                      snapshot.hasData
                          ? 'Prenotazioni   ${snapshot.data!.length}'
                          : 'Prenotazioni   ${0}',
                      style: TextStyle(
                        color: CustomTheme.primaryColorDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    );
                  }),
            ),
            Divider(
              endIndent: 8,
              thickness: 1,
              color: CustomTheme.primaryColorDark,
            ),
          ],
        ),
      );

  Widget textDetailsWidget({required String detail}) => Padding(
        padding: const EdgeInsets.only(top: 2.0),
        child: Text(
          detail,
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: CustomTheme.primaryColor),
        ),
      );

  Widget _noReservationsWidget() => Expanded(
        child: Center(
          child: Text(
            'Nessuna prenotazione',
            style: TextStyle(color: Colors.grey, fontSize: 18),
          ),
        ),
      );
}
