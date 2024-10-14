import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kleber_bank/documents/documents_controller.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../utils/app_widgets.dart';
import '../utils/flutter_flow_theme.dart';
import '../utils/internationalization.dart';

class UploadDocument extends StatefulWidget {
  const UploadDocument({super.key});

  @override
  State<UploadDocument> createState() => _UploadDocumentState();
}

class _UploadDocumentState extends State<UploadDocument> {
  late DocumentsController _notifier;

  @override
  void dispose() {
    _notifier.image = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _notifier = Provider.of<DocumentsController>(context);
    return Scaffold(
      appBar: AppWidgets.appBar(
          context,
          FFLocalizations.of(context).getText(
            't2nv4kvj' /* Upload*/,
          ),centerTitle: true,
          leading: AppWidgets.backArrow(context)),
      body: Container(
        decoration: AppStyles.commonBg(context),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: rSize * 0.015, vertical: rSize * 0.02),
          children: [
            selectionCell(
                title: FFLocalizations.of(context).getText(
                  'him7gi6o' /* File */,
                ),
                content: _notifier.image != null
                    ? _notifier.image!.name
                    : FFLocalizations.of(context).getText(
                        'jzvxxaxu' /* Click to upload your document */,
                      ),
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
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Roboto',
                      color: FlutterFlowTheme.of(context).customColor3,
                      fontSize: rSize * 0.016,
                      letterSpacing: 0.0,
                    ),
              ),
            },
            SizedBox(
              height: rSize * 0.02,
            ),
            Text(
              FFLocalizations.of(context).getText(
                'mw4a4y0a' /* Description */,
              ),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Roboto',
                    fontSize: rSize * 0.02,
                    color: FlutterFlowTheme.of(context).customColor4,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            SizedBox(
              height: rSize * 0.01,
            ),
            TextFormField(
              minLines: 3,
              maxLines: 3,
              controller: _notifier.descController,
              textAlign: TextAlign.start,
              decoration: AppStyles.inputDecoration(context,),
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
                  child: AppWidgets.btn(
                      context,
                      FFLocalizations.of(context).getText(
                        't2nv4kvj' /* Upload */,
                      ),
                      textColor: Colors.white,
                      horizontalPadding: rSize * 0.03,),
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
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Roboto',
                      fontSize: rSize * 0.02,
                      color: FlutterFlowTheme.of(context).customColor4,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              if(_notifier.image!=null)
              Text(
                content,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Roboto',
                      color: FlutterFlowTheme.of(context).grayLight,
                      fontSize: rSize * 0.016,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
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

  Widget selectButton(void Function()? onTap) {
    return GestureDetector(
        onTap: onTap,
        child: AppWidgets.btn(
            context,
            FFLocalizations.of(context).getText(
              'lh2w6q42' /* Select  */,
            ),
            textColor: Colors.white,
            horizontalPadding: rSize * 0.020));
    /*return GestureDetector(

        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(border: Border.all(color: AppColors.kViolate, width: 1), borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.symmetric(vertical: rSize * 0.01, horizontal: rSize * 0.01),
          child: Text(
            'Select',
            style: AppStyles.c3C496CW500S16,
          ),
        ));*/
  }
}
