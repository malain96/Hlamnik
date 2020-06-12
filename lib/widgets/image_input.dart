import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hlamnik/themes/main_theme.dart';
import 'package:hlamnik/widgets/error_text.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  final String error;
  final Function onSelectImage;

  ImageInput({
    this.error,
    this.onSelectImage,
  });

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _image;

  Future<void> _takePicture() async {
    final imageFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
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
    return Column(
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
              child: _image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.file(
                        _image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
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
              child: FlatButton.icon(
                icon: Icon(Icons.camera),
                label: Text('takePicture'.tr()),
                textColor: AppColors.secondaryColor,
                onPressed: _takePicture,
              ),
            ),
          ],
        ),
        if (widget.error != null) ErrorText(widget.error),
      ],
    );
  }
}
