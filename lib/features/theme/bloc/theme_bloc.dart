import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:prac5/features/theme/bloc/theme_event.dart';
import 'package:prac5/features/theme/bloc/theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prac5/services/logger_service.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _themeKey = 'theme_mode';

  ThemeBloc() : super(const ThemeInitial()) {
    on<LoadTheme>(_onLoadTheme);
    on<ToggleTheme>(_onToggleTheme);
    on<SetThemeMode>(_onSetThemeMode);
  }

  Future<void> _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool(_themeKey) ?? false;
      final themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      emit(ThemeLoaded(themeMode));
      LoggerService.info('Тема загружена: ${isDark ? "темная" : "светлая"}');
    } catch (e) {
      LoggerService.error('Ошибка загрузки темы: $e');
      emit(const ThemeLoaded(ThemeMode.light));
    }
  }

  Future<void> _onToggleTheme(ToggleTheme event, Emitter<ThemeState> emit) async {
    try {
      if (state is ThemeLoaded) {
        final currentState = state as ThemeLoaded;
        final newThemeMode = currentState.themeMode == ThemeMode.light
            ? ThemeMode.dark
            : ThemeMode.light;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_themeKey, newThemeMode == ThemeMode.dark);

        emit(ThemeLoaded(newThemeMode));
        LoggerService.info('Тема переключена на: ${newThemeMode == ThemeMode.dark ? "темную" : "светлую"}');
      }
    } catch (e) {
      LoggerService.error('Ошибка переключения темы: $e');
    }
  }

  Future<void> _onSetThemeMode(SetThemeMode event, Emitter<ThemeState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, event.themeMode == ThemeMode.dark);

      emit(ThemeLoaded(event.themeMode));
      LoggerService.info('Тема установлена: ${event.themeMode == ThemeMode.dark ? "темная" : "светлая"}');
    } catch (e) {
      LoggerService.error('Ошибка установки темы: $e');
    }
  }
}

