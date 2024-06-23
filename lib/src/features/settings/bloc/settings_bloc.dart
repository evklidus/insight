import 'dart:ui' show Locale;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight/src/features/settings/data/theme_repository.dart';
import 'package:insight/src/features/app/model/app_theme.dart';

/// {@template settings_bloc}
/// A [Bloc] that handles the settings.
/// {@endtemplate}
final class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  /// {@macro settings_bloc}
  SettingsBloc({
    required ThemeRepository themeRepository,
    required SettingsState initialState,
  })  : _themeRepo = themeRepository,
        super(initialState) {
    on<SettingsEvent>(
      (event, emit) => switch (event) {
        final _UpdateThemeSettingsEvent e => _updateTheme(e, emit),
      },
    );
  }

  final ThemeRepository _themeRepo;

  Future<void> _updateTheme(
    _UpdateThemeSettingsEvent event,
    Emitter<SettingsState> emitter,
  ) async {
    emitter(
      SettingsState.processing(
        appTheme: state.appTheme,
        locale: state.locale,
      ),
    );

    try {
      await _themeRepo.setTheme(event.appTheme);

      emitter(
        SettingsState.idle(appTheme: event.appTheme, locale: state.locale),
      );
    } on Object catch (e) {
      emitter(
        SettingsState.error(
          appTheme: state.appTheme,
          locale: state.locale,
          cause: e,
        ),
      );
      rethrow;
    }
  }
}

/// States for the [SettingsBloc].
sealed class SettingsState {
  const SettingsState({this.locale, this.appTheme});

  /// Application locale.
  final Locale? locale;

  /// Data class used to represent the state of theme.
  final AppTheme? appTheme;

  /// Idle state for the [SettingsBloc].
  const factory SettingsState.idle({Locale? locale, AppTheme? appTheme}) =
      _IdleSettingsState;

  /// Processing state for the [SettingsBloc].
  const factory SettingsState.processing({Locale? locale, AppTheme? appTheme}) =
      _ProcessingSettingsState;

  /// Error state for the [SettingsBloc].
  const factory SettingsState.error({
    required Object cause,
    Locale? locale,
    AppTheme? appTheme,
  }) = _ErrorSettingsState;
}

final class _IdleSettingsState extends SettingsState {
  const _IdleSettingsState({super.locale, super.appTheme});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _IdleSettingsState &&
        other.locale == locale &&
        other.appTheme == appTheme;
  }

  @override
  int get hashCode => Object.hash(locale, appTheme);

  @override
  String toString() =>
      'SettingsState.idle(locale: $locale, appTheme: $appTheme)';
}

final class _ProcessingSettingsState extends SettingsState {
  const _ProcessingSettingsState({super.locale, super.appTheme});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _ProcessingSettingsState &&
        other.locale == locale &&
        other.appTheme == appTheme;
  }

  @override
  int get hashCode => Object.hash(locale, appTheme);

  @override
  String toString() =>
      'SettingsState.processing(locale: $locale, appTheme: $appTheme)';
}

final class _ErrorSettingsState extends SettingsState {
  const _ErrorSettingsState({
    required this.cause,
    super.locale,
    super.appTheme,
  });

  /// The cause of the error.
  final Object cause;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _ErrorSettingsState &&
        other.cause == cause &&
        other.locale == locale &&
        other.appTheme == appTheme;
  }

  @override
  int get hashCode => Object.hash(cause, locale, appTheme);

  @override
  String toString() => 'SettingsState.error(cause: $cause, '
      'locale: $locale, appTheme: $appTheme)';
}

/// Events for the [SettingsBloc].
sealed class SettingsEvent {
  const SettingsEvent();

  /// Event to update theme.
  const factory SettingsEvent.updateTheme({required AppTheme appTheme}) =
      _UpdateThemeSettingsEvent;
}

final class _UpdateThemeSettingsEvent extends SettingsEvent {
  const _UpdateThemeSettingsEvent({required this.appTheme});

  /// The theme to update.
  final AppTheme appTheme;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _UpdateThemeSettingsEvent && other.appTheme == appTheme;
  }

  @override
  int get hashCode => appTheme.hashCode;

  @override
  String toString() => 'SettingsEvent.updateTheme(appTheme: $appTheme)';
}
