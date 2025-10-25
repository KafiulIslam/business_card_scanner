import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';
import '../../../../../core/widgets/inputFields/common_textfield.dart';
import '../../../../../core/widgets/inputFields/password_inputfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                    'Log In',
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
                      // await authState.login(
                      //     _email.text, _password.text, context);
                    },
                    buttonTitle: 'Log In',
                   // isLoading: authState.isLogin,
                  ),
                  Gap(AppDimensions.spacing32),
                  Text('Don’t have an account?',
                      style: AppTextStyles.bodySmall),
                  TextButton(
                      onPressed: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (_) => const SignUpScreen()));
                      },
                      child: Text(
                        'Sign Up',
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColors.primary),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
