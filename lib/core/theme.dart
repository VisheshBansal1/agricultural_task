import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  static const primary = Color(0xFF14532B);
  static const primaryDark = Color(0xFF0B3A1D);
  static const secondary = Color(0xFF4CAF50);
  static const accent = Color(0xFFF5A623);
  static const accentDeep = Color(0xFFE08900);
  static const background = Color(0xFFFAF7F0);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceTint = Color(0xFFF1F6ED);
  static const textDark = Color(0xFF15201A);
  static const success = Color(0xFF1E8E3E);
  static const warning = Color(0xFFB07A0A);
  static const error = Color(0xFFC0392B);
  static const info = Color(0xFF1565C0);

  static const mutedGray = Color(0xFF888F86);
  static const cardBorder = Color(0xFFEAE4D6);

  static const Map<String, Color> categoryAccents = {
    'tractor': Color(0xFFDD6B20),
    'truck': Color(0xFF2B6CB0),
    'harvester': Color(0xFFB7791F),
    'equipment': Color(0xFF319795),
    'irrigation': Color(0xFF2C7A7B),
    'land': Color(0xFF6B8E23),
    'tools': Color(0xFF6B46C1),
    'more': Color(0xFF4A5568),
  };

  static Color categoryAccent(String id) => categoryAccents[id] ?? primary;
}

class AppGradients {
  AppGradients._();

  static const hero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primaryDark, AppColors.primary, AppColors.secondary],
    stops: [0.0, 0.55, 1.0],
  );

  static const heroSubtle = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primary, AppColors.secondary],
  );

  static const gold = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.accent, AppColors.accentDeep],
  );

  static const imagePlaceholder = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE7F2E2), Color(0xFFCFE8C6)],
  );

  static LinearGradient scrim({double opacity = 0.55}) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.transparent, Colors.black.withOpacity(opacity)],
      );
}

class AppRadii {
  AppRadii._();
  static const card = 20.0;
  static const cardLg = 26.0;
  static const button = 14.0;
  static const chip = 24.0;
  static const field = 14.0;
  static const pill = 100.0;
}

class AppSpacing {
  AppSpacing._();
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const navClearance = 100.0;
}

class AppShadows {
  AppShadows._();

  static List<BoxShadow> card = [
    BoxShadow(
      color: AppColors.textDark.withOpacity(0.07),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> subtle = [
    BoxShadow(
      color: AppColors.textDark.withOpacity(0.05),
      blurRadius: 10,
      offset: const Offset(0, 3),
    ),
  ];

  static List<BoxShadow> glow(Color color, {double opacity = 0.35}) => [
        BoxShadow(
          color: color.withOpacity(opacity),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ];
}

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);

    final headingFont = GoogleFonts.sora;
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(base.textTheme).copyWith(
      headlineLarge: headingFont(fontSize: 30, fontWeight: FontWeight.w700, color: AppColors.textDark, height: 1.15, letterSpacing: -0.5),
      headlineMedium: headingFont(fontSize: 25, fontWeight: FontWeight.w700, color: AppColors.textDark, height: 1.2, letterSpacing: -0.3),
      titleLarge: headingFont(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textDark),
      titleMedium: headingFont(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textDark),
      titleSmall: headingFont(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textDark),
      bodyLarge: GoogleFonts.plusJakartaSans(fontSize: 16, color: AppColors.textDark, height: 1.4),
      bodyMedium: GoogleFonts.plusJakartaSans(fontSize: 14, color: AppColors.textDark, height: 1.4),
      labelLarge: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.1),
      bodySmall: GoogleFonts.plusJakartaSans(fontSize: 12.5, color: AppColors.mutedGray, height: 1.35),
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      splashFactory: InkRipple.splashFactory,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
        surface: AppColors.background,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: headingFont(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textDark),
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.card)),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.field),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.field),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.field),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.field),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: GoogleFonts.plusJakartaSans(color: AppColors.mutedGray, fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.button)),
          textStyle: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w600),
          elevation: 0,
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: Colors.white,
        selectedColor: AppColors.secondary.withOpacity(0.15),
        labelStyle: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppColors.textDark),
        side: const BorderSide(color: AppColors.secondary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.chip)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.mutedGray,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      dividerColor: AppColors.cardBorder,
    );
  }
}
