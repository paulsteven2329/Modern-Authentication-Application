import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;
  final bool isDark;

  const ThemeState({
    this.themeMode = ThemeMode.dark,
    this.isDark = true,
  });

  ThemeState copyWith({
    ThemeMode? themeMode,
    bool? isDark,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  List<Object> get props => [themeMode, isDark];
}