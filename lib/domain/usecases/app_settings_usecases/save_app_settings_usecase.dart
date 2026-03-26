import 'package:tripwise/domain/entities/app_settings_entity.dart';
import 'package:tripwise/domain/repositories/app_settings_repository.dart';

class SaveAppSettingsUseCase {
  final AppSettingsRepository repository;

  SaveAppSettingsUseCase(this.repository);

  Future<void> call(AppSettingsEntity settings) async {
    return await repository.saveSettings(settings);
  }
}
