import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository _authRepository;

  const SignInUseCase(this._authRepository);

  Future<AppUser> call({required String email, required String password}) {
    return _authRepository.signInWithEmail(email: email, password: password);
  }
}
