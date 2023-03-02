import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sacs_app/blocs/sliding_panel_bloc/bloc/sliding_panel_bloc.dart';
import 'package:sacs_app/theme.dart';

class SlidingPanel extends StatelessWidget {
  final Widget? child;
  const SlidingPanel({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SlidingPanelBloc, SlidingPanelBlocState>(
      builder: (context, state) {
        if (state is SlidingPanelMinimizedState) {
          return minimizedWidget(context);
        } else if (state is SLidingPanelOpenState) {
          return panelWidget(context, state);
        }
        return Center();
      },
    );
  }

  Widget panelWidget(BuildContext context, SlidingPanelBlocState state) =>
      Positioned(
        right: 0,
        top: 0,
        bottom: 4,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 450),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            shadowColor: CustomTheme.primaryColorlight,
            elevation: 20,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8)),
              ),
              width: MediaQuery.of(context).size.width / 3.5,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: headerBar(context),
                body: slidingPanelChild(),
              ),
            ),
          ),
        ),
      );

  PreferredSizeWidget headerBar(BuildContext context) => AppBar(
        backgroundColor: CustomTheme.secondaryColorDark,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            /* gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              colors: [
                CustomTheme.seconadaryColorLight,
                CustomTheme.secondaryColorDark
              ],
            ),*/
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        title: Text(
          '',
          style: TextStyle(
            color: CustomTheme.complementaryColor2,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () =>
                BlocProvider.of<SlidingPanelBloc>(context).minimizePanel(),
            icon: Icon(
              FontAwesomeIcons.minus,
              size: 18,
              color: CustomTheme.complementaryColor1,
            ),
          ),
          IconButton(
            onPressed: () =>
                BlocProvider.of<SlidingPanelBloc>(context).closePanel(),
            icon: Icon(
              FontAwesomeIcons.close,
              size: 18,
              color: CustomTheme.complementaryColor1,
            ),
          ),
        ],
      );

  Widget slidingPanelChild() => Container(
        child: child ?? SizedBox(),
      );

  Widget minimizedWidget(BuildContext context) => Positioned(
        bottom: 6,
        right: 6,
        child: InkWell(
          onTap:
              () {}, //BlocProvider.of<SlidingPanelBloc>(context).openPanel(),
          child: Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: CustomTheme.primaryColorlight,
              shape: BoxShape.rectangle,
            ),
            child: Row(
              children: [
                Text(
                  'Prenotazione',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: CustomTheme.complementaryColor2,
                  ),
                ),
                Icon(Icons.arrow_drop_up),
              ],
            ),
          ),
        ),
      );
}
