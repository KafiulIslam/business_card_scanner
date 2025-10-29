part of 'signup_cubit.dart';

abstract class SignupState extends Equatable {
  const SignupState();

  const factory SignupState.initial() = SignupInitial;
  const factory SignupState.loading() = SignupLoading;
  factory SignupState.success(AppUser user) = SignupSuccess;
  const factory SignupState.failure(String message) = SignupFailure;

  @override
  List<Object?> get props => [];
}

class SignupInitial extends SignupState {
  const SignupInitial();
}

class SignupLoading extends SignupState {
  const SignupLoading();
}

class SignupSuccess extends SignupState {
  final AppUser user;
  SignupSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class SignupFailure extends SignupState {
  final String message;
  const SignupFailure(this.message);

  @override
  List<Object?> get props => [message];
}
