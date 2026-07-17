import 'package:flutter/material.dart';

/// Figma color system aligned with companion_platform.
abstract final class AppColors {
  // Brand (Green)
  static const brand50 = Color(0xFFF1FCF5);
  static const brand100 = Color(0xFFDEFAEA);
  static const brand200 = Color(0xFFC0F2D6);
  static const brand300 = Color(0xFF8EE7B6);
  static const brand400 = Color(0xFF55D38D);
  static const brand500 = Color(0xFF2EB96D);
  static const brand600 = Color(0xFF229E5A);
  static const brand700 = Color(0xFF1D7847);
  static const brand800 = Color(0xFF1C5F3B);
  static const brand900 = Color(0xFF194E32);

  // Yellow
  static const yellow50 = Color(0xFFFFFDEA);
  static const yellow100 = Color(0xFFFFF9C5);
  static const yellow200 = Color(0xFFFFF285);
  static const yellow300 = Color(0xFFFFE646);
  static const yellow400 = Color(0xFFFFD61B);
  static const yellow500 = Color(0xFFFFB900);
  static const yellow600 = Color(0xFFE28F00);
  static const yellow700 = Color(0xFFBB6402);
  static const yellow800 = Color(0xFF984D08);
  static const yellow900 = Color(0xFF7C3F0B);

  // Orange
  static const orange50 = Color(0xFFFFF5ED);
  static const orange100 = Color(0xFFFFE8D4);
  static const orange200 = Color(0xFFFFCDA8);
  static const orange300 = Color(0xFFFFAA71);
  static const orange400 = Color(0xFFFF803E);
  static const orange500 = Color(0xFFFE5811);
  static const orange600 = Color(0xFFEF3D07);
  static const orange700 = Color(0xFFC62B08);
  static const orange800 = Color(0xFF9D230F);
  static const orange900 = Color(0xFF7E2010);

  // Red
  static const red100 = Color(0xFFFFDFE1);
  static const red500 = Color(0xFFFF303F);
  static const red600 = Color(0xFFED1525);
  static const red700 = Color(0xFFC80D1B);

  // Blue
  static const blue100 = Color(0xFFDFF2FF);
  static const blue500 = Color(0xFF09A4EE);
  static const blue600 = Color(0xFF0084CC);
  static const blue700 = Color(0xFF0068A5);

  // Purple
  static const purple100 = Color(0xFFE9D5FF);
  static const purple500 = Color(0xFFA251FB);

  // Slate / Zinc
  static const slate900 = Color(0xFF0F172B);
  static const zinc50 = Color(0xFFFAFAFA);
  static const zinc100 = Color(0xFFF4F4F5);
  static const zinc200 = Color(0xFFE4E4E7);
  static const zinc300 = Color(0xFFD4D4D8);
  static const zinc400 = Color(0xFF9F9FA9);
  static const zinc500 = Color(0xFF71717B);
  static const zinc600 = Color(0xFF52525C);
  static const zinc700 = Color(0xFF3F3F46);
  static const zinc900 = Color(0xFF18181B);

  static const white = Color(0xFFFFFFFF);
  static const transparent = Colors.transparent;
  static const black10 = Color(0x1A000000);

  // Semantic tokens
  static const backgroundBase = white;
  static const backgroundSunken = zinc50;
  static const textPrimary = zinc900;
  static const textSecondary = zinc600;
  static const textPlaceholder = zinc500;
  static const textDisabled = zinc400;
  static const textBrand = brand700;
  static const textOrange = orange700;
  static const textOnSolidPrimary = white;
  static const iconBrand = brand500;
  static const iconOrange = orange500;
  static const iconDestructive = red500;
  static const borderDefault = zinc300;
  static const borderBrand = brand500;
  static const borderSuccess = Color(0xFF09DE5E);
  static const borderInfo = blue500;
  static const backgroundAccentLightBrand = brand100;
  static const backgroundAccentLightWarning = yellow100;
  static const backgroundAccentLightInfo = blue100;
  static const backgroundAccentLightOrange = orange100;
  static const backgroundAccentBoldBrand = brand600;
  static const success = Color(0xFF00C950);
  static const error = red500;

  // Story / kid UI (companion storytelling patterns)
  static const storyCardBorder = yellow500;
  static const storyCardShadow = yellow600;
  static const kidPanelBrown = yellow700;
  static const kidPanelCream = yellow100;
  static const strokeTitle = orange500;
  static const strokeTitleShadow = orange800;
  static const karaokeActive = orange700;
  static const karaokeDim = zinc500;
  static const imagePlaceholder = orange200;

  // Legacy aliases used across the app
  static const brandPrimary = brand500;
  static const brandSecondary = blue600;
  static const accentYellow = yellow500;
  static const accentYellowSoft = yellow200;
  static const accentYellowChip = yellow100;
  static const accentRed = red500;
  static const accentGreen = brand600;
  static const accentGreenSoft = brand100;
  static const accentPurple = purple500;
  static const accentPurpleSoft = purple100;
  static const backgroundCream = yellow100;
}
