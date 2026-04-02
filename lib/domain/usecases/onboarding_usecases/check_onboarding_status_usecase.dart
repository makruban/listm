import 'package:tripwise/domain/repositories/onboarding_repository.dart';

class CheckOnboardingStatusUseCase {
  final OnboardingRepository repository;

  CheckOnboardingStatusUseCase(this.repository);

  bool call() {
    return repository.getHasSeenOnboarding();
  }
}
