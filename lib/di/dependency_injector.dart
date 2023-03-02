import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sacs_app/blocs/calendar/bloc/calendar_bloc.dart';
import 'package:sacs_app/blocs/excursion/bloc/excursion_bloc.dart';
import 'package:sacs_app/blocs/initial_data/bloc/initial_data_bloc.dart';
import 'package:sacs_app/blocs/media_sender/bloc/media_sender_bloc.dart';
import 'package:sacs_app/blocs/reservations/bloc/reservations_bloc.dart';
import 'package:sacs_app/blocs/sliding_panel_bloc/bloc/sliding_panel_bloc.dart';
import 'package:sacs_app/cubits/auth/cubit/auth_cubit.dart';
import 'package:sacs_app/mappers/excursion_firebase_mapper.dart';
import 'package:sacs_app/mappers/firebase_mapper.dart';
import 'package:sacs_app/mappers/reservation_firebase_mapper.dart';
import 'package:sacs_app/mappers/user_firebase_mapper.dart';
import 'package:sacs_app/models/app_user.dart';
import 'package:sacs_app/providers/shared_preferences_provider.dart';
import 'package:sacs_app/repositories/authentication_repository.dart';
import 'package:sacs_app/repositories/excursion_repository.dart';
import 'package:sacs_app/repositories/reservation_repository.dart';
import 'package:sacs_app/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DependencyInjector extends StatelessWidget {
  final Widget child;
  const DependencyInjector({super.key, required this.child});

  @override
  Widget build(BuildContext context) => _providers(
        child: _mappers(
          child: _repositories(
            child: _blocs(
              child: child,
            ),
          ),
        ),
      );

  Widget _providers({required Widget child}) => MultiProvider(
        providers: [
          Provider<SharedPreferencesProvider>(
            create: (_) => SharedPreferencesProvider(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
          Provider<FirebaseAuth>(
            create: (_) => FirebaseAuth.instance,
          ),
          Provider<FirebaseFirestore>(
              create: (_) => FirebaseFirestore.instance),
        ],
        child: child,
      );
  Widget _mappers({required Widget child}) => MultiProvider(
        providers: [
          Provider<FireBaseMapper<AppUser>>(
            create: (_) => UserFireBaseMapper(),
          ),
          Provider(
            create: (_) => ReservaTionFireBaseMapper(),
          ),
          Provider(
            create: (context) => ExcursionMapper(
              reservationMapper: context.read(),
            ),
          ),
        ],
        child: child,
      );
  Widget _repositories({required Widget child}) => MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) => AuthenticationRepository(
              firebaseAuth: context.read(),
            ),
          ),
          RepositoryProvider(
            create: (context) => UserRepository(
              firebaseFirestore: context.read(),
              userMapper: context.read(),
            ),
          ),
          RepositoryProvider(
            create: (context) => ReservationRepository(
              firebaseFireStore: context.read(),
              reservationMapper: context.read(),
            ),
          ),
          RepositoryProvider(
            create: (context) => ExcursionRepository(
              reservationMapper: context.read(),
              excursionMapper: context.read(),
              firebaseFirestore: context.read(),
              reservationRepository: context.read(),
            ),
          ),
        ],
        child: child,
      );
  Widget _blocs({required Widget child}) => MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(
              firebaseAuth: context.read(),
            ),
          ),
          BlocProvider(
            create: (context) => CalendarBloc(
              sharedPreferencesProvider: context.read(),
            )..init(),
          ),
          BlocProvider(
            create: (context) => SlidingPanelBloc(
              reservationRepository: context.read(),
              excursionRepository: context.read(),
            ),
          ),
          BlocProvider(
            create: (context) => InitialDataBloc(
              excursionMapper: context.read(),
              firebaseFirestore: context.read(),
              excursionRepository: context.read(),
            )..downloadExcursion(),
          ),
          BlocProvider(
            create: (context) => ExcursionBloc(
              firebaseFirestore: context.read(),
              excursionRepository: context.read(),
              excursionMapper: context.read(),
            ),
          ),
          BlocProvider(
            create: (context) => ReservationsBloc(
              excursionRepository: context.read(),
              reservationRepository: context.read(),
            ),
          ),
          BlocProvider(create: (context) => MediaSenderBloc()),
        ],
        child: child,
      );
}
