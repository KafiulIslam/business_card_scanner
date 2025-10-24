import 'package:equatable/equatable.dart';
import '../../domain/entities/onboard_entity.dart';

abstract class OnboardState extends Equatable {
  const OnboardState();

  @override
  List<Object?> get props => [];
}

class OnboardInitial extends OnboardState {
  const OnboardInitial();
}

class OnboardLoading extends OnboardState {
  const OnboardLoading();
}

class OnboardLoaded extends OnboardState {
  final List<OnboardEntity> onboardData;
  final int currentPage;
  final bool canGoNext;
  final bool canGoPrevious;

  const OnboardLoaded({
    required this.onboardData,
    required this.currentPage,
    required this.canGoNext,
    required this.canGoPrevious,
  });

  @override
  List<Object?> get props => [onboardData, currentPage, canGoNext, canGoPrevious];

  OnboardLoaded copyWith({
    List<OnboardEntity>? onboardData,
    int? currentPage,
    bool? canGoNext,
    bool? canGoPrevious,
  }) {
    return OnboardLoaded(
      onboardData: onboardData ?? this.onboardData,
      currentPage: currentPage ?? this.currentPage,
      canGoNext: canGoNext ?? this.canGoNext,
      canGoPrevious: canGoPrevious ?? this.canGoPrevious,
    );
  }
}

class OnboardError extends OnboardState {
  final String message;

  const OnboardError(this.message);

  @override
  List<Object?> get props => [message];
}

class OnboardCompleted extends OnboardState {
  const OnboardCompleted();
}
