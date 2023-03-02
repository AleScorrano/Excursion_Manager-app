import 'package:flutter/material.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sacs_app/theme.dart';

class TimePickerWidget extends StatefulWidget {
  DateTime startTime;
  DateTime endTime;

  TimePickerWidget({
    Key? key,
    required this.startTime,
    required this.endTime,
  }) : super(key: key);

  @override
  _TimePickerWidgetState createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  ClockTimeFormat _clockTimeFormat = ClockTimeFormat.TWENTYFOURHOURS;
  ClockIncrementTimeFormat _clockIncrementTimeFormat =
      ClockIncrementTimeFormat.FIVEMIN;

  late PickedTime _startTime;
  late PickedTime _endTime;
  late DateTime _finalDuration;

  PickedTime _excursionDuration = PickedTime(h: 0, m: 0);

  @override
  void initState() {
    super.initState();

    _startTime =
        PickedTime(h: widget.startTime.hour, m: widget.startTime.minute);
    _endTime = PickedTime(h: widget.endTime.hour, m: widget.endTime.minute);
    _excursionDuration = formatIntervalTime(
      init: _startTime,
      end: _endTime,
      clockTimeFormat: _clockTimeFormat,
      clockIncrementTimeFormat: _clockIncrementTimeFormat,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: TimePicker(
                initTime: _startTime,
                endTime: _endTime,
                height: 200.0,
                width: 200.0,
                onSelectionChange: _updateDate,
                onSelectionEnd: (start, end, isDisableRange) => print(
                    'onSelectionEnd => init : ${start.h}:${start.m}, end : ${end.h}:${end.m}, isDisableRange: $isDisableRange'),
                primarySectors: _clockTimeFormat.value,
                secondarySectors: _clockTimeFormat.value * 2,
                decoration: TimePickerDecoration(
                  baseColor: CustomTheme.primaryColorDark,
                  pickerBaseCirclePadding: 6.0,
                  sweepDecoration: TimePickerSweepDecoration(
                      pickerStrokeWidth: 22.0,
                      pickerColor: Colors.blue,
                      showConnector: true,
                      connectorStrokeWidth: 2,
                      connectorColor: CustomTheme.primaryColorDark),
                  initHandlerDecoration: TimePickerHandlerDecoration(
                    color: CustomTheme.primaryColorDark,
                    shape: BoxShape.circle,
                    radius: 8.0,
                    icon: Icon(
                      Icons.play_arrow_outlined,
                      size: 14.0,
                      color: Colors.white,
                    ),
                  ),
                  endHandlerDecoration: TimePickerHandlerDecoration(
                    color: CustomTheme.primaryColorDark,
                    shape: BoxShape.circle,
                    radius: 8.0,
                    icon: Icon(
                      Icons.stop,
                      size: 14.0,
                      color: Colors.white,
                    ),
                  ),
                  primarySectorsDecoration: TimePickerSectorDecoration(
                    color: CustomTheme.primaryColorDark,
                    width: 2.0,
                    size: 4.0,
                    radiusPadding: 18.0,
                  ),
                  secondarySectorsDecoration: TimePickerSectorDecoration(
                    color: CustomTheme.complementaryColor1,
                    width: 2.0,
                    size: 2.0,
                    radiusPadding: 18.0,
                  ),
                  clockNumberDecoration: TimePickerClockNumberDecoration(
                    defaultTextColor: CustomTheme.primaryColorDark,
                    defaultFontSize: 12.0,
                    scaleFactor: 1.7,
                    showNumberIndicators: true,
                    clockTimeFormat: _clockTimeFormat,
                    clockIncrementTimeFormat: _clockIncrementTimeFormat,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${intl.DateFormat.yMMMMEEEEd().format(widget.startTime)}',
                    style: TextStyle(
                      color: CustomTheme.primaryColorDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        text: 'Dalle: ',
                        style: TextStyle(
                          color: CustomTheme.primaryColorDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                        children: [
                          TextSpan(
                            text:
                                '${intl.NumberFormat('00').format(widget.startTime.hour)}:${intl.NumberFormat('00').format(widget.startTime.minute)}',
                            style: TextStyle(color: Colors.green.shade700),
                          ),
                          TextSpan(text: '  '),
                          TextSpan(text: 'Alle: '),
                          TextSpan(
                            text:
                                '${intl.NumberFormat('00').format(widget.endTime.hour)}:${intl.NumberFormat('00').format(widget.endTime.minute)}',
                            style: TextStyle(color: Colors.redAccent.shade700),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '${intl.NumberFormat('00').format(_excursionDuration.h)} Ore  ${intl.NumberFormat('00').format(_excursionDuration.m)} Minuti',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateDate(PickedTime init, PickedTime end, bool? isDisableRange) {
    _startTime = init;
    _endTime = end;
    _excursionDuration = formatIntervalTime(
      init: _startTime,
      end: _endTime,
      clockTimeFormat: _clockTimeFormat,
      clockIncrementTimeFormat: _clockIncrementTimeFormat,
    );
    setState(() {
      widget.startTime =
          widget.startTime.copyWith(hour: init.h, minute: init.m);
      widget.endTime = widget.endTime.copyWith(hour: end.h, minute: end.m);
    });
  }

  DateTime get startTime => DateTime(startTime.year, startTime.month,
      startTime.day, startTime.hour, startTime.minute);

  DateTime get endTime => DateTime(
      endTime.year, endTime.month, endTime.day, endTime.hour, endTime.minute);
}
