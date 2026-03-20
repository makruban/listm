abstract class OnboardingRepository {
  /// Returns whether the user has seen the onboarding screen.
  bool getHasSeenOnboarding();

  /// Sets whether the user has seen the onboarding screen.
  Future<void> setHasSeenOnboarding(bool value);
}
