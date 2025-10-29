import 'package:business_card_scanner/features/auth/domain/entities/app_user.dart';

abstract class AuthRepository {
  Future<AppUser> signUpWithEmail(
      {required String email, required String password});
}
