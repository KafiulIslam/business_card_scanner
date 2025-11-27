import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_card_scanner/features/auth/data/services/firebase_auth_service.dart';
import 'package:business_card_scanner/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:business_card_scanner/features/auth/domain/repositories/auth_repository.dart';
import 'package:business_card_scanner/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:business_card_scanner/features/auth/presentation/cubit/signup_cubit.dart';
import 'package:business_card_scanner/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:business_card_scanner/features/auth/presentation/cubit/login_cubit.dart';
import 'package:business_card_scanner/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:business_card_scanner/features/auth/presentation/cubit/logout_cubit.dart';
import 'package:business_card_scanner/features/auth/domain/use_cases/delete_account_use_case.dart';
import 'package:business_card_scanner/features/auth/presentation/cubit/delete_account_cubit.dart';
import 'package:business_card_scanner/features/network/data/services/firebase_storage_service.dart';
import 'package:business_card_scanner/features/network/data/services/firebase_network_service.dart';
import 'package:business_card_scanner/features/network/data/repositories/network_repository_impl.dart';
import 'package:business_card_scanner/features/network/domain/repositories/network_repository.dart';
import 'package:business_card_scanner/features/network/domain/use_cases/save_network_card_use_case.dart';
import 'package:business_card_scanner/features/network/domain/use_cases/get_network_cards_use_case.dart';
import 'package:business_card_scanner/features/network/domain/use_cases/delete_network_card_use_case.dart';
import 'package:business_card_scanner/features/network/presentation/cubit/network_cubit.dart';
import 'package:business_card_scanner/features/myCard/data/services/firebase_my_card_service.dart';
import 'package:business_card_scanner/features/myCard/data/repositories/my_card_repository_impl.dart';
import 'package:business_card_scanner/features/myCard/domain/repositories/my_card_repository.dart';
import 'package:business_card_scanner/features/myCard/domain/use_cases/save_my_card_use_case.dart';
import 'package:business_card_scanner/features/myCard/domain/use_cases/update_my_card_use_case.dart';
import 'package:business_card_scanner/features/myCard/domain/use_cases/get_my_cards_use_case.dart';
import 'package:business_card_scanner/features/myCard/domain/use_cases/delete_my_card_use_case.dart';
import 'package:business_card_scanner/features/myCard/presentation/cubit/my_card_cubit.dart';
import 'package:business_card_scanner/core/services/external_app_service.dart';
import 'package:business_card_scanner/features/tools/data/services/firebase_image_to_text_service.dart';
import 'package:business_card_scanner/features/tools/data/repositories/image_to_text_repository_impl.dart';
import 'package:business_card_scanner/features/tools/domain/repositories/image_to_text_repository.dart';
import 'package:business_card_scanner/features/tools/domain/use_cases/get_image_to_text_list_use_case.dart';
import 'package:business_card_scanner/features/tools/domain/use_cases/update_image_to_text_use_case.dart';
import 'package:business_card_scanner/features/tools/domain/use_cases/delete_image_to_text_use_case.dart';
import 'package:business_card_scanner/features/tools/presentation/cubit/image_to_text_cubit.dart';
import 'package:business_card_scanner/features/tools/data/services/firebase_pdf_service.dart';
import 'package:business_card_scanner/features/tools/data/services/firebase_signed_docs_service.dart';
import 'package:business_card_scanner/features/tools/data/repositories/pdf_repository_impl.dart';
import 'package:business_card_scanner/features/tools/data/repositories/signed_document_repository_impl.dart';
import 'package:business_card_scanner/features/tools/domain/repositories/pdf_repository.dart';
import 'package:business_card_scanner/features/tools/domain/repositories/signed_document_repository.dart';
import 'package:business_card_scanner/features/tools/domain/use_cases/get_pdf_documents_use_case.dart';
import 'package:business_card_scanner/features/tools/domain/use_cases/upload_pdf_document_use_case.dart';
import 'package:business_card_scanner/features/tools/domain/use_cases/get_signed_documents_use_case.dart';
import 'package:business_card_scanner/features/tools/domain/use_cases/delete_signed_document_use_case.dart';
import 'package:business_card_scanner/features/tools/presentation/cubit/convert_pdf_cubit.dart';
import 'package:business_card_scanner/features/tools/presentation/cubit/signed_docs_cubit.dart';

class AppProviders extends StatelessWidget {
  final Widget child;

  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<FirebaseAuthService>(
          create: (_) => FirebaseAuthService(),
        ),
        RepositoryProvider<AuthRepository>(
          create: (ctx) => AuthRepositoryImpl(ctx.read<FirebaseAuthService>()),
        ),
        RepositoryProvider<SignUpUseCase>(
          create: (ctx) => SignUpUseCase(ctx.read<AuthRepository>()),
        ),
        RepositoryProvider<SignInUseCase>(
          create: (ctx) => SignInUseCase(ctx.read<AuthRepository>()),
        ),
        RepositoryProvider<SignOutUseCase>(
          create: (ctx) => SignOutUseCase(ctx.read<AuthRepository>()),
        ),
        RepositoryProvider<DeleteAccountUseCase>(
          create: (ctx) => DeleteAccountUseCase(ctx.read<AuthRepository>()),
        ),
        RepositoryProvider<FirebaseStorageService>(
          create: (_) => FirebaseStorageService(),
        ),
        RepositoryProvider<FirebaseNetworkService>(
          create: (_) => FirebaseNetworkService(),
        ),
        RepositoryProvider<NetworkRepository>(
          create: (ctx) => NetworkRepositoryImpl(ctx.read<FirebaseNetworkService>()),
        ),
        RepositoryProvider<SaveNetworkCardUseCase>(
          create: (ctx) => SaveNetworkCardUseCase(ctx.read<NetworkRepository>()),
        ),
        RepositoryProvider<GetNetworkCardsUseCase>(
          create: (ctx) => GetNetworkCardsUseCase(ctx.read<NetworkRepository>()),
        ),
        RepositoryProvider<DeleteNetworkCardUseCase>(
          create: (ctx) => DeleteNetworkCardUseCase(ctx.read<NetworkRepository>()),
        ),
        RepositoryProvider<FirebaseMyCardService>(
          create: (_) => FirebaseMyCardService(),
        ),
        RepositoryProvider<MyCardRepository>(
          create: (ctx) => MyCardRepositoryImpl(ctx.read<FirebaseMyCardService>()),
        ),
        RepositoryProvider<SaveMyCardUseCase>(
          create: (ctx) => SaveMyCardUseCase(ctx.read<MyCardRepository>()),
        ),
        RepositoryProvider<UpdateMyCardUseCase>(
          create: (ctx) => UpdateMyCardUseCase(ctx.read<MyCardRepository>()),
        ),
        RepositoryProvider<GetMyCardsUseCase>(
          create: (ctx) => GetMyCardsUseCase(ctx.read<MyCardRepository>()),
        ),
        RepositoryProvider<DeleteMyCardUseCase>(
          create: (ctx) => DeleteMyCardUseCase(ctx.read<MyCardRepository>()),
        ),
        RepositoryProvider<ExternalAppService>(
          create: (_) => ExternalAppService(),
        ),
        RepositoryProvider<FirebaseImageToTextService>(
          create: (_) => FirebaseImageToTextService(),
        ),
        RepositoryProvider<ImageToTextRepository>(
          create: (ctx) => ImageToTextRepositoryImpl(ctx.read<FirebaseImageToTextService>()),
        ),
        RepositoryProvider<FirebasePdfService>(
          create: (_) => FirebasePdfService(),
        ),
        RepositoryProvider<PdfRepository>(
          create: (ctx) => PdfRepositoryImpl(ctx.read<FirebasePdfService>()),
        ),
        RepositoryProvider<FirebaseSignedDocsService>(
          create: (_) => FirebaseSignedDocsService(),
        ),
        RepositoryProvider<SignedDocumentRepository>(
          create: (ctx) =>
              SignedDocumentRepositoryImpl(ctx.read<FirebaseSignedDocsService>()),
        ),
        RepositoryProvider<GetImageToTextListUseCase>(
          create: (ctx) => GetImageToTextListUseCase(ctx.read<ImageToTextRepository>()),
        ),
        RepositoryProvider<UpdateImageToTextUseCase>(
          create: (ctx) => UpdateImageToTextUseCase(ctx.read<ImageToTextRepository>()),
        ),
        RepositoryProvider<DeleteImageToTextUseCase>(
          create: (ctx) => DeleteImageToTextUseCase(ctx.read<ImageToTextRepository>()),
        ),
        RepositoryProvider<GetPdfDocumentsUseCase>(
          create: (ctx) => GetPdfDocumentsUseCase(ctx.read<PdfRepository>()),
        ),
        RepositoryProvider<UploadPdfDocumentUseCase>(
          create: (ctx) => UploadPdfDocumentUseCase(ctx.read<PdfRepository>()),
        ),
        RepositoryProvider<GetSignedDocumentsUseCase>(
          create: (ctx) =>
              GetSignedDocumentsUseCase(ctx.read<SignedDocumentRepository>()),
        ),
        RepositoryProvider<DeleteSignedDocumentUseCase>(
          create: (ctx) =>
              DeleteSignedDocumentUseCase(ctx.read<SignedDocumentRepository>()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SignupCubit>(
            create: (ctx) => SignupCubit(ctx.read<SignUpUseCase>()),
          ),
          BlocProvider<LoginCubit>(
            create: (ctx) => LoginCubit(ctx.read<SignInUseCase>()),
          ),
          BlocProvider<LogoutCubit>(
            create: (ctx) => LogoutCubit(ctx.read<SignOutUseCase>()),
          ),
          BlocProvider<DeleteAccountCubit>(
            create: (ctx) => DeleteAccountCubit(ctx.read<DeleteAccountUseCase>()),
          ),
          BlocProvider<NetworkCubit>(
            create: (ctx) => NetworkCubit(
              ctx.read<SaveNetworkCardUseCase>(),
              ctx.read<GetNetworkCardsUseCase>(),
              ctx.read<DeleteNetworkCardUseCase>(),
            ),
          ),
          BlocProvider<MyCardCubit>(
            create: (ctx) => MyCardCubit(
              ctx.read<SaveMyCardUseCase>(),
              ctx.read<UpdateMyCardUseCase>(),
              ctx.read<GetMyCardsUseCase>(),
              ctx.read<DeleteMyCardUseCase>(),
            ),
          ),
          BlocProvider<ImageToTextCubit>(
            create: (ctx) => ImageToTextCubit(
              ctx.read<GetImageToTextListUseCase>(),
              ctx.read<UpdateImageToTextUseCase>(),
              ctx.read<DeleteImageToTextUseCase>(),
            ),
          ),
          BlocProvider<ConvertPdfCubit>(
            create: (ctx) => ConvertPdfCubit(
              ctx.read<GetPdfDocumentsUseCase>(),
              ctx.read<UploadPdfDocumentUseCase>(),
            ),
          ),
          BlocProvider<SignedDocsCubit>(
            create: (ctx) =>
                SignedDocsCubit(
              ctx.read<GetSignedDocumentsUseCase>(),
              ctx.read<DeleteSignedDocumentUseCase>(),
            ),
          ),
        ],
        child: child,
      ),
    );
  }
}
