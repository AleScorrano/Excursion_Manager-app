import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:sacs_app/mappers/excursion_firebase_mapper.dart';
import 'package:sacs_app/repositories/excursion_repository.dart';
import '../../../models/excursion_model.dart';
part 'initial_data_event.dart';
part 'initial_data_state.dart';

class InitialDataBloc extends Bloc<DownloadDataEvent, DownloadDataState> {
  final ExcursionMapper excursionMapper;
  final FirebaseFirestore firebaseFirestore;
  final ExcursionRepository excursionRepository;

  InitialDataBloc({
    required this.firebaseFirestore,
    required this.excursionRepository,
    required this.excursionMapper,
  }) : super(OnDownloadDataState()) {
    on<DownloadDataEvent>(
      (event, emit) async {
        if (event is OnDownloadDataEvent) {
          emit(OnDownloadDataState());
          try {
            Stream<List<Excursion>> dataStream =
                await excursionRepository.excursions();
            emit(DataFetchedState(excursions: dataStream));
          } catch (e) {
            emit(ErrorDownloadDataState(e));
          }
        }
      },
    );
  }

  void downloadExcursion() => add(OnDownloadDataEvent());
}




    //calendarDataSource.appointments = excursions;
            /*
            var mapper = this.excursionMapper;
            dataSubscription =
                firebaseFirestore.collection('Excursions').snapshots().listen(
              (event) {
                event.docChanges.forEach(
                  (element) {
                    if (element.type == DocumentChangeType.added) {
                      if (element.doc.data()!.isNotEmpty) {
                        calendarDataSource.appointments!
                            .add(mapper.fromFirebase(element.doc.data()!));
                        calendarDataSource.notifyListeners(
                            CalendarDataSourceAction.add,
                            [mapper.fromFirebase(element.doc.data()!)]);
                      }
                    } else if (element.type == DocumentChangeType.modified) {
                    } else if (element.type == DocumentChangeType.removed) {
                      if (element.doc.data()!.isNotEmpty) {
                        Excursion onDeleting =
                            mapper.fromFirebase(element.doc.data()!);
                        calendarDataSource.appointments!.remove(onDeleting);
                        calendarDataSource.notifyListeners(
                            CalendarDataSourceAction.remove, [onDeleting]);
                      }
                    }
                  },
                );
              },
            ); */
