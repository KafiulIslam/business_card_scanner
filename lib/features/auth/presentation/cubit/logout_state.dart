part of 'logout_cubit.dart';

abstract class LogoutState extends Equatable {
  const LogoutState();

  const factory LogoutState.initial() = LogoutInitial;
  const factory LogoutState.loading() = LogoutLoading;
  const factory LogoutState.success() = LogoutSuccess;
  factory LogoutState.failure(String message) = LogoutFailure;

  @override
  List<Object?> get props => [];
}

class LogoutInitial extends LogoutState {
  const LogoutInitial();
}

class LogoutLoading extends LogoutState {
  const LogoutLoading();
}

class LogoutSuccess extends LogoutState {
  const LogoutSuccess();
}

class LogoutFailure extends LogoutState {
  final String message;
  const LogoutFailure(this.message);

  @override
  List<Object?> get props => [message];
}

