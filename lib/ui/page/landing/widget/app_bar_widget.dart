import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// 웹에서만 dart:html import
import 'dart:html' as html if (dart.library.html) 'dart:html';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallMobile = screenWidth <= 480;

    return AppBar(
      backgroundColor: Colors.white.withValues(alpha: 0.3),
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 65,
      title: Row(
        children: [
          Image.asset(
            'assets/CoSync.webp',
            height: isSmallMobile ? 24 : 28,
          ),
          const SizedBox(width: 8),
          Text(
            "CoSync",
            style: TextStyle(
              fontSize: isSmallMobile ? 18 : 20,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF334155),
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
      actions: [
        TextButton.icon(
          onPressed: () async {
            try {
              final urlString = 'https://open.kakao.com/o/sNcDRfai';
              
              if (kIsWeb) {
                // 웹 환경에서는 window.open 사용
                html.window.open(urlString, '_blank');
              } else {
                // 모바일/데스크톱 환경에서는 url_launcher 사용
                final url = Uri.parse(urlString);
                if (await canLaunchUrl(url)) {
                  await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  );
                } else {
                  // canLaunchUrl이 false를 반환하면 직접 시도
                  try {
                    await launchUrl(
                      url,
                      mode: LaunchMode.platformDefault,
                    );
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('링크를 열 수 없습니다.'),
                        ),
                      );
                    }
                  }
                }
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('오류가 발생했습니다: $e'),
                  ),
                );
              }
            }
          },
          icon: Icon(
            Icons.chat_bubble_outline,
            size: isSmallMobile ? 18 : 20,
            color: const Color(0xFF334155),
          ),
          label: Text(
            '1:1 문의',
            style: TextStyle(
              fontSize: isSmallMobile ? 14 : 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF334155),
            ),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(color: Colors.grey[300], height: 1.0),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(66);
}

