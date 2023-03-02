import 'package:sacs_app/mappers/firebase_mapper.dart';

import '../models/app_user.dart';

class UserFireBaseMapper extends FireBaseMapper<AppUser> {
  @override
  AppUser fromFirebase(Map<String, dynamic> map) {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toFirebase(AppUser user) => {
        'first_name': user.firstName,
        'last_name': user.lastName,
        'last_access': user.lastAccess.millisecondsSinceEpoch,
      };
}
