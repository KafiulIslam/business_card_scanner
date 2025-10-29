import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/use_cases/sign_in_use_case.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final SignInUseCase _signInUseCase;

  LoginCubit(this._signInUseCase) : super(const LoginState.initial());

  Future<void> login(String email, String password) async {
    if (state is LoginLoading) return;
    emit(const LoginState.loading());
    try {
      final user = await _signInUseCase(email: email, password: password);
      emit(LoginState.success(user));
    } catch (e) {
      emit(LoginState.failure(e.toString()));
    }
  }
}
