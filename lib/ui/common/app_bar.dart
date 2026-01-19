import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_style.dart';

/// 공통 AppBar
/// 상단에 제목 + 우측에 (옵션) action
/// "Read Only" 배지 같은 작은 pill 지원
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? badge;
  final bool showBackButton;
  final VoidCallback? onBack;

  const AppAppBar({
    super.key,
    required this.title,
    this.actions,
    this.badge,
    this.showBackButton = true,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              onPressed: onBack ?? () => Navigator.of(context).pop(),
            )
          : null,
      title: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextStyle.h3(),
            ),
          ),
          if (badge != null) ...[
            const SizedBox(width: 8),
            badge!,
          ],
        ],
      ),
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          height: 1.0,
          color: AppColors.dividerGray,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1.0);
}
