abstract class AppEvent {
  const AppEvent();

  List<Object?> get props => [];
}

class AppStarted extends AppEvent {
  const AppStarted();
}

class OnboardingCompleted extends AppEvent {
  const OnboardingCompleted();
}
