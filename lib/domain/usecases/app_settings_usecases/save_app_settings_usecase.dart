import 'package:listm/domain/entities/app_settings_entity.dart';
import 'package:listm/domain/repositories/app_settings_repository.dart';

class SaveAppSettingsUseCase {
  final AppSettingsRepository repository;

  SaveAppSettingsUseCase(this.repository);

  Future<void> call(AppSettingsEntity settings) async {
    return await repository.saveSettings(settings);
  }
}
