import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_loadingindicator/flutter_loadingindicator.dart';
import 'package:sacs_app/blocs/initial_data/bloc/initial_data_bloc.dart';
import 'package:sacs_app/exceptions/excursion_repository_exception.dart';
import 'package:sacs_app/mappers/excursion_firebase_mapper.dart';
import 'package:sacs_app/models/excursion_model.dart';
import 'package:sacs_app/repositories/excursion_repository.dart';

part 'excursion_event.dart';
part 'excursion_state.dart';

class ExcursionBloc extends Bloc<ExcursionEvent, ExcursionState> {
  final ExcursionMapper excursionMapper;
  final FirebaseFirestore firebaseFirestore;
  final ExcursionRepository excursionRepository;

  ExcursionBloc({
    required this.firebaseFirestore,
    required this.excursionRepository,
    required this.excursionMapper,
  }) : super(ExcursionInitial()) {
    on<ExcursionEvent>(
      (event, emit) async {
        if (event is AddExcursionsEvent) {
          addingExcursion(event);
        }
      },
    );
  }

  void addExcursion(Excursion excursion) =>
      add(AddExcursionsEvent(excursion: excursion));

  void addingExcursion(AddExcursionsEvent event) async {
    try {
      await excursionRepository.create(event.excursion).onError(
        (error, stackTrace) {
          emit(ErrorAddExcursionState());
          throw ExcursionRepositoryError(error.toString());
        },
      );
    } catch (e) {
      emit(ErrorAddExcursionState());
      throw ExcursionRepositoryError(e.toString());
    }
    emit(ExcursionAddedState());
    EasyLoading.showSuccess('prenotata', duration: Duration(seconds: 1));
  }
}
