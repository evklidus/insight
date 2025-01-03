import 'package:insight/src/features/settings/data/theme_datasource.dart';
import 'package:insight/src/features/app/model/app_theme.dart';

/// Theme repository that persists and retrieves theme information
abstract interface class ThemeRepository {
  /// Get theme
  Future<AppTheme?> getTheme();

  /// Set theme
  Future<void> setTheme(AppTheme theme);
}

/// Theme repository implementation
final class ThemeRepositoryImpl implements ThemeRepository {
  /// Create theme repository
  const ThemeRepositoryImpl({required ThemeDataSource themeDataSource})
      : _themeDataSource = themeDataSource;

  final ThemeDataSource _themeDataSource;

  @override
  Future<AppTheme?> getTheme() => _themeDataSource.getTheme();

  @override
  Future<void> setTheme(AppTheme theme) => _themeDataSource.setTheme(theme);
}
