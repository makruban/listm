import 'package:tripwise/domain/entities/app_settings_entity.dart';

abstract class AppSettingsRepository {
  Future<AppSettingsEntity> getSettings();
  Future<void> saveSettings(AppSettingsEntity settings);
}
