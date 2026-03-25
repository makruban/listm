import 'package:listm/data/datasources/app_settings_local_data_source.dart';
import 'package:listm/domain/entities/app_settings_entity.dart';
import 'package:listm/domain/repositories/app_settings_repository.dart';

class AppSettingsRepositoryImpl implements AppSettingsRepository {
  final AppSettingsLocalDataSource localDataSource;

  AppSettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<AppSettingsEntity> getSettings() {
    return localDataSource.getSettings();
  }

  @override
  Future<void> saveSettings(AppSettingsEntity settings) {
    return localDataSource.saveSettings(settings);
  }
}
