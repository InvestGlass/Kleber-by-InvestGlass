import 'package:flutter/material.dart';
import 'package:kleber_bank/main.dart';
import 'package:kleber_bank/profile/profile_controller.dart';
import 'package:kleber_bank/utils/app_widgets.dart';
import 'package:provider/provider.dart';

import '../utils/app_styles.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late ProfileController _notifier;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _notifier = Provider.of<ProfileController>(context);
    return Scaffold(
      appBar: AppWidgets.appBar('Change Password'),
      body: Card(
        color: Colors.white,
        margin: EdgeInsets.all(rSize * 0.015),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: rSize*0.02,horizontal: rSize*0.015),
            children: [
              TextFormField(
                controller: _notifier.currentPwdController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                },
                obscureText: _notifier.hideCurrentPwd,
                decoration: AppStyles.inputDecoration(context,
                    label: 'Current Password',
                    suffix: GestureDetector(
                        onTap: () {
                          _notifier.changeCurrentPwdVisibilityStatus();
                        },
                        child: Icon(_notifier.hideCurrentPwd ? Icons.visibility : Icons.visibility_off))),
              ),
              SizedBox(height: rSize*0.015,),
              TextFormField(
                controller: _notifier.newPwdController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }else if(value.length<6){
                    return 'New password needs at least 6 characters';
                  }
                },
                obscureText: _notifier.hideNewPwd,
                decoration: AppStyles.inputDecoration(context,
                    label: 'New Password',
                    suffix: GestureDetector(
                        onTap: () {
                          _notifier.changeNewPwdVisibilityStatus();
                        },
                        child: Icon(_notifier.hideNewPwd ? Icons.visibility : Icons.visibility_off))),
              ),
              SizedBox(height: rSize*0.015,),
              TextFormField(
                controller: _notifier.confirmNewPwdController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }else if(_notifier.newPwdController.text!=value){
                    return 'Confirm new password must match new password';
                  }
                },
                obscureText: _notifier.hideConfirmNewPwd,
                decoration: AppStyles.inputDecoration(context,
                    label: 'Confirm New Password',
                    suffix: GestureDetector(
                        onTap: () {
                          _notifier.changeConfirmNewPwdVisibilityStatus();
                        },
                        child: Icon(_notifier.hideConfirmNewPwd ? Icons.visibility : Icons.visibility_off))),
              ),
              SizedBox(height: rSize*0.03,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {
                        if(_formKey.currentState!.validate()){
                          _notifier.changePassword(context);
                        }
                      },
                      child: AppWidgets.btn(context,'SAVE',horizontalPadding: rSize*0.025)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
