// 웹에서만 사용되는 헬퍼 함수
import 'package:flutter/foundation.dart' show kIsWeb;

void openUrlInWeb(String url) {
  if (kIsWeb) {
    // 조건부 import를 사용하여 웹에서만 dart:html을 사용
    // 실제 구현은 app_bar_widget에서 처리
  }
}

