import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/model/app_user.dart';
import '../../domain/use_cases/sign_up_use_case.dart';
part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final SignUpUseCase _signUpUseCase;

  SignupCubit(this._signUpUseCase) : super(const SignupState.initial());

  Future<void> signUp(String email, String password) async {
    if (state is SignupLoading) return;
    emit(const SignupState.loading());
    try {
      final user = await _signUpUseCase(email: email, password: password);
      emit(SignupState.success(user));
    } catch (e) {
      emit(SignupState.failure(e.toString()));
    }
  }
}
