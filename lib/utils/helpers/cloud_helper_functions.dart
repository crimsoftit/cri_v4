import 'package:cri_v3/features/personalization/screens/data_error/data_error.dart';
import 'package:cri_v3/features/personalization/screens/no_data/no_data_screen.dart';
import 'package:cri_v3/utils/constants/img_strings.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CCloudHelperFunctions extends GetxController {
  static CCloudHelperFunctions get instance =>
      Get.find<CCloudHelperFunctions>();

  /// helper function to check the state of a single db record
  ///
  /// returns a widget based on the state of the snapShot
  /// if data is still loading, it returns a CircularProgressIndicator
  /// if no data is found, it returns a generic 'no data found' msg
  /// if an error occurs, it returns a generic error message
  /// otherwise, it returns null

  static Widget? checkSingleRecordState<T>(AsyncSnapshot<T> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData || snapshot.data == null) {
      return const Center(
        child: NoDataScreen(
          lottieImage: CImages.noDataLottie,
          txt: 'No data found!',
        ),
      );
    }

    if (snapshot.hasError) {
      return const Center(
        child: DataErrorScreen(
          lottieImage: CImages.errorDataLottie,
          txt: 'something went wrong!',
        ),
      );
    }

    return null;
  }

  /// helper function to check the state of multiple db records
  ///
  /// returns a widget based on the state of the snapShot
  /// if data is still loading, it returns a CircularProgressIndicator
  /// if no data is found, it returns a generic 'no data found' msg
  /// if an error occurs, it returns a generic error message
  /// otherwise, it returns null

  static Widget? checkMultipleRecordsState<T>({
    required AsyncSnapshot<List<T>> snapshot,
    Widget? loader,
    Widget? error,
    Widget? noData,
  }) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      if (loader != null) {
        return loader;
      }
      return const Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
      if (noData != null) {
        return const Center(
          child: NoDataScreen(
            lottieImage: CImages.noDataLottie,
            txt: 'No data found!',
          ),
        );
      }
      return const Center(
        child: NoDataScreen(
          lottieImage: CImages.noDataLottie,
          txt: 'no data found!',
        ),
      );
    }

    if (snapshot.hasError) {
      return const Center(
        child: DataErrorScreen(
          lottieImage: CImages.errorDataLottie,
          txt: 'something went wrong!',
        ),
      );
    }

    return null;
  }

  /// create a reference with an initial file path and name to retrieve the download url
  static Future<String> fetchURLFromFilePathAndName(String path) async {
    try {
      if (path.isEmpty) return '';

      final ref = FirebaseStorage.instance.ref().child(path);

      final url = await ref.getDownloadURL();

      return url;
    } on FirebaseException catch (e) {
      throw e.message!;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'something went wrong! ${e.toString()}';
    }
  }

  /// -- copy item to clipboard --
  static Future<void> copyToClipboard(String data) async {
    await Clipboard.setData(ClipboardData(text: data));
    ScaffoldMessenger.of(
      Get.overlayContext!,
    ).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
  }
}
