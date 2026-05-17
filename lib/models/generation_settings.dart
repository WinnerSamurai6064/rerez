enum ScaleOption {
  x2,
  x4,
  custom,
}

enum ProcessingMethod {
  lanczos,
  realEsrgan,
}

enum ColorProfile {
  srgb,
  adobeRgb,
  appleRgb,
}

enum FilterOption {
  none,
  grainy,
  colorCorrection,
  softContrast,
  sharpDetail,
  warmTone,
  coolTone,
  portraitClean,
  cinematic,
}

enum SaveFormat {
  png,
  jpg,
}

extension ScaleOptionLabel on ScaleOption {
  String get label {
    switch (this) {
      case ScaleOption.x2:
        return 'x2';
      case ScaleOption.x4:
        return 'x4';
      case ScaleOption.custom:
        return 'Custom';
    }
  }
}

extension ProcessingMethodLabel on ProcessingMethod {
  String get label {
    switch (this) {
      case ProcessingMethod.lanczos:
        return 'Lanczos';
      case ProcessingMethod.realEsrgan:
        return 'Real-ESRGAN';
    }
  }
}

extension ColorProfileLabel on ColorProfile {
  String get label {
    switch (this) {
      case ColorProfile.srgb:
        return 'sRGB';
      case ColorProfile.adobeRgb:
        return 'Adobe RGB';
      case ColorProfile.appleRgb:
        return 'Apple RGB';
    }
  }
}

extension FilterOptionLabel on FilterOption {
  String get label {
    switch (this) {
      case FilterOption.none:
        return 'None';
      case FilterOption.grainy:
        return 'Grainy';
      case FilterOption.colorCorrection:
        return 'Color Correction';
      case FilterOption.softContrast:
        return 'Soft Contrast';
      case FilterOption.sharpDetail:
        return 'Sharp Detail';
      case FilterOption.warmTone:
        return 'Warm Tone';
      case FilterOption.coolTone:
        return 'Cool Tone';
      case FilterOption.portraitClean:
        return 'Portrait Clean';
      case FilterOption.cinematic:
        return 'Cinematic';
    }
  }
}

extension SaveFormatLabel on SaveFormat {
  String get label {
    switch (this) {
      case SaveFormat.png:
        return 'PNG';
      case SaveFormat.jpg:
        return 'JPG';
    }
  }
}

class GenerationSettings {
  const GenerationSettings({
    this.scale = ScaleOption.x2,
    this.method = ProcessingMethod.realEsrgan,
    this.colorProfile = ColorProfile.srgb,
    this.filter = FilterOption.none,
    this.saveFormat = SaveFormat.png,
  });

  final ScaleOption scale;
  final ProcessingMethod method;
  final ColorProfile colorProfile;
  final FilterOption filter;
  final SaveFormat saveFormat;

  GenerationSettings copyWith({
    ScaleOption? scale,
    ProcessingMethod? method,
    ColorProfile? colorProfile,
    FilterOption? filter,
    SaveFormat? saveFormat,
  }) {
    return GenerationSettings(
      scale: scale ?? this.scale,
      method: method ?? this.method,
      colorProfile: colorProfile ?? this.colorProfile,
      filter: filter ?? this.filter,
      saveFormat: saveFormat ?? this.saveFormat,
    );
  }
}
