import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Shop Manager palette — warm off-white with ink text and a bronze accent.
class AppColors {
  AppColors._();

  static const background = Color(0xFFFBF8F3);
  static const surface = Color(0xFFFFFFFF);
  static const raised = Color(0xFFF4EEE4);
  static const border = Color(0xFFECE5D8);
  static const borderStrong = Color(0xFFDDD3C2);
  static const rowDivider = Color(0xFFF1EBE0);

  static const ink = Color(0xFF1F1B16);
  static const textSecondary = Color(0xFF5A5045);
  static const muted = Color(0xFF6B6052);

  static const accent = Color(0xFF7A5A22);
  static const success = Color(0xFF2B7A3D);
  static const warning = accent;
  static const warningBackground = raised;
  static const error = Color(0xFFB42318);
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.ink,
      onPrimary: Colors.white,
      secondary: AppColors.accent,
      onSecondary: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.ink,
      onSurfaceVariant: AppColors.textSecondary,
      surfaceContainerHighest: AppColors.raised,
      outline: AppColors.borderStrong,
      outlineVariant: AppColors.border,
      error: AppColors.error,
      onError: Colors.white,
    );

    final base = ThemeData(useMaterial3: true, colorScheme: colorScheme);
    final textTheme = _textTheme(base.textTheme);

    const pill = StadiumBorder();
    const buttonSize = Size(64, 48);
    const buttonPadding = EdgeInsets.symmetric(horizontal: 24);
    final buttonText = textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w600,
    );

    OutlineInputBorder inputBorder(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: width),
        );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
      textTheme: textTheme,
      dividerColor: AppColors.border,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
        shape: const Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.ink,
          foregroundColor: Colors.white,
          minimumSize: buttonSize,
          padding: buttonPadding,
          shape: pill,
          textStyle: buttonText,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.ink,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: buttonSize,
          padding: buttonPadding,
          shape: pill,
          textStyle: buttonText,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink,
          minimumSize: buttonSize,
          padding: buttonPadding,
          shape: pill,
          side: const BorderSide(color: AppColors.borderStrong),
          textStyle: buttonText,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accent,
          textStyle: buttonText,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: inputBorder(AppColors.borderStrong),
        enabledBorder: inputBorder(AppColors.borderStrong),
        focusedBorder: inputBorder(AppColors.ink, 1.5),
        errorBorder: inputBorder(AppColors.error),
        focusedErrorBorder: inputBorder(AppColors.error, 1.5),
        labelStyle: textTheme.bodyMedium?.copyWith(color: AppColors.muted),
        hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.muted),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.raised,
        selectedColor: AppColors.border,
        side: BorderSide.none,
        labelStyle: textTheme.labelMedium?.copyWith(color: AppColors.ink),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.ink,
        unselectedLabelColor: AppColors.muted,
        labelStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: textTheme.labelLarge,
        indicatorColor: AppColors.ink,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: AppColors.ink, width: 3),
        ),
        dividerColor: AppColors.border,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.ink,
        foregroundColor: Colors.white,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 2,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.ink,
        contentTextStyle:
            textTheme.bodyMedium?.copyWith(color: Colors.white),
        actionTextColor: AppColors.raised,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// DM Sans everywhere; Cormorant Garamond (500) for display, headline and
  /// title-large.
  static TextTheme _textTheme(TextTheme base) {
    final body = GoogleFonts.dmSansTextTheme(base).apply(
      bodyColor: AppColors.ink,
      displayColor: AppColors.ink,
    );
    TextStyle? serif(TextStyle? s) => GoogleFonts.cormorantGaramond(
          textStyle: s,
          fontWeight: FontWeight.w500,
          color: AppColors.ink,
        );
    return body.copyWith(
      displayLarge: serif(body.displayLarge),
      displayMedium: serif(body.displayMedium),
      displaySmall: serif(body.displaySmall),
      headlineLarge: serif(body.headlineLarge),
      headlineMedium: serif(body.headlineMedium),
      headlineSmall: serif(body.headlineSmall),
      titleLarge: serif(body.titleLarge),
    );
  }
}
