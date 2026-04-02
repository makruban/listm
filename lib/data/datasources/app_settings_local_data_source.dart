import 'dart:convert';
import 'package:tripwise/core/resources/app_key_constants.dart';
import 'package:tripwise/domain/entities/app_settings_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AppSettingsLocalDataSource {
  Future<AppSettingsEntity> getSettings();
  Future<void> saveSettings(AppSettingsEntity settings);
}

class AppSettingsLocalDataSourceImpl implements AppSettingsLocalDataSource {
  final SharedPreferencesWithCache prefsWithCache;

  AppSettingsLocalDataSourceImpl({required this.prefsWithCache});

  @override
  Future<AppSettingsEntity> getSettings() async {
    try {
      final jsonString = prefsWithCache.getString(CacheKeys.appSettings);
      if (jsonString != null && jsonString.isNotEmpty) {
        final jsonMap = jsonDecode(jsonString);
        return AppSettingsEntity.fromJson(jsonMap);
      }
    } catch (_) {}
    return AppSettingsEntity.defaultSettings();
  }

  @override
  Future<void> saveSettings(AppSettingsEntity settings) async {
    final jsonString = jsonEncode(settings.toJson());
    await prefsWithCache.setString(CacheKeys.appSettings, jsonString);
  }
}
