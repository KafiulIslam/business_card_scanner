import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:business_card_scanner/features/auth/presentation/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/custom_snack.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';
import '../../../../../core/widgets/inputFields/common_textfield.dart';
import '../../../../../core/widgets/inputFields/password_inputfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

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
            child: BlocConsumer<LoginCubit, LoginState>(
              listener: (context, state) {
                if (state is LoginFailure) {
                  CustomSnack.warning(state.message, context);
                }
                if (state is LoginSuccess) {
                  CustomSnack.success(
                      'You are logged in successfully!', context);
                  context.go(Routes.dashboard);
                }
              },
              builder: (context, state) {
                return Column(
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

                        //check and make sure email and password field is not empty
                        if (_email.text.isEmpty || _password.text.isEmpty) {
                          CustomSnack.warning(
                              'Please, enter email and password', context);
                          return;
                        }

                        //call signup function
                        context.read<LoginCubit>().login(
                          _email.text.trim(),
                          _password.text.trim(),
                        );
                      },
                      buttonTitle: 'Log In',
                      isLoading: state is LoginLoading,
                    ),
                    Gap(AppDimensions.spacing32),
                    Text('Don’t have an account?',
                        style: AppTextStyles.bodySmall),
                    TextButton(
                        onPressed: () {
                          context.go(Routes.signUp);
                        },
                        child: Text(
                          'Sign Up',
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: AppColors.primary),
                        )),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
