import 'package:image_picker/image_picker.dart';

class MockImageService {
  MockImageService({
    ImagePicker? imagePicker,
  }) : _imagePicker = imagePicker ?? ImagePicker();

  final ImagePicker _imagePicker;

  Future<XFile?> pickImage() async {
    return _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );
  }

  Future<void> fakeGenerate() async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));
  }
}
