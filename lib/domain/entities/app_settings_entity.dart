class AppSettingsEntity {
  final String? languageCode;
  final String? themeMode;

  const AppSettingsEntity({
    this.languageCode,
    this.themeMode,
  });

  factory AppSettingsEntity.defaultSettings() {
    return const AppSettingsEntity(languageCode: null, themeMode: null);
  }

  Map<String, dynamic> toJson() {
    return {
      'languageCode': languageCode,
      'themeMode': themeMode,
    };
  }

  factory AppSettingsEntity.fromJson(Map<String, dynamic> json) {
    return AppSettingsEntity(
      languageCode: json['languageCode'] as String?,
      themeMode: json['themeMode'] as String?,
    );
  }

  AppSettingsEntity copyWith({
    String? languageCode,
    String? themeMode,
    bool clearThemeMode = false,
  }) {
    return AppSettingsEntity(
      languageCode: languageCode ?? this.languageCode,
      themeMode: clearThemeMode ? null : (themeMode ?? this.themeMode),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppSettingsEntity &&
        other.languageCode == languageCode &&
        other.themeMode == themeMode;
  }

  @override
  int get hashCode => languageCode.hashCode ^ themeMode.hashCode;
}
