part of 'settings_bloc.dart';

abstract class SettingsState {
  final AppSettingsEntity settings;
  const SettingsState(this.settings);
  
  List<Object?> get props => [settings];
}

class SettingsInitial extends SettingsState {
  SettingsInitial() : super(AppSettingsEntity.defaultSettings());
}

class SettingsLoading extends SettingsState {
  const SettingsLoading(super.settings);
}

class SettingsLoaded extends SettingsState {
  const SettingsLoaded(super.settings);
}

class SettingsError extends SettingsState {
  final String message;
  const SettingsError(super.settings, this.message);
  
  @override
  List<Object?> get props => [settings, message];
}
