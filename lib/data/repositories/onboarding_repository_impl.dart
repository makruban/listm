import 'package:listm/core/resources/app_key_constants.dart';
import 'package:listm/domain/repositories/onboarding_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final SharedPreferencesWithCache prefsWithCache;

  OnboardingRepositoryImpl({required this.prefsWithCache});

  @override
  bool getHasSeenOnboarding() {
    return prefsWithCache.getBool(CacheKeys.hasSeenOnboarding) ?? false;
  }

  @override
  Future<void> setHasSeenOnboarding(bool value) async {
    await prefsWithCache.setBool(CacheKeys.hasSeenOnboarding, value);
  }
}
