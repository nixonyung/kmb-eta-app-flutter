import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:google_fonts/google_fonts.dart';

final lightThemeData = FlexThemeData.light(
  scheme: FlexScheme.redWine,
  surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
  blendLevel: 20,
  appBarOpacity: 0.95,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 20,
    blendOnColors: false,
    bottomNavigationBarSelectedLabelSchemeColor: SchemeColor.onPrimary,
    bottomNavigationBarUnselectedLabelSchemeColor: SchemeColor.onSecondary,
    bottomNavigationBarSelectedIconSchemeColor: SchemeColor.onPrimary,
    bottomNavigationBarUnselectedIconSchemeColor: SchemeColor.onSecondary,
    bottomNavigationBarBackgroundSchemeColor: SchemeColor.primary,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  fontFamily: GoogleFonts.notoSans().fontFamily,
);

final darkThemeData = FlexThemeData.dark(
  scheme: FlexScheme.redWine,
  surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
  blendLevel: 15,
  appBarStyle: FlexAppBarStyle.primary,
  appBarOpacity: 0.90,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 30,
    bottomNavigationBarSelectedLabelSchemeColor: SchemeColor.onPrimary,
    bottomNavigationBarUnselectedLabelSchemeColor: SchemeColor.onSecondary,
    bottomNavigationBarSelectedIconSchemeColor: SchemeColor.onPrimary,
    bottomNavigationBarUnselectedIconSchemeColor: SchemeColor.onSecondary,
    bottomNavigationBarBackgroundSchemeColor: SchemeColor.primary,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  fontFamily: GoogleFonts.notoSans().fontFamily,
);
