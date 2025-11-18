part of 'delete_account_cubit.dart';

abstract class DeleteAccountState extends Equatable {
  const DeleteAccountState();

  const factory DeleteAccountState.initial() = DeleteAccountInitial;
  const factory DeleteAccountState.loading() = DeleteAccountLoading;
  const factory DeleteAccountState.success() = DeleteAccountSuccess;
  factory DeleteAccountState.failure(String message) = DeleteAccountFailure;

  @override
  List<Object?> get props => [];
}

class DeleteAccountInitial extends DeleteAccountState {
  const DeleteAccountInitial();
}

class DeleteAccountLoading extends DeleteAccountState {
  const DeleteAccountLoading();
}

class DeleteAccountSuccess extends DeleteAccountState {
  const DeleteAccountSuccess();
}

class DeleteAccountFailure extends DeleteAccountState {
  final String message;
  const DeleteAccountFailure(this.message);

  @override
  List<Object?> get props => [message];
}

