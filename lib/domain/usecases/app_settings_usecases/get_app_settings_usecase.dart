import 'package:tripwise/domain/entities/app_settings_entity.dart';
import 'package:tripwise/domain/repositories/app_settings_repository.dart';
import 'package:tripwise/domain/value_objects/no_params.dart';

class GetAppSettingsUseCase {
  final AppSettingsRepository repository;

  GetAppSettingsUseCase(this.repository);

  Future<AppSettingsEntity> call(NoParams params) async {
    return await repository.getSettings();
  }
}
