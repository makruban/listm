import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listm/core/util/build_context_ext.dart';
import 'package:listm/l10n/app_localizations.dart';
import 'package:listm/presentation/bloc/settings/settings_bloc.dart';
import 'package:listm/core/widgets/adaptive/adaptive_scaffold.dart';

class MaterialAppSettingsScreen extends StatelessWidget {
  const MaterialAppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = context.loc;

    // We get supported locales dynamically from generated localization
    final supportedLocales = AppLocalizations.supportedLocales;

    // Simple helper to get localized theme mode name
    String getThemeModeName(String? code) {
      switch (code) {
        case 'light':
          return loc.themeLight;
        case 'dark':
          return loc.themeDark;
        case 'system':
        default:
          return loc.themeSystem;
      }
    }

    // Simple helper to convert locale ID to Native language name
    String getNativeLanguageName(String code) {
      switch (code) {
        case 'en':
          return 'English';
        case 'de':
          return 'Deutsch';
        case 'es':
          return 'Español';
        case 'ar':
          return 'العربية';
        case 'hi':
          return 'हिन्दी';
        case 'ja':
          return '日本語';
        case 'fr':
          return 'Français';
        case 'it':
          return 'Italiano';
        case 'pt':
          return 'Português';
        case 'nl':
          return 'Nederlands';
        case 'pl':
          return 'Polski';
        case 'uk':
          return 'Українська';
        default:
          return code.toUpperCase();
      }
    }

    return AdaptiveScaffold(
      title: loc.settings,
      materialAppBar: (context) => AppBar(
        title: Text(
          loc.settings,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      cupertinoNavigationBar: (context) => CupertinoNavigationBar(
        middle: Text(loc.settings),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          final langCode = state.settings.languageCode;
          final currentLang =
              langCode ?? Localizations.localeOf(context).languageCode;
          final currentThemeMode = state.settings.themeMode;

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            children: [
              _buildSectionHeader(context, loc.preferences),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color:
                        theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Platform.isIOS || Platform.isMacOS
                              ? CupertinoIcons.globe
                              : Icons.language,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      title: Text(
                        loc.language,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        getNativeLanguageName(currentLang),
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      trailing: Icon(
                        Platform.isIOS || Platform.isMacOS
                            ? CupertinoIcons.chevron_right
                            : Icons.chevron_right,
                        size: 20,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      onTap: () {
                        _showLanguagePicker(context, currentLang,
                            supportedLocales, getNativeLanguageName);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color:
                        theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Platform.isIOS || Platform.isMacOS
                              ? CupertinoIcons.brightness
                              : Icons.brightness_4,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      title: Text(
                        loc.themeMode,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        getThemeModeName(currentThemeMode),
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      trailing: Icon(
                        Platform.isIOS || Platform.isMacOS
                            ? CupertinoIcons.chevron_right
                            : Icons.chevron_right,
                        size: 20,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      onTap: () {
                        _showThemeModePicker(
                            context, currentThemeMode, getThemeModeName);
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  void _showLanguagePicker(
    BuildContext context,
    String currentLang,
    List<Locale> supportedLocales,
    String Function(String) getNativeLanguageName,
  ) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Container(
                    height: 5,
                    width: 40,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: Text(
                      context.loc.selectLanguage,
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: supportedLocales.length,
                      itemBuilder: (context, index) {
                        final locale = supportedLocales[index];
                        final code = locale.languageCode;
                        final isSelected = currentLang == code;

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 4),
                          title: Text(
                            getNativeLanguageName(code),
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color:
                                  isSelected ? theme.colorScheme.primary : null,
                            ),
                          ),
                          trailing: isSelected
                              ? Icon(Icons.check_circle,
                                  color: theme.colorScheme.primary)
                              : null,
                          onTap: () {
                            context
                                .read<SettingsBloc>()
                                .add(UpdateLanguage(code));
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showThemeModePicker(
    BuildContext context,
    String? currentThemeMode,
    String Function(String?) getThemeModeName,
  ) {
    final theme = Theme.of(context);
    final themeModes = ['system', 'light', 'dark'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.4,
          maxChildSize: 0.7,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Container(
                    height: 5,
                    width: 40,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: Text(
                      context.loc.selectThemeMode,
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: themeModes.length,
                      itemBuilder: (context, index) {
                        final mode = themeModes[index];
                        final code = mode == 'system' ? null : mode;
                        final isSelected = currentThemeMode == code ||
                            (currentThemeMode == 'system' && code == null);

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 4),
                          title: Text(
                            getThemeModeName(code),
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color:
                                  isSelected ? theme.colorScheme.primary : null,
                            ),
                          ),
                          trailing: isSelected
                              ? Icon(Icons.check_circle,
                                  color: theme.colorScheme.primary)
                              : null,
                          onTap: () {
                            context
                                .read<SettingsBloc>()
                                .add(UpdateThemeMode(code));
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
