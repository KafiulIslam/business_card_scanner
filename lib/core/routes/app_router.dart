import 'dart:io';
import 'package:business_card_scanner/core/routes/routes.dart';
import 'package:business_card_scanner/features/auth/presentation/views/login/login_screen.dart';
import 'package:business_card_scanner/features/auth/presentation/views/signUp/sign_up_screen.dart';
import 'package:business_card_scanner/features/dashboard/dashboard_screen.dart';
import 'package:business_card_scanner/features/myCard/presentation/views/choose_template_screen.dart';
import 'package:business_card_scanner/features/myCard/presentation/views/edit_template_details.dart';
import 'package:business_card_scanner/features/myCard/presentation/views/edit_my_card.dart';
import 'package:business_card_scanner/features/myCard/domain/entities/my_card_model.dart';
import 'package:business_card_scanner/features/network/domain/entities/network_model.dart';
import 'package:business_card_scanner/features/network/presentation/views/network_details_screen.dart';
import 'package:business_card_scanner/features/onBoard/presentation/views/onboard_screen.dart';
import 'package:business_card_scanner/features/scanner/presentation/views/create_card_manually_screen.dart';
import 'package:business_card_scanner/features/scanner/presentation/views/scan_result_screen.dart';
import 'package:business_card_scanner/features/tools/presentation/views/convertPdf/convert_pdf_screen.dart';
import 'package:business_card_scanner/features/tools/presentation/views/image_to_text/image_to_text_screen.dart';
import 'package:business_card_scanner/features/tools/presentation/views/image_to_text/scanned_documents_screen.dart';
import 'package:business_card_scanner/features/tools/presentation/views/image_to_text/scanned_to_text_screen.dart';
import 'package:business_card_scanner/features/tools/presentation/views/image_to_text/image_to_text_details_screen.dart';
import 'package:business_card_scanner/features/tools/domain/entities/image_to_text_model.dart';
import 'package:business_card_scanner/features/tools/presentation/views/sign_document/sign_document_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../../splash_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: Routes.splash,
  redirect: (context, state) {
    //! Uncomment the following lines if you want to redirect to login if access token is not present
    // if (!AppSharedPreferences.sharedPreferences
    //     .containsKey(AppStrings.accessToken)) {
    //   return Routes.userLogin;
    // }
    return null;
  },
  routes: [
    //!======================== User Routes ========================
    GoRoute(
      path: Routes.splash,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SplashScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
    GoRoute(
      path: Routes.onboarding,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const OnboardScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
    GoRoute(
      path: Routes.login,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const LoginScreen(),
        // child: LoginScreen(isGoogleSignIn: state.extra as bool? ?? false),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
    GoRoute(
      path: Routes.signUp,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SignUpScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),

    //!======================== Dashboard Routes ========================
    GoRoute(
      path: Routes.dashboard,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const DashboardScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),

    //!======================== Network Routes ========================
    GoRoute(
      path: Routes.networkDetails,
      pageBuilder: (context, state) {
        final network = state.extra as NetworkModel?;
        if (network == null) {
          // Fallback - you might want to handle this differently
          return CustomTransitionPage(
            key: state.pageKey,
            child: const SizedBox(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        }
        return CustomTransitionPage(
          key: state.pageKey,
          child: NetworkDetailsScreen(
            network: network,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),

    //!======================== Scan & Create card ========================
    GoRoute(
      path: Routes.scanResult,
      pageBuilder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        return CustomTransitionPage(
          key: state.pageKey,
          child: ScanResultScreen(
            rawText: args?['rawText'] as String? ?? '',
            extracted: (args?['extracted'] as Map<String, String?>?) ?? {},
            imageFile: args?['imageFile'] as File?,
            isCameraScanned: args?['isCameraScanned'] as bool? ?? false,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: Routes.createCardManually,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const CreateCardManuallyScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),

    //!======================== My Card Routes ========================
    GoRoute(
      path: Routes.chooseTemplate,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const ChooseTemplateScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: Routes.editTemplate,
      pageBuilder: (context, state) {
        final imagePath = state.extra as String? ?? '';
        return CustomTransitionPage(
          key: state.pageKey,
          child: EditTemplateDetails(
            imagePath: imagePath,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: Routes.editMyCard,
      pageBuilder: (context, state) {
        final card = state.extra as MyCardModel?;
        if (card == null) {
          // Fallback - you might want to handle this differently
          return CustomTransitionPage(
            key: state.pageKey,
            child: const SizedBox(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        }
        return CustomTransitionPage(
          key: state.pageKey,
          child: EditMyCardScreen(
            card: card,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),

    //!======================== Tools Routes =======================
    GoRoute(
      path: Routes.imageToText,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const ImageToTextScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: Routes.scanDocuments,
      pageBuilder: (context, state) {
        final imageFile = state.extra as File?;
        if (imageFile == null) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const SizedBox(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        }
        return CustomTransitionPage(
          key: state.pageKey,
          child: ScanDocumentsScreen(imageFile: imageFile),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: Routes.scannedToText,
      pageBuilder: (context, state) {
        final imageFile = state.extra as File?;
        if (imageFile == null) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const SizedBox(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        }
        return CustomTransitionPage(
          key: state.pageKey,
          child: ScannedToTextScreen(imageFile: imageFile),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: Routes.imageToTextDetails,
      pageBuilder: (context, state) {
        final item = state.extra as ImageToTextModel?;
        if (item == null) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const SizedBox(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        }
        return CustomTransitionPage(
          key: state.pageKey,
          child: ImageToTextDetailsScreen(item: item),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: Routes.convertPdf,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const ConvertPdfScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: Routes.signDocument,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const SignDocumentScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
  ],
);
