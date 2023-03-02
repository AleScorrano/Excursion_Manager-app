import 'package:flutter/material.dart';

class NewReservationDialog extends StatelessWidget {
  final Widget child;
  const NewReservationDialog({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          width: 400,
          height: 800,
          child: child),
    );
  }
}
