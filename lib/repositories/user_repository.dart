import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sacs_app/mappers/firebase_mapper.dart';
import 'package:sacs_app/models/app_user.dart';

class UserRepository {
  final FirebaseFirestore firebaseFirestore;
  final FireBaseMapper<AppUser> userMapper;

  UserRepository({
    required this.firebaseFirestore,
    required this.userMapper,
  });

  Future<void> create(AppUser user) async {
    firebaseFirestore.collection('users').doc(user.id).set(
          userMapper.toFirebase(user),
        );
  }
}
