part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  const factory LoginState.initial() = LoginInitial;
  const factory LoginState.loading() = LoginLoading;
  factory LoginState.success(AppUser user) = LoginSuccess;
  factory LoginState.failure(String message) = LoginFailure;

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  final AppUser user;
  LoginSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class LoginFailure extends LoginState {
  final String message;
  const LoginFailure(this.message);

  @override
  List<Object?> get props => [message];
}
