import 'package:get_it/get_it.dart';
import 'package:prac5/services/image_service.dart';
import 'package:prac5/services/theme_service.dart';
import 'package:prac5/services/profile_service.dart';
import 'package:prac5/services/auth_service.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {

  getIt.registerSingleton<ImageService>(ImageService());

  await getIt<ImageService>().initialize();

  getIt.registerSingleton<ThemeService>(ThemeService());

  getIt.registerSingleton<ProfileService>(ProfileService());

  getIt.registerSingleton<AuthService>(AuthService());

}

class Services {
  static ImageService get image => getIt<ImageService>();
  static ThemeService get theme => getIt<ThemeService>();
  static ProfileService get profile => getIt<ProfileService>();
  static AuthService get auth => getIt<AuthService>();
}

