import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hlamnik/themes/main_theme.dart';
import 'package:hlamnik/widgets/error_text.dart';
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

  ///Turns an [PickedFile] into base64 string and calls the passed onSelectImage
  Future<void> _handlePickedFile(PickedFile imageFile) async{
    if (imageFile == null) {
      return;
    }
    setState(() {
      _image = File(imageFile.path);
    });
    final imageBytes = await imageFile.readAsBytes();
    widget.onSelectImage(base64Encode(imageBytes));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 150,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: widget.error != null
                        ? Theme.of(context).errorColor
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
                        'noImage'.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: widget.error != null
                                ? Theme.of(context).errorColor
                                : AppColors.secondaryColor),
                      ),
                alignment: Alignment.center,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    FlatButton.icon(
                      icon: Icon(Icons.camera),
                      label: Text('takePicture'.tr()),
                      textColor: AppColors.secondaryColor,
                      onPressed: _takePicture,
                    ),
                    FlatButton.icon(
                      icon: Icon(Icons.file_upload),
                      label: Text('uploadPicture'.tr()),
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
