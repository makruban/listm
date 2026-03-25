import 'package:listm/domain/entities/app_settings_entity.dart';
import 'package:listm/domain/repositories/app_settings_repository.dart';
import 'package:listm/domain/value_objects/no_params.dart';

class GetAppSettingsUseCase {
  final AppSettingsRepository repository;

  GetAppSettingsUseCase(this.repository);

  Future<AppSettingsEntity> call(NoParams params) async {
    return await repository.getSettings();
  }
}
