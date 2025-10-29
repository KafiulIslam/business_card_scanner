import '../../data/model/app_user.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository _authRepository;

  const SignUpUseCase(this._authRepository);

  Future<AppUser> call({required String email, required String password}) {
    return _authRepository.signUpWithEmail(email: email, password: password);
  }
}
