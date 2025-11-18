import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/use_cases/delete_account_use_case.dart';

part 'delete_account_state.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  final DeleteAccountUseCase _deleteAccountUseCase;

  DeleteAccountCubit(this._deleteAccountUseCase)
      : super(const DeleteAccountState.initial());

  Future<void> deleteAccount() async {
    if (state is DeleteAccountLoading) return;
    emit(const DeleteAccountState.loading());
    try {
      await _deleteAccountUseCase();
      emit(const DeleteAccountState.success());
    } catch (e) {
      emit(DeleteAccountState.failure(e.toString()));
    }
  }

  void reset() {
    emit(const DeleteAccountState.initial());
  }
}

