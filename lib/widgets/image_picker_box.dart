import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../app/theme.dart';
import 'glass_panel.dart';

class ImagePickerBox extends StatelessWidget {
  const ImagePickerBox({
    super.key,
    required this.imageBytes,
    required this.onSelectImage,
    required this.onClearImage,
  });

  final Uint8List? imageBytes;
  final VoidCallback onSelectImage;
  final VoidCallback onClearImage;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageBytes != null;

    return GlassPanel(
      padding: EdgeInsets.zero,
      borderRadius: 30,
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                child: hasImage
                    ? ClipRRect(
                        key: const ValueKey('selected-image'),
                        borderRadius: BorderRadius.circular(30),
                        child: Image.memory(
                          imageBytes!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      )
                    : _ImagePlaceholder(
                        key: const ValueKey('image-placeholder'),
                        onSelectImage: onSelectImage,
                      ),
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onSelectImage,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            if (hasImage)
              Positioned(
                top: 12,
                right: 12,
                child: Material(
                  color: Colors.black.withOpacity(0.58),
                  borderRadius: BorderRadius.circular(999),
                  child: InkWell(
                    onTap: onClearImage,
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.16),
                        ),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: RerezTheme.neonWhite,
                        size: 21,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({
    super.key,
    required this.onSelectImage,
  });

  final VoidCallback onSelectImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: RerezTheme.panelBlack.withOpacity(0.72),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: RerezTheme.orange.withOpacity(0.13),
                  border: Border.all(
                    color: RerezTheme.orange.withOpacity(0.42),
                  ),
                ),
                child: const Icon(
                  Icons.add_photo_alternate_rounded,
                  color: RerezTheme.orange,
                  size: 34,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Select Image',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: RerezTheme.neonWhite,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose a photo from your device',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: RerezTheme.softWhite,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
