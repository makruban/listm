import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listm/domain/usecases/onboarding_usecases/check_onboarding_status_usecase.dart';
import 'package:listm/domain/usecases/onboarding_usecases/complete_onboarding_usecase.dart';
import 'package:listm/presentation/bloc/app/app_event.dart';
import 'package:listm/presentation/bloc/app/app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final CheckOnboardingStatusUseCase checkOnboardingStatusUseCase;
  final CompleteOnboardingUseCase completeOnboardingUseCase;

  AppBloc({
    required this.checkOnboardingStatusUseCase,
    required this.completeOnboardingUseCase,
  }) : super(const AppInitial()) {
    on<AppStarted>(_onAppStarted);
    on<OnboardingCompleted>(_onOnboardingCompleted);
  }

  void _onAppStarted(AppStarted event, Emitter<AppState> emit) {
    final hasSeenOnboarding = checkOnboardingStatusUseCase();
    emit(AppReady(hasSeenOnboarding: hasSeenOnboarding));
  }

  Future<void> _onOnboardingCompleted(
    OnboardingCompleted event,
    Emitter<AppState> emit,
  ) async {
    await completeOnboardingUseCase();
    emit(const AppReady(hasSeenOnboarding: true));
  }
}
