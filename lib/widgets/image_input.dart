import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hlamnik/generated/locale_keys.g.dart';
import 'package:hlamnik/themes/main_theme.dart';
import 'package:hlamnik/widgets/error_text.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

///Widget used to display an image picker input
class ImageInput extends StatefulWidget {
  final String error;
  final Function onSelectImage;
  final Image defaultImage;

  ImageInput({
    @required this.onSelectImage,
    this.defaultImage,
    this.error,
  });

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _image;


  ///Opens the camera so the user can take a picture
  Future<void> _takePicture() async {
    final imageFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );

    await _handlePickedFile(imageFile);
  }

  ///Opens the gallery so the user can pick an image
  Future<void> _importPicture() async {
    final imageFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );

    await _handlePickedFile(imageFile);
  }

  ///Crops and turns an [PickedFile] into base64 string and calls the passed onSelectImage
  Future<void> _handlePickedFile(PickedFile imageFile) async {
    if (imageFile == null) {
      return;
    }

    final croppedImage = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      maxWidth: 1080,
      maxHeight: 1080,
    );

    setState(() {
      _image = File(croppedImage.path);
    });
    final imageBytes = await croppedImage.readAsBytes();
    widget.onSelectImage(base64Encode(imageBytes));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: size.width/2,
                height: size.width/2,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: widget.error != null
                        ? Theme
                        .of(context)
                        .errorColor
                        : AppColors.secondaryColor,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: widget.defaultImage != null || _image != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: _image != null
                      ? Image.file(
                    _image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                      : widget.defaultImage,
                )
                    : Text(
                  LocaleKeys.noImage.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: widget.error != null
                          ? Theme
                          .of(context)
                          .errorColor
                          : AppColors.secondaryColor),
                ),
                alignment: Alignment.center,
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    FlatButton.icon(
                      icon: Icon(Icons.camera),
                      label: Text(LocaleKeys.takePicture.tr()),
                      textColor: AppColors.secondaryColor,
                      onPressed: _takePicture,
                    ),
                    FlatButton.icon(
                      icon: Icon(Icons.file_upload),
                      label: Text(LocaleKeys.uploadPicture.tr()),
                      textColor: AppColors.secondaryColor,
                      onPressed: _importPicture,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (widget.error != null) ErrorText(widget.error),
        ],
      ),
    );
  }
}
