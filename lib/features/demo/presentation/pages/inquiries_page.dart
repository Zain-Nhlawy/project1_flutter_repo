import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/config/theme/snackbar_theme.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/core/dummy/dummy_entities.dart';
import 'package:project1/core/presentation/widgets/app_skeletonizer.dart';
import 'package:project1/features/demo/domain/entities/inquiry_entity.dart';
import 'package:project1/features/demo/presentation/cubit/inquiry%20cubit/inquiry_cubit.dart';
import 'package:project1/features/demo/presentation/cubit/inquiry%20cubit/inquiry_state.dart';
import 'package:project1/features/demo/presentation/widgets/inquiries_widgets/create_inquiry_dialog.dart';
import 'package:project1/features/demo/presentation/widgets/inquiries_widgets/inquiry_card_widget.dart';
import 'package:project1/features/demo/presentation/widgets/inquiries_widgets/inquiry_detail_dialog.dart';
import 'package:project1/l10n/app_localizations.dart';

class InquiriesPage extends StatelessWidget {
  final String demoId;
  final bool isOwner;

  const InquiriesPage({super.key, required this.demoId, required this.isOwner});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InquiryCubit>(
      create: (context) {
        final cubit = getIt<InquiryCubit>();
        if (isOwner) {
          cubit.getInquiriesForOwner(demoId);
        } else {
          cubit.getInquiriesForMember(demoId);
        }
        return cubit;
      },
      child: _InquiriesPageView(demoId: demoId, isOwner: isOwner),
    );
  }
}

class _InquiriesPageView extends StatefulWidget {
  final String demoId;
  final bool isOwner;

  const _InquiriesPageView({required this.demoId, required this.isOwner});

  @override
  State<_InquiriesPageView> createState() => _InquiriesPageViewState();
}

class _InquiriesPageViewState extends State<_InquiriesPageView> {
  List<InquiryEntity> _inquiries = [];

  void _fetchData(BuildContext context) {
    final cubit = context.read<InquiryCubit>();
    if (widget.isOwner) {
      cubit.getInquiriesForOwner(widget.demoId);
    } else {
      cubit.getInquiriesForMember(widget.demoId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final topPadding = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      floatingActionButton: !widget.isOwner
          ? Container(
              decoration: BoxDecoration(
                gradient: AppColors.headerGradientOf(context),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryOf(context).withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: FloatingActionButton.extended(
                onPressed: () {
                  final cubit = context.read<InquiryCubit>();
                  CreateInquiryDialog.show(
                    context,
                    demoId: widget.demoId,
                    inquiryCubit: cubit,
                  );
                },
                backgroundColor: Colors.transparent,
                elevation: 0,
                icon: const Icon(
                  Icons.add_comment_rounded,
                  color: Colors.white,
                ),
                label: Text(
                  l10n.createInquiry,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            )
          : null,
      body: Column(
        children: [
          // Header Section with App Header Gradient
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: AppColors.headerGradientOf(context),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryOf(context).withValues(alpha: 0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(
                top: topPadding > 0 ? topPadding + 8 : 32,
                left: 20,
                right: 20,
                bottom: 18,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints.tightFor(
                            width: 38,
                            height: 38,
                          ),
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            color: AppColors.surface,
                            size: 17,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          widget.isOwner ? l10n.inquiries : l10n.sendInquiries,
                          style: AppTextStyles.h3.copyWith(
                            color: AppColors.surface,
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.inquiriesDescription,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.surface.withValues(alpha: 0.85),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Body List
          Expanded(
            child: BlocConsumer<InquiryCubit, InquiryState>(
              listener: (context, state) {
                if (state is InquiryCreated) {
                  SnackbarTheme().newSnackBarSuccess(
                    context,
                    l10n.inquirySentSuccessfully,
                  );
                  _fetchData(context);
                } else if (state is InquiryReplied) {
                  SnackbarTheme().newSnackBarSuccess(
                    context,
                    l10n.replySentSuccessfully,
                  );
                  _fetchData(context);
                } else if (state is InquiryDeleted) {
                  _fetchData(context);
                } else if (state is InquiryError) {
                  SnackbarTheme().newSnackBarError(context, state.message);
                }
              },
              builder: (context, state) {
                if (state is InquiryLoaded) {
                  _inquiries = state.inquiries;
                }

                if (state is InquiryLoading && _inquiries.isEmpty) {
                  return AppSkeletonizer(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 80),
                      itemCount: 4,
                      itemBuilder: (context, index) => InquiryCardWidget(
                        inquiry: dummyInquiry,
                        isOwner: widget.isOwner,
                        onTap: () {},
                      ),
                    ),
                  );
                }

                if (_inquiries.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () async => _fetchData(context),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryOf(
                                      context,
                                    ).withValues(alpha: 0.08),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.mark_unread_chat_alt_outlined,
                                    size: 48,
                                    color: AppColors.primaryOf(context),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  l10n.noInquiriesYet,
                                  style: AppTextStyles.titleMedium.copyWith(
                                    color: AppColors.textPrimaryOf(context),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async => _fetchData(context),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 80),
                    itemCount: _inquiries.length,
                    itemBuilder: (context, index) {
                      final inquiry = _inquiries[index];
                      return InquiryCardWidget(
                        inquiry: inquiry,
                        isOwner: widget.isOwner,
                        onTap: () {
                          final cubit = context.read<InquiryCubit>();
                          InquiryDetailDialog.show(
                            context,
                            inquiry: inquiry,
                            isOwner: widget.isOwner,
                            demoId: widget.demoId,
                            inquiryCubit: cubit,
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
