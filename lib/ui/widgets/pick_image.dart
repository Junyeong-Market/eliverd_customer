import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImageDialog extends StatefulWidget {
  final ValueChanged<File> onImageSelected;

  const PickImageDialog({Key key, this.onImageSelected}) : super(key: key);

  @override
  _PickImageDialogState createState() => _PickImageDialogState();
}

class _PickImageDialogState extends State<PickImageDialog> {
  ImagePicker _imagePicker;

  @override
  void initState() {
    super.initState();

    _imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      height: height * 0.4,
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 8.0,
          ),
          Divider(
            indent: 140.0,
            endIndent: 140.0,
            height: 16.0,
            thickness: 4.0,
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            '이미지 불러오기',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
            ),
          ),
          Text(
            '불러올 이미지를 가져오세요.',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 17.0,
              color: Colors.black45,
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(
                    height: width * 0.45,
                  ),
                  child: CupertinoButton(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '􀌟',
                          style: TextStyle(
                            fontWeight: FontWeight.w200,
                            fontSize: 24.0,
                            color: Colors.white,
                            fontFamily: 'SFProDisplay',
                          ),
                        ),
                        Text(
                          '카메라로 찍기',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0,
                            color: Colors.white,
                            fontFamily: 'SFProDisplay',
                          ),
                        ),
                      ],
                    ),
                    color: Colors.black12.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(15.0),
                    onPressed: () async {
                      final pickedFile = await _imagePicker.getImage(
                        source: ImageSource.camera,
                      );

                      widget.onImageSelected(File(pickedFile.path));
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 8.0,
              ),
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(
                    height: width * 0.45,
                  ),
                  child: CupertinoButton(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '􀏮',
                          style: TextStyle(
                            fontWeight: FontWeight.w200,
                            fontSize: 24.0,
                            color: Colors.white,
                            fontFamily: 'SFProDisplay',
                          ),
                        ),
                        Text(
                          '갤러리에서 가져오기',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0,
                            color: Colors.white,
                            fontFamily: 'SFProDisplay',
                          ),
                        ),
                      ],
                    ),
                    color: Colors.black12.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(15.0),
                    onPressed: () async {
                      final pickedFile = await _imagePicker.getImage(
                        source: ImageSource.gallery,
                      );

                      widget.onImageSelected(File(pickedFile.path));
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
