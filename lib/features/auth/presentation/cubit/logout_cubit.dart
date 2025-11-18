import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/use_cases/sign_out_use_case.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final SignOutUseCase _signOutUseCase;

  LogoutCubit(this._signOutUseCase) : super(const LogoutState.initial());

  Future<void> logout() async {
    if (state is LogoutLoading) return;
    emit(const LogoutState.loading());
    try {
      await _signOutUseCase();
      emit(const LogoutState.success());
    } catch (e) {
      emit(LogoutState.failure(e.toString()));
    }
  }

  void reset() {
    emit(const LogoutState.initial());
  }
}

