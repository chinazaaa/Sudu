import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:starter_project/Salon/pages/auth/login.dart';
import 'package:starter_project/core/repositories/authentication_repository.dart';
import 'package:starter_project/core/routes/route_names.dart';
import 'package:starter_project/ui_helpers/responsive_state/responsive_state.dart';
import 'package:starter_project/ui_helpers/size_config/size_config.dart';

import 'custom_button.dart';
import 'custom_text_field.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String email;

  final TextEditingController token = TextEditingController();
  final TextEditingController password = TextEditingController();
  final resetPasswordKey = GlobalKey<FormState>();

  ResetPasswordScreen(this.email);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AuthRepository>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.widthOf(6)),
          child: Form(
            key: resetPasswordKey,
            child: Column(
              children: [
                SizedBox(height: 50),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Reset Password',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w700)),
                          SizedBox(height: 20),
                          Text('Choose something you would remember',
                              style: TextStyle()),
                        ])),
                SizedBox(height: 40),
                CustomTextField(
                  hintText: 'OTP',
                  obscureText: true,
                  validator: (value) => value.length < 3 ? 'Entry too short' : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: token,
                ),
                SizedBox(
                  height: 24,
                ),
                CustomTextField(
                  hintText: 'Password',
                  obscureText: true,
                  validator: (value) => model.validatePassword(value),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: password,
                ),
                SizedBox(height: 24),
                CustomTextField(
                  hintText: 'Confirm Password',
                  obscureText: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (val) =>
                      password.text == val ? null : "Passwords do not match",
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ResponsiveState(
                      state: model.state,
                      busyWidget: SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            strokeWidth: 6,
                            backgroundColor: Theme.of(context).primaryColor,
                          )),
                      idleWidget: Expanded(
                        child: CustomButton(
                          onPressed: () async {
                            if (!resetPasswordKey.currentState.validate())
                              return;

                            bool success = await model.resetPassword(isCustomer: false, otp: token.text, newPassword: password.text, email: email);
                            if (success) {
                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> SalonLoginPage()), (route)=> false);
                              Get.snackbar(
                                'Success!',
                                'Password Successfully Reset',
                                margin: EdgeInsets.symmetric(
                                    vertical: 30, horizontal: 30),
                                snackStyle: SnackStyle.FLOATING,
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.black26,
                              );
                            }
                          },
                          textColor: Colors.white,
                          text: 'Reset Password',
                          backgroundColor: Color(0xff9477cb),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.heightOf(10)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
