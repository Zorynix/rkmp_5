import 'package:flutter/material.dart';
import 'package:prac5/app.dart';
import 'package:prac5/core/di/service_locator.dart';
import 'package:prac5/services/logger_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupServiceLocator();

  Services.image.preloadImagePool().catchError((e) {
    LoggerService.warning('Предзагрузка изображений не удалась (возможно, нет интернета): $e');
  });

  runApp(const MyApp());
}
