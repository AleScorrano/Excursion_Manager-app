import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:sacs_app/blocs/calendar/bloc/calendar_bloc.dart';
import 'package:sacs_app/blocs/initial_data/bloc/initial_data_bloc.dart';
import 'package:sacs_app/pages/widgets/calendar_widget.dart';
import 'package:sacs_app/theme.dart';
import '../models/excursion_model.dart';

class CalendarPage extends StatelessWidget {
  CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InitialDataBloc, DownloadDataState>(
      builder: (context, excursionState) {
        if (excursionState is OnDownloadDataState) {
          return _loadingIndicator();
        }
        if (excursionState is ErrorDownloadDataState) {
          return _errorWidget();
        }
        if (excursionState is DataFetchedState) {
          return BlocBuilder<CalendarBloc, CalendarState>(
            builder: (context, calendarState) =>
                BlocProvider.of<CalendarBloc>(context).calendarView != ''
                    ? StreamBuilder<List<Excursion>>(
                        stream: excursionState.excursions,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Stack(children: [
                              _selectionExcursionModeBar(),
                              CalendarWidget(
                                snapshot: snapshot,
                                calendarState: calendarState,
                              ),
                            ]);
                          } else {
                            return Center(
                              child: _loadingIndicator(),
                            );
                          }
                        },
                      )
                    : _loadingIndicator(),
          );
        } else {
          return _loadingIndicator();
        }
      },
    );
  }

  Widget _loadingIndicator() => Center(
        child: SizedBox(
          height: 50,
          width: 50,
          child: LoadingIndicator(
            indicatorType: Indicator.lineSpinFadeLoader,
            colors: [
              CustomTheme.primaryColor,
              CustomTheme.seconadaryColorLight,
            ],
          ),
        ),
      );

  Widget _errorWidget() =>
      Center(child: Text('Errore durante il caricamento...'));

  Widget _selectionExcursionModeBar() => Builder(builder: (context) {
        if (BlocProvider.of<CalendarBloc>(context).state
            is CalendarViewModeState) {
          return SizedBox();
        } else {
          return Positioned(
            right: 8,
            left: 160,
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: SizedBox()),
                    LoadingIndicator(
                      indicatorType: Indicator.ballBeat,
                      colors: [Colors.white],
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Seleziona un escursione',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10),
                    LoadingIndicator(
                      indicatorType: Indicator.ballBeat,
                      colors: [Colors.white],
                    ),
                    Expanded(child: SizedBox()),
                    IconButton(
                      alignment: Alignment.center,
                      onPressed: () {},
                      icon: Icon(
                        FontAwesomeIcons.close,
                        color: Colors.green.shade900,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      });
}
