import 'package:business_card_scanner/features/auth/domain/entities/app_user.dart';
import 'package:business_card_scanner/features/auth/domain/repositories/auth_repository.dart';
import '../services/firebase_auth_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService _firebaseAuthService;

  AuthRepositoryImpl(this._firebaseAuthService);

  @override
  Future<AppUser> signUpWithEmail(
      {required String email, required String password}) async {
    final user = await _firebaseAuthService.createUserWithEmail(
        email: email, password: password);
    return AppUser(
        uid: user.uid, email: user.email, displayName: user.displayName);
  }
}
