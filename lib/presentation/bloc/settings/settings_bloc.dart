import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listm/domain/entities/app_settings_entity.dart';
import 'package:listm/domain/usecases/app_settings_usecases/get_app_settings_usecase.dart';
import 'package:listm/domain/usecases/app_settings_usecases/save_app_settings_usecase.dart';
import 'package:listm/domain/value_objects/no_params.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetAppSettingsUseCase getAppSettingsUseCase;
  final SaveAppSettingsUseCase saveAppSettingsUseCase;

  SettingsBloc({
    required this.getAppSettingsUseCase,
    required this.saveAppSettingsUseCase,
  }) : super(SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateLanguage>(_onUpdateLanguage);
    on<UpdateThemeMode>(_onUpdateThemeMode);
  }

  Future<void> _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading(state.settings));
    try {
      final settings = await getAppSettingsUseCase(const NoParams());
      emit(SettingsLoaded(settings));
    } catch (e) {
      emit(SettingsError(state.settings, e.toString()));
    }
  }

  Future<void> _onUpdateLanguage(UpdateLanguage event, Emitter<SettingsState> emit) async {
    try {
      final updatedSettings = state.settings.copyWith(languageCode: event.languageCode);
      emit(SettingsLoaded(updatedSettings));
      await saveAppSettingsUseCase(updatedSettings);
    } catch (e) {
      emit(SettingsError(state.settings, e.toString()));
    }
  }

  Future<void> _onUpdateThemeMode(UpdateThemeMode event, Emitter<SettingsState> emit) async {
    try {
      final updatedSettings = state.settings.copyWith(
        themeMode: event.themeMode,
        clearThemeMode: event.themeMode == null,
      );
      emit(SettingsLoaded(updatedSettings));
      await saveAppSettingsUseCase(updatedSettings);
    } catch (e) {
      emit(SettingsError(state.settings, e.toString()));
    }
  }
}
