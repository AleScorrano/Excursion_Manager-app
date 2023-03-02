import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_loadingindicator/flutter_loadingindicator.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sacs_app/blocs/media_sender/bloc/media_sender_bloc.dart';
import 'package:sacs_app/blocs/reservations/bloc/reservations_bloc.dart';
import 'package:sacs_app/models/excursion_model.dart';
import 'package:sacs_app/models/reservation_model.dart';
import 'package:sacs_app/theme.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:uuid/uuid.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../pages/widgets/my_text_field.dart';

//classe che gestisce il form per la creazione e la modifica di una nuova prenotazione (Reservation),e gestisce tutti gli stati del processo.
class ReservationForm extends StatefulWidget {
  final ReservationFormMode mode; // per la modalita di creazione o modifica
  final Reservation? reservation; // opzionale da passare in caso di modifica
  final Excursion excursion;
  ReservationForm({
    super.key,
    required this.excursion,
    required this.mode,
    this.reservation,
  });

  @override
  State<ReservationForm> createState() => _ReservationFormState();
}

class _ReservationFormState extends State<ReservationForm> {
  final _formKey = GlobalKey<FormState>(); //globalKey per
  final emailRegex = // regex per validare l'email
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  final phoneRegex =
      r'(^(?:[+0]9)?[0-9]{10,12}$)'; // regex per controllare il numero di telefono
  final numberRegex = r'[0-9]'; //regex per campo dei passeggeri
  bool _isWhatsappCkecked = false; // per lo switch dell'invio whatsapp
  bool _isEmailChecked = false; // per lo switch dell'invio email
  bool _formValid = false; // per validare il form
  late bool _enabled; //per didsabilitare i campi quando necessario

  final scrollController = ScrollController();
  //definisco tutti i controller per i textField
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _emailController;
  late TextEditingController _priceController;
  late TextEditingController _passengersController;
  late TextEditingController _notesController;
  //definisco i focusNode per i textField
  final _nameFocusNode = FocusNode();
  final _surnameFocusNode = FocusNode();
  final _phoneNumberFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _pessangersFocusNode = FocusNode();
  final _notesFocusNode = FocusNode();

  @override
  void initState() {
    // inizializzo tutti i texteditingcontroller,e gli inizializzo il testo solo se è stata passata una Reservation,
    //se è stata passata il form serve per la modifica.
    _enabled = true;
    _nameController = TextEditingController(
        text:
            widget.reservation != null ? widget.reservation!.clientName : null);
    _surnameController = TextEditingController(
        text: widget.reservation != null
            ? widget.reservation!.clientSurname
            : null);
    _phoneNumberController = TextEditingController(
        text: widget.reservation != null
            ? widget.reservation!.phoneNumber
            : null);
    _emailController = TextEditingController(
        text: widget.reservation != null ? widget.reservation!.email : null);
    _priceController = TextEditingController(
        text: widget.excursion.pricePerPassengersFromType.toString());
    _passengersController = TextEditingController(
        text: widget.reservation != null
            ? widget.reservation!.numberOfPassengers.toString()
            : null);
    _notesController = TextEditingController(
        text: widget.reservation != null ? widget.reservation!.notes : null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: EdgeInsets.only(top: 24, right: 24, left: 24, bottom: 10),
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height,
        //ascolto gli stati di MediasenderBloc tramite un blocConsumer
        child: BlocConsumer<MediaSenderBloc, MediaSenderState>(
          listener: (context, state) {
            stateListener(
                state); //per visualizzare vari componenti nell'ui in base allo stato
            saveListener(state); // per salvare o modificare la Reservation
            disableField(
                state); // pr disabilitare gli input e il bottone di Crea/Modifica
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: () {
                // utilizzo la globalKey per validare il form
                final isValid = _formKey.currentState?.validate() ?? false;
                setState(() {
                  _formValid = isValid;
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  nameField(),
                  surnameField(),
                  phoneNumberField(),
                  emailField(),
                  Row(
                    children: [
                      priceField(),
                      SizedBox(width: 12),
                      passengersField(),
                    ],
                  ),
                  switchsWidget(),
                  notesWidget(),

                  Expanded(child: SizedBox()),
                  state is MediaSenderInitial
                      ? Expanded(child: SizedBox(), flex: 3)
                      : stateListener(state),
                  Expanded(child: SizedBox()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.mode ==
                              ReservationFormMode
                                  .update //visualizzo il bottone di update o Confirm in base al ReservationFormMode
                          ? updateButton()
                          : confirmButton(),
                      exitButton(enabled: _enabled),
                    ],
                  ),
                  //SizedBox(height: 10),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

//*--------------------------------------------------------------------------------
  Widget nameField() => MyTextField(
        enabled: _enabled,
        errorText: 'Nome obbligatorio',
        focusNode: _nameFocusNode,
        controller: _nameController,
        hintText: 'Nome',
        icon: FontAwesomeIcons.user,
        onFieldSubmitted: (_) {
          _surnameFocusNode.requestFocus();
        },
        validator: (value) {
          if (value == null || value.length <= 1) {
            return 'Campo Obbligtorio';
          }
        },
      );
//*--------------------------------------------------------------------------------
  Widget surnameField() => MyTextField(
        enabled: _enabled,
        errorText: 'Campo obbligatorio',
        focusNode: _surnameFocusNode,
        controller: _surnameController,
        hintText: 'Cognome',
        icon: FontAwesomeIcons.user,
        onFieldSubmitted: (_) {
          _phoneNumberFocusNode.requestFocus();
        },
        validator: (value) {
          if (value == null || value.length <= 1) {
            return 'Campo Obbligtorio';
          }
        },
      );
  //*--------------------------------------------------------------------------------
  Widget phoneNumberField() => MyTextField(
        enabled: _enabled,
        inputType: TextInputType.phone,
        errorText: 'Campo Obbligatorio',
        focusNode: _phoneNumberFocusNode,
        controller: _phoneNumberController,
        icon: FontAwesomeIcons.phone,
        onFieldSubmitted: (_) {
          _emailFocusNode.requestFocus();
        },
        validator: (value) {
          if (value!.length >= 1 && !RegExp(phoneRegex).hasMatch(value)) {
            _isWhatsappCkecked = false;
            return 'Numero non valido';
          }
        },
        hintText: 'Cellulare (facoltativo)',
      );
//*--------------------------------------------------------------------------------
  Widget emailField() => MyTextField(
      enabled: _enabled,
      validator: (value) {
        if (value!.length >= 1 && !RegExp(emailRegex).hasMatch(value)) {
          _isEmailChecked = false;
          return 'Email non valida';
        }
      },
      onFieldSubmitted: (_) {
        _priceFocusNode.requestFocus();
      },
      inputType: TextInputType.emailAddress,
      errorText: 'Email non valida',
      focusNode: _emailFocusNode,
      controller: _emailController,
      icon: FontAwesomeIcons.solidEnvelope,
      hintText: 'Email (facoltativo)');
//*--------------------------------------------------------------------------------
  Widget priceField() => Flexible(
        child: MyTextField(
          enabled: _enabled,
          inputColor: Colors.green.shade800,
          inputType: TextInputType.number,
          errorText: 'Campo non valido',
          focusNode: _priceFocusNode,
          controller: _priceController,
          icon: FontAwesomeIcons.euroSign,
          hintText: 'Prezzo',
          onFieldSubmitted: (_) {
            _pessangersFocusNode.requestFocus();
          },
          validator: (value) {
            if (!RegExp(numberRegex).hasMatch(value ?? '')) {
              return 'Solo numeri';
            }
          },
        ),
      );
//*--------------------------------------------------------------------------------
  Widget passengersField() => Flexible(
        child: MyTextField(
          enabled: _enabled,
          inputType: TextInputType.number,
          errorText: 'Campo non valido',
          focusNode: _pessangersFocusNode,
          controller: _passengersController,
          icon: FontAwesomeIcons.userGroup,
          hintText: 'passeggeri',
          onFieldSubmitted: (_) {
            _notesFocusNode.requestFocus();
          },
          validator: (value) {
            if (!RegExp(numberRegex).hasMatch(value ?? '')) {
              return 'Solo numeri';
            }
            if (int.parse(value!) > widget.excursion.maxPassengers) {
              return 'Limite Passeggeri';
            }
          },
        ),
      );
//*--------------------------------------------------------------------------------
  Widget stateNotifier(String state) => Expanded(
        flex: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 55,
              width: 55,
              child: LoadingIndicator(
                indicatorType: Indicator.ballSpinFadeLoader,
                colors: [
                  CustomTheme.primaryColor,
                  CustomTheme.seconadaryColorLight
                ],
              ),
            ),
            SizedBox(height: 8),
            Text(
              state,
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      );
//*--------------------------------------------------------------------------------
//metodo che ritorna un widget in base allo stato di MediaSenderBloc
  Widget stateListener(MediaSenderState state) {
    if (state is MediaSenderInitial) {
      return SizedBox();
    } else if (state is OnCreatePdfState) {
      return stateNotifier('Creo ticket...');
    } else if (state is WaitingForSaveFileState) {
      return stateNotifier('Attendo il salvataggio del file...');
    } else if (state is OnSendingEmailState) {
      return stateNotifier('invio E-mail');
    } else if (state is EmailSendedState) {
      return stateNotifier('E-mail inviata');
    } else if (state is OpeningWhatsappState) {
      return stateNotifier('Apro Whatsapp....');
    } else if (state is ErrorCreateTicketState) {
      return errorWidget('Errore...Ticket Non creato');
    }
    return SizedBox();
  }

//*--------------------------------------------------------------------------------
//metodo che ritorna un widget per visualizzare eventuali errori
  Widget errorWidget(String error) => Container(
        margin: const EdgeInsets.symmetric(vertical: 20.0),
        width: double.maxFinite,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.red.shade700,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0),
          child: Column(
            children: [
              Icon(
                Icons.error,
                color: Colors.red.shade700,
                size: 28,
              ),
              //SizedBox(height: 10),
              Text(
                error,
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                  onPressed: () =>
                      BlocProvider.of<MediaSenderBloc>(context).resetState(),
                  child: Text('Riprova')),
            ],
          ),
        ),
      );
//*--------------------------------------------------------------------------------
  Widget switchsWidget() => Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Text(
                'Invia Ticket tramite',
                style: TextStyle(
                    color: CustomTheme.secondaryColorDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
            Expanded(child: SizedBox()),
            whatsappSwitch(),
            SizedBox(width: 10),
            emailSwitch(),
          ],
        ),
      );
//*--------------------------------------------------------------------------------
  Widget whatsappSwitch() => Column(
        children: [
          Text(
            'Whatsapp',
            style: TextStyle(color: Colors.green, fontSize: 12),
          ),
          SizedBox(height: 8),
          FlutterSwitch(
              width: 60,
              height: 30,
              disabled: !_enabled,
              activeTextColor: Colors.red,
              activeText: 'Whatsapp',
              activeToggleColor: Colors.green,
              activeColor: Colors.green.shade100,
              inactiveColor: CustomTheme.complementaryColor2,
              padding: 3,
              activeIcon: Icon(
                FontAwesomeIcons.whatsapp,
                color: Colors.white,
              ),
              inactiveIcon: Icon(
                FontAwesomeIcons.whatsapp,
                color: Colors.black,
              ),
              value: _isWhatsappCkecked,
              onToggle: (value) {
                setState(() {
                  if (RegExp(phoneRegex)
                      .hasMatch(_phoneNumberController.text)) {
                    _isWhatsappCkecked = value;
                  }
                });
              }),
        ],
      );
//*--------------------------------------------------------------------------------
  Widget emailSwitch() => Column(
        children: [
          Text(
            'Email',
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
          SizedBox(height: 8),
          FlutterSwitch(
              width: 60,
              height: 30,
              disabled: !_enabled,
              activeToggleColor: Colors.red.shade600,
              activeColor: Colors.red.shade100,
              inactiveColor: CustomTheme.complementaryColor2,
              activeIcon: Icon(
                FontAwesomeIcons.envelope,
                color: Colors.white,
              ),
              inactiveIcon: Icon(
                FontAwesomeIcons.envelope,
                color: Colors.black,
              ),
              value: _isEmailChecked,
              onToggle: (value) {
                setState(() {
                  if (RegExp(emailRegex).hasMatch(_emailController.text)) {
                    _isEmailChecked = value;
                  }
                });
              }),
        ],
      );
//*--------------------------------------------------------------------------------
  Widget notesWidget() => Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 8, top: 4, bottom: 4),
              decoration: BoxDecoration(
                  color: Colors.amber.shade200,
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
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              height: 100,
              decoration: BoxDecoration(
                color: Colors.yellow.shade100,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8)),
              ),
              child: TextFormField(
                enabled: _enabled,
                style: TextStyle(
                  color: CustomTheme.secondaryColorDark,
                ),
                maxLines: 4,
                controller: _notesController,
                focusNode: _notesFocusNode,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      );
//*--------------------------------------------------------------------------------
  Widget confirmButton() => Expanded(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              backgroundColor:
                  MaterialStatePropertyAll(CustomTheme.complementaryColor1),
            ),
            onPressed: _formValid && _enabled ? _createTicket : null,
            child: Text(
              'Prenota',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: CustomTheme.complementaryColor2,
              ),
            ),
          ),
        ),
      );
//*--------------------------------------------------------------------------------
  Widget updateButton() => Expanded(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              backgroundColor:
                  MaterialStatePropertyAll(CustomTheme.complementaryColor1),
            ),
            onPressed: _formValid && _enabled ? _updateTicket : null,
            child: Text(
              'Modifica',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: CustomTheme.complementaryColor2,
              ),
            ),
          ),
        ),
      );
//*--------------------------------------------------------------------------------
  Widget exitButton({required bool enabled}) => Expanded(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              backgroundColor:
                  MaterialStatePropertyAll(CustomTheme.complementaryColor2),
            ),
            onPressed: !enabled
                ? null
                : () {
                    BlocProvider.of<MediaSenderBloc>(context).resetState();
                    context.router.pop();
                  },
            child: Text(
              'Esci',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: CustomTheme.complementaryColor1,
              ),
            ),
          ),
        ),
      );
//*--------------------------------------------------------------------------------
  void _createTicket() async {
    {
      var reservation = Reservation(
        email: _emailController.text,
        phoneNumber: _phoneNumberController.text,
        isNotifiedWithEmail: _isEmailChecked,
        pricePerPassengers: double.parse(_priceController.text),
        isPaid: false,
        isNotifiedWithWhatsapp: _isWhatsappCkecked,
        excurionReference: widget.excursion.excursionCode,
        reservationId: Uuid().v4(),
        clientName: _nameController.text,
        clientSurname: _surnameController.text,
        numberOfPassengers: int.parse(_passengersController.text),
        reservedBy: 'Alessandro',
        created_at: DateTime.now(),
        updated_at: DateTime.now(),
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );
      BlocProvider.of<MediaSenderBloc>(context)
          .createTicket(reservation: reservation, excursion: widget.excursion);
    }
  }

//*--------------------------------------------------------------------------------
// metodo per gestire l'update del ticket chiamato dalla pressione di updateButton
  void _updateTicket() {
    {
      //creo un istanza di Reservation.
      Reservation newReservation = Reservation(
        email: _emailController.text,
        phoneNumber: _phoneNumberController.text,
        isNotifiedWithEmail: _isEmailChecked,
        pricePerPassengers: double.parse(_priceController.text),
        isPaid: false,
        isNotifiedWithWhatsapp: _isWhatsappCkecked,
        excurionReference: widget.excursion.excursionCode,
        reservationId: widget.reservation!.reservationId,
        clientName: _nameController.text,
        clientSurname: _surnameController.text,
        numberOfPassengers: int.parse(_passengersController.text),
        reservedBy: 'Alessandro',
        created_at: widget.reservation!.created_at,
        updated_at: DateTime.now(),
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );
      //controlla il tipo di modifica effettuata al ticket chiamando il metodo statico della classe Reservatio, .compareReservation
      //che restituisce uno dei valori dell'enum ReservationDifferenceCheck
      ReservationDifferenceCheck checkDiffernce =
          Reservation.compareReservation(
              original: widget.reservation!, updated: newReservation);
      // controlla il valore di ritorno e afisce di conseguenza.
      if (checkDiffernce == ReservationDifferenceCheck.none) {
        //se non ci sono modifiche mostra una snackbar di errore
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: "Non hai modificato nessun campo",
          ),
        );
      } else if (checkDiffernce == ReservationDifferenceCheck.onlyNotes) {
        // se sono state modificate solo le note fa l'update della Reservation
        _updateReservation(updatedReservation: newReservation);
        EasyLoading.showSuccess('Aggiornata');
      } else if (checkDiffernce == ReservationDifferenceCheck.different) {
        // se sono stati modificati altri avvia il processo di creazione del ticket.
        BlocProvider.of<MediaSenderBloc>(context).createTicket(
            reservation: newReservation, excursion: widget.excursion);
      }
    }
  }

//*--------------------------------------------------------------------------------
  void saveReservation(
          {required Reservation reservation, required Excursion excursion}) =>
      BlocProvider.of<ReservationsBloc>(context).addReservation(
          reservation: reservation, excursion: widget.excursion);
//*--------------------------------------------------------------------------------
  void _updateReservation({required Reservation updatedReservation}) =>
      BlocProvider.of<ReservationsBloc>(context)
          .updateReservation(reservation: updatedReservation);
//*--------------------------------------------------------------------------------
  void clearFiled() {
    _formKey.currentState!.reset();
    _nameController.clear();
    _surnameController.clear();
    _phoneNumberController.clear();
    _emailController.clear();
    _priceController.clear();
    _passengersController.clear();
    _notesController.clear();
  }

//*--------------------------------------------------------------------------------
  void disableField(MediaSenderState state) {
    if (state is MediaSenderInitial || state is ErrorCreateTicketState) {
      setState(() {
        _enabled = true;
        print(_enabled);
      });
    } else {
      setState(() {
        _enabled = false;
      });
    }
  }

//*--------------------------------------------------------------------------------
  void saveListener(MediaSenderState state) {
    if (state is FileSavedState && widget.mode == ReservationFormMode.create) {
      saveReservation(
          excursion: state.excursion, reservation: state.reservation);
      EasyLoading.showSuccess('prenotata', duration: Duration(seconds: 1));
      clearFiled();
    } else if (state is FileSavedState &&
        widget.mode == ReservationFormMode.update) {
      _updateReservation(updatedReservation: state.reservation);
    }
  }

//*--------------------------------------------------------------------------------
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

enum ReservationFormMode {
  create,
  update,
}
