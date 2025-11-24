import 'dart:io';
import 'package:business_card_scanner/core/routes/routes.dart';
import 'package:business_card_scanner/core/services/external_app_service.dart';
import 'package:business_card_scanner/core/theme/app_colors.dart';
import 'package:business_card_scanner/core/utils/custom_snack.dart';
import 'package:business_card_scanner/core/widgets/custom_loader.dart';
import 'package:business_card_scanner/core/widgets/popup_item.dart';
import 'package:business_card_scanner/features/tools/domain/entities/signed_document_model.dart';
import 'package:business_card_scanner/features/tools/presentation/cubit/signed_docs_cubit.dart';
import 'package:business_card_scanner/features/tools/presentation/cubit/signed_docs_state.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SignDocumentScreen extends StatefulWidget {
  const SignDocumentScreen({super.key});

  @override
  State<SignDocumentScreen> createState() => _SignDocumentScreenState();
}

class _SignDocumentScreenState extends State<SignDocumentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchSignedDocs());
  }

  void _fetchSignedDocs() {
    final user = fb.FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<SignedDocsCubit>().fetchSignedDocuments(user.uid);
    }
  }

  Future<void> _pickPdfFile() async {
    try {
      final externalAppService = context.read<ExternalAppService>();
      final pdfResult = await externalAppService.pickPdfFile();

      if (pdfResult == null || !mounted) {
        return;
      }

      // Navigate to SignCanvasScreen with the PDF file using go_router
      await context.push(
        Routes.signCanvas,
        extra: {
          'documentTitle': pdfResult.fileName,
          'pdfFilePath': pdfResult.file.path,
        },
      );
      if (!mounted) return;
      _fetchSignedDocs();
    } catch (e) {
      if (!mounted) return;
      CustomSnack.warning('Failed to pick PDF file: $e', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = fb.FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Document'),
        backgroundColor: AppColors.scaffoldBG,
      ),
      body: user == null
          ? _buildAuthRequiredState(context)
          : BlocBuilder<SignedDocsCubit, SignedDocsState>(
              builder: (context, state) {
                if (state.isLoading && state.documents.isEmpty) {
                  return const CustomLoader();
                }

                if (state.error != null && state.documents.isEmpty) {
                  return _buildStatusMessage(
                    context,
                    'Failed to load signed documents.',
                    Icons.error_outline,
                    actionLabel: 'Retry',
                    onAction: _fetchSignedDocs,
                  );
                }

                if (state.documents.isEmpty) {
                  return _buildStatusMessage(
                    context,
                    'No signed documents yet.\nTap the floating button to add one.',
                    Icons.description_outlined,
                    actionLabel: 'Refresh',
                    onAction: _fetchSignedDocs,
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    final refreshedUser = fb.FirebaseAuth.instance.currentUser;
                    if (refreshedUser != null) {
                      await context
                          .read<SignedDocsCubit>()
                          .fetchSignedDocuments(refreshedUser.uid);
                    }
                  },
                  child: _SignedDocsListView(
                    documents: state.documents,
                    onOpenPdf: _openSignedPdf,
                    onShare: _shareSignedDocument,
                    onDownload: _downloadSignedDocument,
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickPdfFile,
        child: const Icon(Icons.note_alt_outlined),
      ),
    );
  }

  Widget _buildAuthRequiredState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.lock_outline,
            size: 52,
            color: AppColors.gray500,
          ),
          const SizedBox(height: 12),
          Text(
            'Please sign in to view your signed documents.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.gray600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _openSignedPdf(String url) async {
    if (url.isEmpty) {
      if (mounted) {
        CustomSnack.warning('No PDF URL found for this document.', context);
      }
      return;
    }

    final uri = Uri.tryParse(url);
    if (uri == null) {
      if (mounted) {
        CustomSnack.warning('Invalid PDF URL.', context);
      }
      return;
    }

    try {
      final launched =
          await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && mounted) {
        CustomSnack.warning('Unable to open PDF.', context);
      }
    } catch (e) {
      if (mounted) {
        CustomSnack.warning('Failed to open PDF: $e', context);
      }
    }
  }

  Future<void> _shareSignedDocument(SignedDocumentModel doc) async {
    if (doc.pdfUrl.isEmpty) {
      if (mounted) {
        CustomSnack.warning('No PDF URL available to share.', context);
      }
      return;
    }

    try {
      final externalAppService = context.read<ExternalAppService>();
      final shareText =
          'Signed document "${doc.title.isNotEmpty ? doc.title : 'Untitled'}": ${doc.pdfUrl}';
      await externalAppService.shareContent(
        shareText,
        // subject: doc.title,
      );
    } catch (e) {
      if (mounted) {
        CustomSnack.warning('Failed to share document: $e', context);
      }
    }
  }

  Future<void> _downloadSignedDocument(SignedDocumentModel doc) async {
    if (doc.pdfUrl.isEmpty) {
      if (mounted) {
        CustomSnack.warning('No PDF URL found to download.', context);
      }
      return;
    }

    final uri = Uri.tryParse(doc.pdfUrl);
    if (uri == null) {
      if (mounted) {
        CustomSnack.warning('Invalid PDF URL.', context);
      }
      return;
    }

    try {
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        throw Exception('Server responded with ${response.statusCode}');
      }

      final directory = await _resolveDownloadDirectory();
      final sanitizedTitle = doc.title.isNotEmpty
          ? doc.title.replaceAll(RegExp(r'[^a-zA-Z0-9_\- ]'), '_')
          : 'signed_document';
      final file = File('${directory.path}/$sanitizedTitle.pdf');
      await file.writeAsBytes(response.bodyBytes, flush: true);

      if (mounted) {
        CustomSnack.success('Document saved to ${file.path}', context);
      }
    } catch (e) {
      if (mounted) {
        CustomSnack.warning('Failed to download document: $e', context);
      }
    }
  }

  Future<Directory> _resolveDownloadDirectory() async {
    if (Platform.isAndroid) {
      final directories =
          await getExternalStorageDirectories(type: StorageDirectory.downloads);
      if (directories != null && directories.isNotEmpty) {
        return directories.first;
      }
      final fallback = await getExternalStorageDirectory();
      if (fallback != null) {
        return fallback;
      }
    } else if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory();
    } else {
      final downloadsDirectory = await getDownloadsDirectory();
      if (downloadsDirectory != null) {
        return downloadsDirectory;
      }
    }

    return await getApplicationDocumentsDirectory();
  }

  Widget _buildStatusMessage(
    BuildContext context,
    String message,
    IconData icon, {
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: AppColors.gray400),
            const SizedBox(height: 12),
            Text(
              message,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.gray600),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: onAction,
                child: Text(actionLabel),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class _SignedDocsListView extends StatelessWidget {
  final List<SignedDocumentModel> documents;
  final ValueChanged<String> onOpenPdf;
  final ValueChanged<SignedDocumentModel>? onShare;
  final ValueChanged<SignedDocumentModel>? onDownload;

  const _SignedDocsListView({
    required this.documents,
    required this.onOpenPdf,
    this.onShare,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
      itemCount: documents.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final doc = documents[index];
        final subtitle = doc.createdAt != null
            ? _formatDate(doc.createdAt!)
            : 'Unknown date';

        return Material(
          color: Colors.white,
          elevation: 1,
          borderRadius: BorderRadius.circular(12),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            leading: Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.picture_as_pdf_outlined,
                color: AppColors.primary,
              ),
            ),
            title: Text(
              doc.title.isNotEmpty ? doc.title : 'Untitled document',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              subtitle,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.gray600),
            ),
            trailing: PopupMenuButton(
              icon: const Icon(
                Icons.more_horiz,
                color: Colors.black,
                size: 18,
              ),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                // open doc
                PopupMenuItem(
                  onTap: () {
                    // Navigator.of(context).pop();
                    onOpenPdf(doc.pdfUrl);
                  },
                  child: const CustomPopupItem(
                      icon: Icons.open_in_browser_outlined,
                      title: 'Open Document'),
                ),
                PopupMenuItem(
                  onTap: () {
                    onDownload?.call(doc);
                  },
                  child: const CustomPopupItem(
                      icon: Icons.download_outlined, title: 'Download'),
                ),
                // share doc
                PopupMenuItem(
                  onTap: () {
                    // Navigator.of(context).pop();
                    onShare?.call(doc);
                  },
                  child: const CustomPopupItem(
                      icon: Icons.share_outlined, title: 'Share'),
                ),
                // delete doc
                PopupMenuItem(
                  onTap: () {
                    context.read<SignedDocsCubit>().deleteSignedDocument(doc);
                  },
                  child: const CustomPopupItem(
                      icon: Icons.delete_forever_outlined, title: 'Delete'),
                ),
              ],
            ),
            // trailing: const Icon(Icons.chevron_right_rounded,
            //     color: AppColors.gray500),
            //onTap: () => onOpenPdf(doc.pdfUrl),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime dateTime) {
    final local = dateTime.toLocal();
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final month = months[local.month - 1];
    final day = local.day;
    final year = local.year;
    final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    final period = local.hour >= 12 ? 'PM' : 'AM';
    return '$month $day, $year • $hour:$minute $period';
  }
}
