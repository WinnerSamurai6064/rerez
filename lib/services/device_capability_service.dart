import 'package:flutter/foundation.dart';

enum DeviceUpscaleTier {
  veryWeak,
  weak,
  strong,
}

class DeviceCapabilityResult {
  const DeviceCapabilityResult({
    required this.tier,
    required this.defaultMethod,
    required this.allowLocalLanczos,
    required this.allowLocalRealEsrganX2,
    required this.allowLocalRealEsrganX4,
    required this.allowBackendFallback,
    required this.note,
  });

  final DeviceUpscaleTier tier;
  final String defaultMethod;
  final bool allowLocalLanczos;
  final bool allowLocalRealEsrganX2;
  final bool allowLocalRealEsrganX4;
  final bool allowBackendFallback;
  final String note;
}

class DeviceCapabilityService {
  const DeviceCapabilityService();

  DeviceCapabilityResult detect() {
    if (kIsWeb) {
      return const DeviceCapabilityResult(
        tier: DeviceUpscaleTier.weak,
        defaultMethod: 'Real-ESRGAN',
        allowLocalLanczos: true,
        allowLocalRealEsrganX2: true,
        allowLocalRealEsrganX4: false,
        allowBackendFallback: true,
        note: 'Web device detected. Local x2 preferred where supported.',
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return const DeviceCapabilityResult(
          tier: DeviceUpscaleTier.strong,
          defaultMethod: 'Real-ESRGAN',
          allowLocalLanczos: true,
          allowLocalRealEsrganX2: true,
          allowLocalRealEsrganX4: true,
          allowBackendFallback: true,
          note: 'iOS device detected. Local processing preferred.',
        );

      case TargetPlatform.android:
        return const DeviceCapabilityResult(
          tier: DeviceUpscaleTier.weak,
          defaultMethod: 'Real-ESRGAN',
          allowLocalLanczos: true,
          allowLocalRealEsrganX2: true,
          allowLocalRealEsrganX4: false,
          allowBackendFallback: true,
          note: 'Android device detected. Local x2 preferred where supported.',
        );

      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return const DeviceCapabilityResult(
          tier: DeviceUpscaleTier.strong,
          defaultMethod: 'Real-ESRGAN',
          allowLocalLanczos: true,
          allowLocalRealEsrganX2: true,
          allowLocalRealEsrganX4: true,
          allowBackendFallback: true,
          note: 'Desktop device detected. Full local processing preferred.',
        );

      default:
        return const DeviceCapabilityResult(
          tier: DeviceUpscaleTier.veryWeak,
          defaultMethod: 'Lanczos',
          allowLocalLanczos: true,
          allowLocalRealEsrganX2: false,
          allowLocalRealEsrganX4: false,
          allowBackendFallback: true,
          note: 'Unknown device detected. Lanczos is the safe default.',
        );
    }
  }

  bool shouldUseBackendFallback({
    required String method,
    required String scale,
    required DeviceCapabilityResult capability,
  }) {
    if (method == 'Lanczos') {
      return false;
    }

    if (method == 'Real-ESRGAN' && scale == 'x2') {
      return !capability.allowLocalRealEsrganX2;
    }

    if (method == 'Real-ESRGAN' && scale == 'x4') {
      return !capability.allowLocalRealEsrganX4;
    }

    return capability.allowBackendFallback;
  }
}
