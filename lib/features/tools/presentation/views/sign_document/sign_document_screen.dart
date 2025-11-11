import 'dart:io';
import 'package:business_card_scanner/core/services/external_app_service.dart';
import 'package:business_card_scanner/core/theme/app_colors.dart';
import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:business_card_scanner/core/utils/custom_snack.dart';
import 'package:business_card_scanner/core/widgets/buttons/primary_button.dart';
import 'package:business_card_scanner/core/widgets/custom_loader.dart';
import 'package:business_card_scanner/core/widgets/inputFields/empty_widget.dart';
import 'package:business_card_scanner/features/tools/presentation/cubit/convert_pdf_cubit.dart';
import 'package:business_card_scanner/features/tools/presentation/cubit/convert_pdf_state.dart';
import 'package:business_card_scanner/features/tools/presentation/widgets/pdf_document_list_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:url_launcher/url_launcher.dart';

class SignDocumentScreen extends StatefulWidget {
  const SignDocumentScreen({super.key});

  @override
  State<SignDocumentScreen> createState() => _SignDocumentScreenState();
}

class _SignDocumentScreenState extends State<SignDocumentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Document'),
        backgroundColor: AppColors.scaffoldBG,
      ),
      body: const Center(child: Text('Sign Document')),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.note_alt_outlined),
      ),
    );
  }
}
