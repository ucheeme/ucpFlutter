

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ucp/data/repository/profileRepo.dart';
import 'package:ucp/utils/constant.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'colorrs.dart';
import 'designUtils/reusableWidgets.dart';

class CameraOption extends StatefulWidget {
  bool? hasCamera;
  CameraOption({super.key, this.hasCamera}) ;

  @override
  State<CameraOption> createState() => _CameraOptionState();
}

class _CameraOptionState extends State<CameraOption> {
  // CameraController? _controller;
  @override
  void initState() {

    super.initState();
  }
  bool isFromCamera=false;
  bool isFromGallery=true;

  bool isNotEmpty=false;
  List<String> images=[];

  File? _image;
  String? _base64Image;
  final picker = ImagePicker();

  Future getImage(ImageSource source) async {
    // final pickedFile = await picker.getImage(source: source);
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        // ucpFilePath=pickedFile.path;
        _resizeAndEncodeImage();
      }
    });


  }
  Future<File?> _compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath = '${dir.path}/compressed_image.jpg'; // Use a fixed filename

    XFile? compressedFile = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 40, // Adjust quality for better compression
    );

    if (compressedFile != null) {
      File finalFile = File(compressedFile.path);

      // Ensure the file is ≤ 20KB, but prevent infinite recursion
      if (finalFile.lengthSync() > 20 * 1024) {
        return await _compressImageWithLowerQuality(finalFile);
      }
      return finalFile;
    }
    return null;
  }

// Compress with lower quality if the file is still > 20KB
  Future<File?> _compressImageWithLowerQuality(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath = '${dir.path}/compressed_image_low.jpg';

    XFile? compressedFile = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 20, // Reduce quality further
    );

    return compressedFile != null ? File(compressedFile.path) : null;
  }

  Future<void> _resizeAndEncodeImage() async {
    final fileSize = await _image!.length();

    if (fileSize > 300 * 1024) {
      // Image size is greater than 300KB, resize the image
      _compressImageWithLowerQuality(_image!);
      final tempDir = await getTemporaryDirectory();
      final tempPath = path.join(tempDir.path, path.basename(_image!.path));

      img.Image? image = img.decodeImage(_image!.readAsBytesSync());
      final resizedImage = img.copyResize(image!, width: 800);

      File(tempPath).writeAsBytesSync(img.encodeJpg(resizedImage));

      setState(() {
        _image = File(tempPath);
      });
      _cropImage(_image!,tempPath);
    } else {
      _cropImage(_image!,_image!.path);
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    //  _controller?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: 220.h,
        color: AppColor.ucpWhite500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: AppColor.ucpBlue500,
              height: 53.h,
              child: Padding(
                padding:  EdgeInsets.only(left: 20.w),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Image upload",
                      style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                          color: AppColor.ucpWhite500,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400
                      )
                  ),
                ),
              ),
            ),
            Gap(20.h),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 12.w),
              child: GestureDetector(
                onTap:  () async {
                  setState(() {
                    isFromCamera = true;
                    isFromGallery = false;
                  });
                  if(widget.hasCamera==null || widget.hasCamera==true){
                    await getImage(ImageSource.camera);
                  }},
                child: Container(
                  height: 54.h,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                      color: isFromCamera
                          ? AppColor.ucpBlue25
                          : AppColor.ucpWhite500,
                      borderRadius:
                      BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isFromCamera
                            ? AppColor.ucpBlue500
                            : AppColor.ucpWhite500,
                      )),
                  child: BottomsheetRadioButtonRightSide(
                    radioText:"Take a picture with your camera",
                    isMoreThanOne:true,
                    isDmSans: false,
                    isSelected: isFromCamera,
                    onTap:null,
                    textHeight:24.h,
                  ),
                ),
              ),
            ),
            Gap(30.h),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 12.w),
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    isFromCamera = false;
                    isFromGallery = true;
                  });
                  getImage(ImageSource.gallery);
                },
                child: Container(
                  height: 54.h,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                      color: isFromGallery
                          ? AppColor.ucpBlue25
                          : AppColor.ucpWhite500,
                      borderRadius:
                      BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isFromGallery
                            ? AppColor.ucpBlue500
                            : AppColor.ucpWhite500,
                      )),
                  child: BottomsheetRadioButtonRightSide(
                    radioText:"Upload from device",
                    isMoreThanOne:true,
                    isDmSans: false,
                    isSelected: isFromGallery,
                    onTap: null,
                    textHeight:24.h,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _cropImage(File imgFile,String path) async {
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: path,
        compressFormat: ImageCompressFormat.png,
        uiSettings:[
          AndroidUiSettings(
              toolbarTitle: "Image Cropper",
              toolbarColor: AppColor.ucpBlue500,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
          ),
          IOSUiSettings(
            title: "Image Cropper",
            showCancelConfirmationDialog: true,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
          )
        ]
    );
    const CircularProgressIndicator(color: AppColor.ucpBlue500,);
    if (croppedFile != null) {

      imageCache.clear();
      setState(() {
        _image= File(croppedFile.path);
        _base64Image = base64Encode(_image!.readAsBytesSync());
        ucpFilePath=croppedFile.path;
      });
      // reload();
    }else{
      setState(() {
        _image= File(imgFile.path);
        _base64Image = base64Encode(_image!.readAsBytesSync());
        ucpFilePath=imgFile.path;
      });
    }
    Get.back(result:[ _image,_base64Image]);
  }
}

void requestCameraPermission(context) async {
  var status = await Permission.camera.request();
  if (status.isGranted) {

  } else if (status.isDenied) {
    final snackBar=SnackBar(
      content: Text('Camera permission denied!'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  } else if (status.isPermanentlyDenied) {

  }
}

void checkCameraPermission(context) async {
  var status = await Permission.camera.status;
  if (status.isGranted) {

  } else {
    requestCameraPermission(context);
  }
}