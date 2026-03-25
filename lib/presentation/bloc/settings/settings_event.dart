part of 'settings_bloc.dart';

abstract class SettingsEvent {
  const SettingsEvent();
}

class LoadSettings extends SettingsEvent {
  const LoadSettings();
}

class UpdateLanguage extends SettingsEvent {
  final String languageCode;
  const UpdateLanguage(this.languageCode);
}
