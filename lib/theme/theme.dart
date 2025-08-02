import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static MaterialScheme lightScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff326940),
      surfaceTint: Color(0xff326940),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffb5f1bd),
      onPrimaryContainer: Color(0xff00210b),
      secondary: Color(0xff506352),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffd3e8d2),
      onSecondaryContainer: Color(0xff0e1f12),
      tertiary: Color(0xff3a656e),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffbdeaf4),
      onTertiaryContainer: Color(0xff001f25),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      background: Color(0xfff6fbf2),
      onBackground: Color(0xff181d18),
      surface: Color(0xfff6fbf2),
      onSurface: Color(0xff181d18),
      surfaceVariant: Color(0xffdde5da),
      onSurfaceVariant: Color(0xff414941),
      outline: Color(0xff717970),
      outlineVariant: Color(0xffc1c9be),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d322c),
      inverseOnSurface: Color(0xffeef2ea),
      inversePrimary: Color(0xff99d4a2),
      primaryFixed: Color(0xffb5f1bd),
      onPrimaryFixed: Color(0xff00210b),
      primaryFixedDim: Color(0xff99d4a2),
      onPrimaryFixedVariant: Color(0xff18512b),
      secondaryFixed: Color(0xffd3e8d2),
      onSecondaryFixed: Color(0xff0e1f12),
      secondaryFixedDim: Color(0xffb7ccb7),
      onSecondaryFixedVariant: Color(0xff394b3b),
      tertiaryFixed: Color(0xffbdeaf4),
      onTertiaryFixed: Color(0xff001f25),
      tertiaryFixedDim: Color(0xffa2ced8),
      onTertiaryFixedVariant: Color(0xff204d55),
      surfaceDim: Color(0xffd7dbd3),
      surfaceBright: Color(0xfff6fbf2),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f5ed),
      surfaceContainer: Color(0xffebefe7),
      surfaceContainerHigh: Color(0xffe5eae1),
      surfaceContainerHighest: Color(0xffdfe4dc),
    );
  }

  ThemeData light() {
    return theme(lightScheme().toColorScheme());
  }

  static MaterialScheme lightMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff134d27),
      surfaceTint: Color(0xff326940),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff498055),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff354737),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff667967),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff1b4951),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff507b84),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      background: Color(0xfff6fbf2),
      onBackground: Color(0xff181d18),
      surface: Color(0xfff6fbf2),
      onSurface: Color(0xff181d18),
      surfaceVariant: Color(0xffdde5da),
      onSurfaceVariant: Color(0xff3d453d),
      outline: Color(0xff596159),
      outlineVariant: Color(0xff757d74),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d322c),
      inverseOnSurface: Color(0xffeef2ea),
      inversePrimary: Color(0xff99d4a2),
      primaryFixed: Color(0xff498055),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff30673e),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff667967),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff4e614f),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff507b84),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff37626b),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd7dbd3),
      surfaceBright: Color(0xfff6fbf2),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f5ed),
      surfaceContainer: Color(0xffebefe7),
      surfaceContainerHigh: Color(0xffe5eae1),
      surfaceContainerHighest: Color(0xffdfe4dc),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme lightHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff00290f),
      surfaceTint: Color(0xff326940),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff134d27),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff152618),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff354737),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff00272d),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff1b4951),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      background: Color(0xfff6fbf2),
      onBackground: Color(0xff181d18),
      surface: Color(0xfff6fbf2),
      onSurface: Color(0xff000000),
      surfaceVariant: Color(0xffdde5da),
      onSurfaceVariant: Color(0xff1f261f),
      outline: Color(0xff3d453d),
      outlineVariant: Color(0xff3d453d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d322c),
      inverseOnSurface: Color(0xffffffff),
      inversePrimary: Color(0xffbefbc6),
      primaryFixed: Color(0xff134d27),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff003515),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff354737),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff1f3122),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff1b4951),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff00323a),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd7dbd3),
      surfaceBright: Color(0xfff6fbf2),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f5ed),
      surfaceContainer: Color(0xffebefe7),
      surfaceContainerHigh: Color(0xffe5eae1),
      surfaceContainerHighest: Color(0xffdfe4dc),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme().toColorScheme());
  }

  static MaterialScheme darkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xff99d4a2),
      surfaceTint: Color(0xff99d4a2),
      onPrimary: Color(0xff003918),
      primaryContainer: Color(0xff18512b),
      onPrimaryContainer: Color(0xffb5f1bd),
      secondary: Color(0xffb7ccb7),
      onSecondary: Color(0xff233426),
      secondaryContainer: Color(0xff394b3b),
      onSecondaryContainer: Color(0xffd3e8d2),
      tertiary: Color(0xffa2ced8),
      onTertiary: Color(0xff01363e),
      tertiaryContainer: Color(0xff204d55),
      onTertiaryContainer: Color(0xffbdeaf4),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      background: Color(0xff101510),
      onBackground: Color(0xffdfe4dc),
      surface: Color(0xff101510),
      onSurface: Color(0xffdfe4dc),
      surfaceVariant: Color(0xff414941),
      onSurfaceVariant: Color(0xffc1c9be),
      outline: Color(0xff8b9389),
      outlineVariant: Color(0xff414941),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe4dc),
      inverseOnSurface: Color(0xff2d322c),
      inversePrimary: Color(0xff326940),
      primaryFixed: Color(0xffb5f1bd),
      onPrimaryFixed: Color(0xff00210b),
      primaryFixedDim: Color(0xff99d4a2),
      onPrimaryFixedVariant: Color(0xff18512b),
      secondaryFixed: Color(0xffd3e8d2),
      onSecondaryFixed: Color(0xff0e1f12),
      secondaryFixedDim: Color(0xffb7ccb7),
      onSecondaryFixedVariant: Color(0xff394b3b),
      tertiaryFixed: Color(0xffbdeaf4),
      onTertiaryFixed: Color(0xff001f25),
      tertiaryFixedDim: Color(0xffa2ced8),
      onTertiaryFixedVariant: Color(0xff204d55),
      surfaceDim: Color(0xff101510),
      surfaceBright: Color(0xff353a35),
      surfaceContainerLowest: Color(0xff0b0f0b),
      surfaceContainerLow: Color(0xff181d18),
      surfaceContainer: Color(0xff1c211c),
      surfaceContainerHigh: Color(0xff262b26),
      surfaceContainerHighest: Color(0xff313631),
    );
  }

  ThemeData dark() {
    return theme(darkScheme().toColorScheme());
  }

  static MaterialScheme darkMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xff9dd9a6),
      surfaceTint: Color(0xff99d4a2),
      onPrimary: Color(0xff001b08),
      primaryContainer: Color(0xff659d6f),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffbbd0bb),
      onSecondary: Color(0xff091a0d),
      secondaryContainer: Color(0xff829682),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffa6d2dc),
      onTertiary: Color(0xff001a1e),
      tertiaryContainer: Color(0xff6c98a1),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      background: Color(0xff101510),
      onBackground: Color(0xffdfe4dc),
      surface: Color(0xff101510),
      onSurface: Color(0xfff8fcf4),
      surfaceVariant: Color(0xff414941),
      onSurfaceVariant: Color(0xffc5cdc3),
      outline: Color(0xff9da59b),
      outlineVariant: Color(0xff7d857c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe4dc),
      inverseOnSurface: Color(0xff262b26),
      inversePrimary: Color(0xff1a522c),
      primaryFixed: Color(0xffb5f1bd),
      onPrimaryFixed: Color(0xff001506),
      primaryFixedDim: Color(0xff99d4a2),
      onPrimaryFixedVariant: Color(0xff01401b),
      secondaryFixed: Color(0xffd3e8d2),
      onSecondaryFixed: Color(0xff041508),
      secondaryFixedDim: Color(0xffb7ccb7),
      onSecondaryFixedVariant: Color(0xff293a2b),
      tertiaryFixed: Color(0xffbdeaf4),
      onTertiaryFixed: Color(0xff001418),
      tertiaryFixedDim: Color(0xffa2ced8),
      onTertiaryFixedVariant: Color(0xff093c44),
      surfaceDim: Color(0xff101510),
      surfaceBright: Color(0xff353a35),
      surfaceContainerLowest: Color(0xff0b0f0b),
      surfaceContainerLow: Color(0xff181d18),
      surfaceContainer: Color(0xff1c211c),
      surfaceContainerHigh: Color(0xff262b26),
      surfaceContainerHighest: Color(0xff313631),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme darkHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xfff0ffed),
      surfaceTint: Color(0xff99d4a2),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff9dd9a6),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfff0ffed),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffbbd0bb),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfff3fcff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffa6d2dc),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      background: Color(0xff101510),
      onBackground: Color(0xffdfe4dc),
      surface: Color(0xff101510),
      onSurface: Color(0xffffffff),
      surfaceVariant: Color(0xff414941),
      onSurfaceVariant: Color(0xfff5fdf2),
      outline: Color(0xffc5cdc3),
      outlineVariant: Color(0xffc5cdc3),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe4dc),
      inverseOnSurface: Color(0xff000000),
      inversePrimary: Color(0xff003214),
      primaryFixed: Color(0xffb9f5c1),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff9dd9a6),
      onPrimaryFixedVariant: Color(0xff001b08),
      secondaryFixed: Color(0xffd7edd6),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffbbd0bb),
      onSecondaryFixedVariant: Color(0xff091a0d),
      tertiaryFixed: Color(0xffc1eef9),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffa6d2dc),
      onTertiaryFixedVariant: Color(0xff001a1e),
      surfaceDim: Color(0xff101510),
      surfaceBright: Color(0xff353a35),
      surfaceContainerLowest: Color(0xff0b0f0b),
      surfaceContainerLow: Color(0xff181d18),
      surfaceContainer: Color(0xff1c211c),
      surfaceContainerHigh: Color(0xff262b26),
      surfaceContainerHighest: Color(0xff313631),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme().toColorScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );

  /// Custom Color 1
  static const customColor1 = ExtendedColor(
    seed: Color(0xff2e8bfb),
    value: Color(0xff2e8bfb),
    light: ColorFamily(
      color: Color(0xff3f5f90),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffd6e3ff),
      onColorContainer: Color(0xff001b3d),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff3f5f90),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffd6e3ff),
      onColorContainer: Color(0xff001b3d),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff3f5f90),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffd6e3ff),
      onColorContainer: Color(0xff001b3d),
    ),
    dark: ColorFamily(
      color: Color(0xffa9c8ff),
      onColor: Color(0xff07305f),
      colorContainer: Color(0xff264777),
      onColorContainer: Color(0xffd6e3ff),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xffa9c8ff),
      onColor: Color(0xff07305f),
      colorContainer: Color(0xff264777),
      onColorContainer: Color(0xffd6e3ff),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xffa9c8ff),
      onColor: Color(0xff07305f),
      colorContainer: Color(0xff264777),
      onColorContainer: Color(0xffd6e3ff),
    ),
  );

  List<ExtendedColor> get extendedColors => [
        customColor1,
      ];
}

class MaterialScheme {
  const MaterialScheme({
    required this.brightness,
    required this.primary,
    required this.surfaceTint,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
    required this.inverseSurface,
    required this.inverseOnSurface,
    required this.inversePrimary,
    required this.primaryFixed,
    required this.onPrimaryFixed,
    required this.primaryFixedDim,
    required this.onPrimaryFixedVariant,
    required this.secondaryFixed,
    required this.onSecondaryFixed,
    required this.secondaryFixedDim,
    required this.onSecondaryFixedVariant,
    required this.tertiaryFixed,
    required this.onTertiaryFixed,
    required this.tertiaryFixedDim,
    required this.onTertiaryFixedVariant,
    required this.surfaceDim,
    required this.surfaceBright,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
  });

  final Brightness brightness;
  final Color primary;
  final Color surfaceTint;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color inversePrimary;
  final Color primaryFixed;
  final Color onPrimaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixedVariant;
  final Color secondaryFixed;
  final Color onSecondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixedVariant;
  final Color tertiaryFixed;
  final Color onTertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixedVariant;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
}

extension MaterialSchemeUtils on MaterialScheme {
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      surface: surface,
      onSurface: onSurface,
      surfaceContainerHighest: surfaceVariant,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: shadow,
      scrim: scrim,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
    );
  }
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
