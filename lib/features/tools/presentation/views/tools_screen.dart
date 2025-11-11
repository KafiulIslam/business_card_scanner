import 'package:business_card_scanner/features/tools/presentation/widgets/tool_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/routes.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ToolCard(
                  onTap: () => context.push(Routes.imageToText),
                  icon: Icons.document_scanner_outlined,
                  title: 'Image to Text',
                  subtitle: 'Convert image to editable text'),
              const Gap(16),
              ToolCard(
                  onTap: () => context.push(Routes.convertPdf),
                  icon: Icons.picture_as_pdf_outlined,
                  title: 'Convert PDF',
                  subtitle: 'Convert documents into PDFs'),
              const Gap(16),
              ToolCard(
                  onTap: () => context.push(Routes.signDocument),
                  icon: Icons.edit_note_outlined,
                  title: 'Sign Document',
                  subtitle: 'Sign documents digitally'),
            ],
          ),
        ),
      ),
    );
  }
}
