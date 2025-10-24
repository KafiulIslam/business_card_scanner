import 'package:business_card_scanner/core/routes/routes.dart';
import 'package:business_card_scanner/features/auth/presentation/views/login_screen.dart';
import 'package:business_card_scanner/features/onBoard/presentation/views/onboard_screen.dart';
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
    // GoRoute(
    //   path: Routes.userForgetPassword,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: ForgetPassPage(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.welcome,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: const WelcomeScreen(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.userRegisterPersonalInfo,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: const PlayerRegisterView(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.userRegisterHealthInfo,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: const RegisterHealthInfoScreen(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.userResetPassword,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: const ResetPasswordScreen(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    //
    // GoRoute(
    //   path: Routes.userRegisterPassword,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: const RegisterPasswordScreen(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    //
    // GoRoute(
    //   path: Routes.userHome,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: AppLayoutPage(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.userNotifications,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: const CustomNotifications(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.userEmptyChatApp,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: const EmptyChatApp(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.userEmptyNotifications,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: const EmptyNotificationScreen(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.userChatList,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: const ChatListScreen(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.userChatScreen,
    //   pageBuilder: (context, state) {
    //     final args = state.extra as Map<String, dynamic>?;
    //     return CustomTransitionPage(
    //       key: state.pageKey,
    //       child: PlayerChatScreen(
    //         senderModel: args?['senderModel'],
    //         conversationId: args?['conversationId'],
    //         role: args?['role'],
    //         recieverModel: args?['receiverModel'],
    //       ),
    //       transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //         return FadeTransition(opacity: animation, child: child);
    //       },
    //     );
    //   },
    // ),
    // GoRoute(
    //   path: Routes.userSubscriptionsDetails,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: ProgramDetailsForPlayerView(model: state.extra as ProgramModel),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.userMyProgress,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: PlayerProgressView(weekNumber: state.extra as int),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.userWormUP,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: const WarmUpScreen(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.userWormDetails,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: const WarmDetailsScreen(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.userRestaurantDetailsScreen,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: RestaurantDetailsScreen(model: state.extra as RestaurantModel?),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.userRestaurantsScreen,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: CustomRestaurantsScreen(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.userStoreScreen,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: StoreScreen(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.userProductDetails,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: CoachProductDetails(model: state.extra as ProductModel),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.userRecipeDetails,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: RecipeDetails(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),

    // GoRoute(
    //   path: Routes.userTrainersDetails,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: TrainersDetails(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.programDetails,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: ProgramDetails(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    //
    // GoRoute(
    //   path: Routes.paymentMethods,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: PayementMethods(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    //
    // GoRoute(
    //   path: Routes.storyScreen,
    //   pageBuilder: (context, state) {
    //     final args = state.extra as Map<String, dynamic>;
    //     return CustomTransitionPage(
    //       key: state.pageKey,
    //       child: StoryScreen(
    //         initialIndex: args['initialIndex'],
    //         stories: args['stories'],
    //       ),
    //       transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //         return FadeTransition(opacity: animation, child: child);
    //       },
    //     );
    //   },
    // ),
    //
    // GoRoute(
    //   path: Routes.editProfile,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: EditProfile(profileModel: state.extra as PlayerProfileModel),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.editPaymentMethods,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: const EditPaymentMethods(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.addPaymentMethods,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: const AddPaymentMethods(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.mySubscriptions,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: const MySubscriptions(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.following,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: FollowingScreen(userId: state.extra as String),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.savedScreen,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: SavedScreen(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    //
    // GoRoute(
    //   path: Routes.changePassword,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: const ChangePassword(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.changeLanguage,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: const LanguageScreen(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.termsAndConditions,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: const TermsAndConditions(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.support,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: const SupportScreen(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),

    //!======================== Coach Routes ========================
    // GoRoute(
    //   path: Routes.coachRegisterPersonalInfo,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: CoachRegisterScreen(profile: state.extra as PlayerProfileModel?),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.aboutCoachScreen,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: const AboutCoachScreen(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.coachCertificate,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: const CertificatesScreen(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.coachRegisterPassword,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: const RegisterPasswordScreen(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    //
    // GoRoute(
    //   path: Routes.coachHome,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: const CoachAppLayoutPage(),
    //
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.paidCoachPersonalInfo,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: const PaidCoachPersonalInfoScreen(),
    //
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.paymentCoachInfo,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: const PaidCoachPaymentInfo(),
    //
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.paidCoachHealthInfo,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: const PaidCoachHealthInfoScreen(),
    //
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.paidCoachPasswordInfo,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: const PaidCoachPasswordScreen(),
    //
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.coachNotifications,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: const CustomNotifications(),
    //
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.coachEmptyNotifications,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: const CoachEmptyNotifications(),
    //
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    //
    // GoRoute(
    //   path: Routes.coachChatList,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: const CoachChatList(),
    //
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    //
    // GoRoute(
    //   path: Routes.coachTrainersDetails,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: CoachTrainersDetails(model: state.extra as TrainerModel?),
    //
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.coachProgramDetails,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: const coachProgramDetails(),
    //
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    //
    // GoRoute(
    //   path: Routes.addProduct,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: AddProductToCoach(product: state.extra as ProductModel?),
    //
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.coachRestaurantDetails,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: CoachRestaurantDetailsScreen(),
    //
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.createNewPost,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: CreateNewPost(),
    //
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.addAchievementCard,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: AddAcheveimentCard(),
    //
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.createNewProgram,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: CreateProgram(),

    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.followScreen,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: CoachFollowView(userId: state.extra as String),
    //
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.coachEditProfile,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: CoachEditProfile(),
    //
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.coachEditPaymentMethods,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: CoachEditPaymentMethods(),
    //
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.coachMyExercises,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     child: MyExerisece(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.addExercise,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     child: AddExcersice(exercise: state.extra as ExerciseModel?),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.addNewCard,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     child: AddNewCard(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.coachChangePassword,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     child: CoachChangePassword(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.coachSupport,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     child: SupportCoach(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.myCategory,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     child: MyCategory(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.categoryDetails,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     child: CatageroyDetails(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.myLibrary,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     child: MyLibrary(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.workoutDetails,
    //   pageBuilder: (context, state) {
    //     final args = state.extra as Map<String, dynamic>;
    //     return CustomTransitionPage(
    //       child: WorkoutDetials(
    //         model: args['model'],
    //         buttonWidget: args['buttonWidget'],
    //       ),
    //       transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //         return FadeTransition(opacity: animation, child: child);
    //       },
    //     );
    //   },
    // ),
    // GoRoute(
    //   path: Routes.coachSubscribers,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     child: SubscribersScreen(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.coachClientProfileSubscribers,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     child: ClientProfileSubscribersScreen(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.coachClientProfileDetailsScreen,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     child: ClientProfileDetailsScreen(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.addPlaneForInvidualViewPage,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     child: AddPlaneViewForIndividualPage(
    //       isGroup: state.extra as bool? ?? false,
    //     ),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.addPlaneForGroupViewPage,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     child: AddPlaneViewForGroupPage(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.addProgramPage,
    //   pageBuilder: (context, state) {
    //     final args = state.extra as Map<String, dynamic>;
    //     final model = args['model'];
    //     final cubit = args['cubit'];
    //     return CustomTransitionPage(
    //       child: AddProgramView(model: model, cubit: cubit),
    //       transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //         return FadeTransition(opacity: animation, child: child);
    //       },
    //     );
    //   },
    // ),
    // GoRoute(
    //   path: Routes.mealsScreen,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     child: MealsScreen(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.addMeal,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     child: AddMeal(model: state.extra as MealModel?),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.mealDetails,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     child: MealDetails(meal: state.extra as MealModel),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.supplementsScreen,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     child: SupplementsScreen(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.addSupplement,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     child: AddSupplements(model: state.extra as SupplementModel?),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    //
    // GoRoute(
    //   path: Routes.supplementDetails,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     child: SupplementDetails(model: state.extra as SupplementModel),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.addPlaneForInvidualViewPage,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     child: AddPlaneViewForIndividualPage(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.addPlaneForGroupViewPage,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     child: AddPlaneViewForGroupPage(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.addProgramPage,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     child: AddProgramView(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.singlePlanView,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     child: SinglePlanView(model: state.extra as ProgramModel),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.programDetailsView,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     child: ProgramDetailsView(programId: state.extra as String),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.coachProducts,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     child: CoachProducts(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.addSponser,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     child: AddEditSponserView(model: state.extra as SponserModel?),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
    // GoRoute(
    //   path: Routes.followersScreen,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     child: FollowersScreen(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
  ],
);