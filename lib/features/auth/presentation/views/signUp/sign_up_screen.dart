import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/utils/custom_snack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';
import '../../../../../core/widgets/inputFields/common_textfield.dart';
import '../../../../../core/widgets/inputFields/password_inputfield.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/signup_cubit.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  late bool isTermAccepted = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocConsumer<SignupCubit, SignupState>(
              listener: (context, state) {
                if (state is SignupFailure) {
                  CustomSnack.warning(state.message, context);
                }
                if (state is SignupSuccess) {
                  CustomSnack.success(
                      'You account is created successfully!', context);
                  context.go(Routes.dashboard);
                }
              },
              builder: (context, state) {
                final isLoading = state is SignupLoading;
                return Column(
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
                    _buildTermsCheckBox(),
                    Gap(AppDimensions.spacing24),
                    PrimaryButton(
                      onTap: () async {
                        if (isTermAccepted) {
                          //check and make sure email and password field is not empty
                          if (_email.text.isEmpty || _password.text.isEmpty) {
                            CustomSnack.warning(
                                'Please, enter email and password', context);
                            return;
                          }

                          //call signup function
                          context.read<SignupCubit>().signUp(
                                _email.text.trim(),
                                _password.text.trim(),
                              );
                        } else {
                          CustomSnack.warning(
                              'Please accept the Terms & Conditions.', context);
                        }
                      },
                      buttonTitle: 'Sign Up',
                      isLoading: isLoading,
                    ),
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTermsCheckBox() {
    return InkWell(
      onTap: () {
        setState(() {
          isTermAccepted = !isTermAccepted;
        });
      },
      splashColor: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
                color: isTermAccepted ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: isTermAccepted
                        ? Colors.transparent
                        : AppColors.borderColor,
                    width: 1.5)),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 12,
            ),
          ),
          Gap(AppDimensions.spacing8),
          RichText(
            text: TextSpan(
              text: 'I accept the ',
              style: AppTextStyles.bodyMedium.copyWith(fontSize: 14),
              children: <TextSpan>[
                TextSpan(
                    text: 'Terms & Conditions',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        context.push(Routes.termsConditions);
                      },
                    style: AppTextStyles.headline3.copyWith(
                        fontSize: 14,
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primary)),
              ],
            ),
          )
        ],
      ),
    );
  }

}
