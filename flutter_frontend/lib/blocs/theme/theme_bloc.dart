import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../services/storage_service.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState()) {
    on<ThemeInitialized>(_onThemeInitialized);
    on<ThemeToggleRequested>(_onThemeToggleRequested);
    on<ThemeChanged>(_onThemeChanged);
  }

  Future<void> _onThemeInitialized(
    ThemeInitialized event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      final savedTheme = await StorageService.getThemeMode();
      final themeMode = _stringToThemeMode(savedTheme);
      emit(state.copyWith(
        themeMode: themeMode,
        isDark: themeMode == ThemeMode.dark,
      ));
    } catch (e) {
      // Default to dark theme if there's an error
      emit(state.copyWith(
        themeMode: ThemeMode.dark,
        isDark: true,
      ));
    }
  }

  Future<void> _onThemeToggleRequested(
    ThemeToggleRequested event,
    Emitter<ThemeState> emit,
  ) async {
    final newThemeMode = state.isDark ? ThemeMode.light : ThemeMode.dark;
    final newIsDark = !state.isDark;

    // Save to storage
    await StorageService.saveThemeMode(_themeModeToString(newThemeMode));

    emit(state.copyWith(
      themeMode: newThemeMode,
      isDark: newIsDark,
    ));
  }

  Future<void> _onThemeChanged(
    ThemeChanged event,
    Emitter<ThemeState> emit,
  ) async {
    // Save to storage
    await StorageService.saveThemeMode(_themeModeToString(event.themeMode));

    emit(state.copyWith(
      themeMode: event.themeMode,
      isDark: event.themeMode == ThemeMode.dark,
    ));
  }

  ThemeMode _stringToThemeMode(String themeString) {
    switch (themeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.dark;
    }
  }

  String _themeModeToString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}