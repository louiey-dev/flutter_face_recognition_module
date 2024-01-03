import 'package:face_recognition_module/common/data/app_preferences.dart';
import 'package:face_recognition_module/common/theme/custom_theme.dart';

class Prefs {
  static final appTheme =
      PreferenceItem<CustomTheme>('appTheme', CustomTheme.light);
}
