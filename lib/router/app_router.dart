import 'package:auto_route/auto_route.dart';
import 'package:sacs_app/pages/archive_page.dart';
import 'package:sacs_app/pages/desktop_home_page.dart';
import 'package:sacs_app/pages/handset_home_page.dart';
import 'package:sacs_app/pages/log_in_page.dart';
import 'package:sacs_app/pages/main_page.dart';
import 'package:sacs_app/pages/settings_page.dart';
import 'package:sacs_app/pages/statistic_page.dart';
import 'package:sacs_app/pages/widgets/sign_in_tab.dart';
import 'package:sacs_app/pages/widgets/sign_up.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  preferRelativeImports: false,
  routes: <AutoRoute>[
    AutoRoute(page: LoginPage),
    AutoRoute(page: MainPage, initial: true),
    AutoRoute(page: DesktopHomePage),
    AutoRoute(page: HandsetHomePage),
    AutoRoute(page: StatisticPage),
    AutoRoute(page: ArchivePage),
    AutoRoute(page: SettingsPage),
  ],
)
class $AppRouter {}
