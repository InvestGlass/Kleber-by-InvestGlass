import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kleber_bank/documents/documents_controller.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../utils/app_widgets.dart';

class UploadDocument extends StatefulWidget {
  const UploadDocument({super.key});

  @override
  State<UploadDocument> createState() => _UploadDocumentState();
}

class _UploadDocumentState extends State<UploadDocument> {
  late DocumentsController _notifier;

  @override
  Widget build(BuildContext context) {
    _notifier = Provider.of<DocumentsController>(context);
    return Scaffold(
      appBar: AppWidgets.appBar('Upload Document'),
      body: Card(
        margin: EdgeInsets.all(rSize * 0.015),
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: rSize * 0.015, vertical: rSize * 0.02),
          shrinkWrap: true,
          children: [
            selectionCell(
                title: 'File',
                content: _notifier.image != null ? _notifier.image!.name : 'Click to upload your document',
                onSelectTap: () {
                  AppWidgets.openMediaSelectionBottomSheet(
                    context,
                    onCameraClick: () async {
                      final ImagePicker picker = ImagePicker();
                      await picker.pickImage(source: ImageSource.camera).then(
                        (value) {
                          _notifier.selectImage(value);
                          Navigator.pop(context);
                        },
                      );
                    },
                    onFileClick: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickMedia();
                      _notifier.selectImage(image);
                      Navigator.pop(context);
                    },
                  );
                },
                onCloseTap: () {
                  _notifier.removeSelectedImage();
                },
                isSelected: _notifier.image != null),
            if (_notifier.errorMsg.isNotEmpty) ...{
              SizedBox(
                height: rSize * 0.01,
              ),
              Text(
                _notifier.errorMsg,
                style: AppStyles.errorStyle,
              ),
            },
            SizedBox(
              height: rSize * 0.02,
            ),
            TextFormField(
              minLines: 3,
              maxLines: 3,
              controller: _notifier.descController,
              textAlign: TextAlign.start,
              decoration: AppStyles.inputDecoration(context,
                label: 'Description',
                hint: 'Write something...',
              ),
            ),
            SizedBox(
              height: rSize * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (!isButtonDisabled()) {
                      _notifier.uploadDoc(context);
                    }
                  },
                  child:
                      AppWidgets.btn(context,'Upload', horizontalPadding: rSize * 0.03, bgColor: isButtonDisabled() ? AppColors.kHint : AppColors.kViolate),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  bool isButtonDisabled() => _notifier.image == null;

  Row selectionCell(
      {required String title,
      required String content,
      required void Function()? onSelectTap,
      required void Function()? onCloseTap,
      bool isSelected = false}) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppStyles.c3C496CW500S16,
              ),
              Text(
                content,
                style: AppStyles.c929292W500S14.copyWith(fontSize: AppStyles.px12),
              )
            ],
          ),
        ),
        SizedBox(
          width: rSize * 0.015,
        ),
        if (!isSelected) ...{selectButton(onSelectTap)} else ...{closeButton(onCloseTap)}
      ],
    );
  }

  GestureDetector closeButton(void Function()? onCloseTap) {
    return GestureDetector(
      onTap: onCloseTap,
      child: Container(
        height: rSize * 0.05,
        width: rSize * 0.05,
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.kTextFieldInput, width: 0.5)),
        child: Icon(
          Icons.close,
          color: AppColors.kTextFieldInput,
        ),
      ),
    );
  }

  GestureDetector selectButton(void Function()? onTap) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(border: Border.all(color: AppColors.kViolate, width: 1), borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.symmetric(vertical: rSize * 0.01, horizontal: rSize * 0.01),
          child: Text(
            'Select',
            style: AppStyles.c3C496CW500S16,
          ),
        ));
  }
}
