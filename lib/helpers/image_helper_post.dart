import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageHelperPost {
  ImageHelperPost({
    ImagePicker? imagePicker,
    ImageCropper? imageCropper,
  })  : _imagePicker = imagePicker ?? ImagePicker(),
        _imageCropper = imageCropper ?? ImageCropper();

  final ImagePicker _imagePicker;
  final ImageCropper _imageCropper;

  Future<XFile?> pickImage({
    // required BuildContext context,
    ImageSource source = ImageSource.gallery,
    int imageQuality = 50,
  }) async {
    return await _imagePicker.pickImage(
        source: source, imageQuality: imageQuality);
  }

  Future<CroppedFile?> crop({
    required XFile file,
    required CropStyle cropStyle,
  }) async =>
      await _imageCropper.cropImage(
        cropStyle: cropStyle,
        sourcePath: file.path,
        compressQuality: 50,
        aspectRatio: const CropAspectRatio(ratioX: 0.7, ratioY: 1.0),
      );
}
