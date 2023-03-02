import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_button/group_button.dart';
import 'package:number_selector/number_selector.dart';
import 'package:sacs_app/blocs/excursion/bloc/excursion_bloc.dart';
import 'package:sacs_app/models/excursion_model.dart';
import 'package:sacs_app/pages/widgets/shake_widget.dart';
import 'package:sacs_app/theme.dart';
import 'package:sacs_app/widgets/time_picker.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:uuid/uuid.dart';

class NewExcursionDialog extends StatefulWidget {
  final List<Excursion> thisDayExcursions;
  final CalendarTapDetails dateDetails;
  final _shakeKey = GlobalKey<ShakeWidgetState>();
  late TimePickerWidget timePicker;
  late ExcursionTipe _tipeOfExcursion;
  late int _maxPassengers;
  bool _showErrorBar = false;
  NewExcursionDialog({
    super.key,
    required this.dateDetails,
    required this.thisDayExcursions,
  });

  @override
  State<NewExcursionDialog> createState() => _NewExcursionDialogState();
}

class _NewExcursionDialogState extends State<NewExcursionDialog> {
  @override
  void initState() {
    widget.timePicker = TimePickerWidget(
      startTime: widget.dateDetails.date!,
      endTime: widget.dateDetails.date!.add(
        Duration(hours: 3),
      ),
    );
    widget._tipeOfExcursion = ExcursionTipe.normal;
    widget._maxPassengers = 13;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExcursionBloc, ExcursionState>(
      builder: (context, state) {
        return ShakeWidget(
          shakeOffset: 10,
          key: widget._shakeKey,
          shakeDuration: Duration(milliseconds: 400),
          child: Dialog(
            backgroundColor: CustomTheme.complementaryColor2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              width: 200,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.all(12),
                    child: Center(
                      child: Text(
                        'Nuova Escursione',
                        style: TextStyle(
                          color: CustomTheme.primaryColorDark,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      color: CustomTheme.complementaryColor1,
                    ),
                  ),
                  widget.timePicker,
                  Divider(
                    color: CustomTheme.secondaryColorDark,
                    thickness: 2,
                    indent: 10,
                    endIndent: 10,
                  ),
                  _excursionTipeSelector(),
                  maxPassengersSelector(),
                  widget._showErrorBar ? errorBar() : SizedBox(),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                      bottom: 8,
                      left: 8,
                      right: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _confirmButton(context),
                        SizedBox(width: 8),
                        _exitButton(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _confirmButton(BuildContext context) => Expanded(
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            side: MaterialStatePropertyAll(
              BorderSide(
                width: 1,
                color: CustomTheme.complementaryColor1,
              ),
            ),
            backgroundColor:
                MaterialStatePropertyAll(CustomTheme.complementaryColor1),
          ),
          onPressed: _createExcursion,
          child: Text(
            'Conferma',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomTheme.complementaryColor2,
            ),
          ),
        ),
      );

  Widget _exitButton(BuildContext context) => Expanded(
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            side: MaterialStatePropertyAll(
              BorderSide(
                width: 1,
                color: CustomTheme.complementaryColor1,
              ),
            ),
            backgroundColor:
                MaterialStatePropertyAll(CustomTheme.complementaryColor2),
          ),
          onPressed: () => context.router.pop(),
          child: Text(
            'Esci',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CustomTheme.complementaryColor1,
            ),
          ),
        ),
      );

  Widget _excursionTipeSelector() => GroupButton(
        onSelected: (value, index, isSelected) {
          if (value == 'Normale')
            setState(() {
              widget._tipeOfExcursion = ExcursionTipe.normal;
              widget._maxPassengers = 13;
            });
          else if (value == 'Tramonto')
            setState(() {
              widget._tipeOfExcursion = ExcursionTipe.sunset;
              widget._maxPassengers = 13;
            });
          else if (value == 'Personalizzata')
            setState(() {
              widget._tipeOfExcursion = ExcursionTipe.personalized;
              widget._maxPassengers = 15;
            });
        },
        options: GroupButtonOptions(
          unselectedTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          selectedTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          unselectedColor: CustomTheme.primaryColorlight.withOpacity(0.9),
          selectedColor: CustomTheme.primaryColorDark,
          groupingType: GroupingType.wrap,
          borderRadius: BorderRadius.circular(12),
        ),
        isRadio: true,
        buttons: excursionTipe,
      );

  List<String> excursionTipe = ['Normale', 'Tramonto', 'Personalizzata'];

  Widget maxPassengersSelector() => Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Max passeggeri',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: CustomTheme.primaryColorDark),
            ),
            NumberSelector.plain(
              current: widget._maxPassengers,
              onUpdate: (number) => widget._maxPassengers = number,
            )
          ],
        ),
      );

  Widget errorBar() => Visibility(
        visible: widget._showErrorBar,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error,
                color: Colors.red.shade800,
              ),
              SizedBox(width: 10),
              Text(
                'Orari Sovrapposti',
                style: TextStyle(
                  color: Colors.red.shade800,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.shade800, width: 2),
          ),
        ),
      );

  void _createExcursion() async {
    Excursion excursion = Excursion(
      excursionCode: Uuid().v4(),
      color: Excursion.ColorByTypeOfExcursions(widget._tipeOfExcursion),
      excursionTipe: widget._tipeOfExcursion,
      excursionStart: widget.timePicker.startTime,
      excursionEnd: widget.timePicker.endTime,
      reservations: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      maxPassengers: widget._maxPassengers,
      totalPassengers: 0,
    );
    bool isOverLapping = controlOverlapping();
    if (isOverLapping == false) {
      BlocProvider.of<ExcursionBloc>(context).addExcursion(excursion);
      context.router.pop();
    } else {
      setState(() {
        widget._showErrorBar = true;
      });
      widget._shakeKey.currentState?.shake();
    }
  }

  bool controlOverlapping() {
    List<bool> isOverlapList = widget.thisDayExcursions.map((excursion) {
      if (!widget.timePicker.endTime.isBefore(excursion.startTime) &&
          !excursion.endTime.isBefore(widget.timePicker.startTime)) {
        return true;
      } else {
        return false;
      }
    }).toList();

    if (isOverlapList.contains(true)) {
      return true;
    } else {
      return false;
    }
  }

  Map<String, DateTime?>? getDisbledRange() {
    if (widget.thisDayExcursions.isEmpty) {
      return null;
    }
    List<Excursion> afterExcursion = [];

    widget.thisDayExcursions.forEach((excursion) {
      if (excursion.startTime.isAfter(widget.dateDetails.date!)) {
        afterExcursion.add(excursion);
      }
    });
    print(afterExcursion);

    List<Excursion> beforeExcursion = [];
    widget.thisDayExcursions.forEach((excursion) {
      if (excursion.startTime.isBefore(widget.dateDetails.date!)) {
        return beforeExcursion.add(excursion);
      }
    });

    print(beforeExcursion);
    DateTime? startRange = null;
    if (beforeExcursion.isNotEmpty) {
      beforeExcursion.forEach((excursion) {
        startRange = excursion.endTime;
        if (startRange!.isAfter(excursion.endTime)) {
          startRange = excursion.endTime;
        }
      });
    }
    DateTime? endRange = null;
    if (afterExcursion.isNotEmpty) {
      afterExcursion.forEach((excursion) {
        endRange = excursion.startTime;
        if (endRange!.isBefore(excursion.startTime)) {
          endRange = excursion.startTime;
        }
      });
    }
    Map<String, DateTime?> timeRange = {
      'startRange': startRange,
      'endRange': endRange,
    };
    return timeRange;
  }
}
