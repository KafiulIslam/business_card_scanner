import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';
import '../../../../../core/widgets/inputFields/common_textfield.dart';
import '../../../../../core/widgets/inputFields/password_inputfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late bool isLoading = false;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Create Account',
                    style: AppTextStyles.headline3,
                  ),
                  Gap(AppDimensions.spacing16),
                  CommonTextField(
                    controller: _email,
                    label: 'Email',
                    hintText: 'Enter your email',
                  ),
                  Gap(AppDimensions.spacing16),
                  PasswordInputField(
                    controller: _password,
                    label: 'Password',
                    hintText: 'Enter the password',
                  ),
                  Gap(AppDimensions.spacing24),
                  PrimaryButton(
                      onTap: () async {
                        // if (_email.text.isNotEmpty &&
                        //     _password.text.isNotEmpty) {
                        //   Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (_) => CompleteProfileScreen(
                        //               email: _email.text,
                        //               password: _password.text)));
                        // } else {
                        //   CustomSnack.warningSnack(
                        //       'Please enter email and password', context);
                        // }
                      },
                      buttonTitle: 'Sign Up'),
                  Gap(AppDimensions.spacing32),
                  Text(
                    'Already have an account?',
                    style: AppTextStyles.bodySmall,
                  ),
                  TextButton(
                      onPressed: () {
                        context.go(Routes.login);
                      },
                      child: Text(
                        'Log In',
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColors.primary),
                      )),
                  Gap(AppDimensions.spacing24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
