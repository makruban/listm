class AppSettingsEntity {
  final String? languageCode;

  const AppSettingsEntity({
    this.languageCode,
  });

  factory AppSettingsEntity.defaultSettings() {
    return const AppSettingsEntity(languageCode: null);
  }

  Map<String, dynamic> toJson() {
    return {
      'languageCode': languageCode,
    };
  }

  factory AppSettingsEntity.fromJson(Map<String, dynamic> json) {
    return AppSettingsEntity(
      languageCode: json['languageCode'] as String?,
    );
  }

  AppSettingsEntity copyWith({
    String? languageCode,
  }) {
    return AppSettingsEntity(
      languageCode: languageCode ?? this.languageCode,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppSettingsEntity && other.languageCode == languageCode;
  }

  @override
  int get hashCode => languageCode.hashCode;
}
