// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i10;
import 'package:firebase_auth/firebase_auth.dart' as _i12;
import 'package:flutter/material.dart' as _i11;
import 'package:sacs_app/pages/archive_page.dart' as _i6;
import 'package:sacs_app/pages/desktop_home_page.dart' as _i3;
import 'package:sacs_app/pages/handset_home_page.dart' as _i4;
import 'package:sacs_app/pages/log_in_page.dart' as _i1;
import 'package:sacs_app/pages/main_page.dart' as _i2;
import 'package:sacs_app/pages/settings_page.dart' as _i7;
import 'package:sacs_app/pages/statistic_page.dart' as _i5;
import 'package:sacs_app/pages/widgets/sign_in_tab.dart' as _i8;
import 'package:sacs_app/pages/widgets/sign_up.dart' as _i9;

class AppRouter extends _i10.RootStackRouter {
  AppRouter([_i11.GlobalKey<_i11.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i10.PageFactory> pagesMap = {
    LoginRoute.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.LoginPage(),
      );
    },
    MainRoute.name: (routeData) {
      final args =
          routeData.argsAs<MainRouteArgs>(orElse: () => const MainRouteArgs());
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i2.MainPage(key: args.key),
      );
    },
    DesktopHomeRoute.name: (routeData) {
      final args = routeData.argsAs<DesktopHomeRouteArgs>();
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i3.DesktopHomePage(
          key: args.key,
          user: args.user,
        ),
      );
    },
    HandsetHomeRoute.name: (routeData) {
      final args = routeData.argsAs<HandsetHomeRouteArgs>();
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i4.HandsetHomePage(
          key: args.key,
          user: args.user,
        ),
      );
    },
    StatisticRoute.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i5.StatisticPage(),
      );
    },
    ArchiveRoute.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i6.ArchivePage(),
      );
    },
    SettingsRoute.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i7.SettingsPage(),
      );
    },
    SignInTab.name: (routeData) {
      final args =
          routeData.argsAs<SignInTabArgs>(orElse: () => const SignInTabArgs());
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i8.SignInTab(key: args.key),
      );
    },
    SignUpTab.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i9.SignUpTab(),
      );
    },
  };

  @override
  List<_i10.RouteConfig> get routes => [
        _i10.RouteConfig(
          LoginRoute.name,
          path: '/login-page',
        ),
        _i10.RouteConfig(
          MainRoute.name,
          path: '/',
        ),
        _i10.RouteConfig(
          DesktopHomeRoute.name,
          path: '/desktop-home-page',
        ),
        _i10.RouteConfig(
          HandsetHomeRoute.name,
          path: '/handset-home-page',
        ),
        _i10.RouteConfig(
          StatisticRoute.name,
          path: '/statistic-page',
        ),
        _i10.RouteConfig(
          ArchiveRoute.name,
          path: '/archive-page',
        ),
        _i10.RouteConfig(
          SettingsRoute.name,
          path: '/settings-page',
        ),
        _i10.RouteConfig(
          SignInTab.name,
          path: '/sign-in-tab',
        ),
        _i10.RouteConfig(
          SignUpTab.name,
          path: '/sign-up-tab',
        ),
      ];
}

/// generated route for
/// [_i1.LoginPage]
class LoginRoute extends _i10.PageRouteInfo<void> {
  const LoginRoute()
      : super(
          LoginRoute.name,
          path: '/login-page',
        );

  static const String name = 'LoginRoute';
}

/// generated route for
/// [_i2.MainPage]
class MainRoute extends _i10.PageRouteInfo<MainRouteArgs> {
  MainRoute({_i11.Key? key})
      : super(
          MainRoute.name,
          path: '/',
          args: MainRouteArgs(key: key),
        );

  static const String name = 'MainRoute';
}

class MainRouteArgs {
  const MainRouteArgs({this.key});

  final _i11.Key? key;

  @override
  String toString() {
    return 'MainRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i3.DesktopHomePage]
class DesktopHomeRoute extends _i10.PageRouteInfo<DesktopHomeRouteArgs> {
  DesktopHomeRoute({
    _i11.Key? key,
    required _i12.User user,
  }) : super(
          DesktopHomeRoute.name,
          path: '/desktop-home-page',
          args: DesktopHomeRouteArgs(
            key: key,
            user: user,
          ),
        );

  static const String name = 'DesktopHomeRoute';
}

class DesktopHomeRouteArgs {
  const DesktopHomeRouteArgs({
    this.key,
    required this.user,
  });

  final _i11.Key? key;

  final _i12.User user;

  @override
  String toString() {
    return 'DesktopHomeRouteArgs{key: $key, user: $user}';
  }
}

/// generated route for
/// [_i4.HandsetHomePage]
class HandsetHomeRoute extends _i10.PageRouteInfo<HandsetHomeRouteArgs> {
  HandsetHomeRoute({
    _i11.Key? key,
    required _i12.User user,
  }) : super(
          HandsetHomeRoute.name,
          path: '/handset-home-page',
          args: HandsetHomeRouteArgs(
            key: key,
            user: user,
          ),
        );

  static const String name = 'HandsetHomeRoute';
}

class HandsetHomeRouteArgs {
  const HandsetHomeRouteArgs({
    this.key,
    required this.user,
  });

  final _i11.Key? key;

  final _i12.User user;

  @override
  String toString() {
    return 'HandsetHomeRouteArgs{key: $key, user: $user}';
  }
}

/// generated route for
/// [_i5.StatisticPage]
class StatisticRoute extends _i10.PageRouteInfo<void> {
  const StatisticRoute()
      : super(
          StatisticRoute.name,
          path: '/statistic-page',
        );

  static const String name = 'StatisticRoute';
}

/// generated route for
/// [_i6.ArchivePage]
class ArchiveRoute extends _i10.PageRouteInfo<void> {
  const ArchiveRoute()
      : super(
          ArchiveRoute.name,
          path: '/archive-page',
        );

  static const String name = 'ArchiveRoute';
}

/// generated route for
/// [_i7.SettingsPage]
class SettingsRoute extends _i10.PageRouteInfo<void> {
  const SettingsRoute()
      : super(
          SettingsRoute.name,
          path: '/settings-page',
        );

  static const String name = 'SettingsRoute';
}

/// generated route for
/// [_i8.SignInTab]
class SignInTab extends _i10.PageRouteInfo<SignInTabArgs> {
  SignInTab({_i11.Key? key})
      : super(
          SignInTab.name,
          path: '/sign-in-tab',
          args: SignInTabArgs(key: key),
        );

  static const String name = 'SignInTab';
}

class SignInTabArgs {
  const SignInTabArgs({this.key});

  final _i11.Key? key;

  @override
  String toString() {
    return 'SignInTabArgs{key: $key}';
  }
}

/// generated route for
/// [_i9.SignUpTab]
class SignUpTab extends _i10.PageRouteInfo<void> {
  const SignUpTab()
      : super(
          SignUpTab.name,
          path: '/sign-up-tab',
        );

  static const String name = 'SignUpTab';
}
