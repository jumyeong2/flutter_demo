import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_demo/main.dart' as main_app;

class EmailSignupModal extends StatefulWidget {
  const EmailSignupModal({super.key});

  @override
  State<EmailSignupModal> createState() => _EmailSignupModalState();
}

class _EmailSignupModalState extends State<EmailSignupModal> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _wantsKakao = false;
  final _formKey = GlobalKey<FormState>();
  bool _isAgreed = false;
  bool _isSubmitting = false;
  String? _teamType; // 2인 / 3인+ / 기타
  String? _stage; // 아이디어 / 프리시드 / 시드 / 기타

  void _showPrivacyPolicyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.privacy_tip_outlined,
              color: Colors.blue[600],
              size: 28,
            ),
            const SizedBox(width: 12),
            const Text(
              '개인정보 처리방침',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '1. 수집하는 개인정보 항목',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '• 필수 항목: 이메일 주소\n• 선택 항목: 휴대폰 번호, 팀 형태, 창업 단계',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF475569),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '2. 개인정보의 처리 목적',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '• 베타 출시 안내 및 알림 발송\n• 사전 신청자 전용 할인 쿠폰 발급\n• 서비스 개선을 위한 통계 분석',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF475569),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '3. 개인정보의 보유 및 이용 기간',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '베타 출시 안내 종료 시까지 보유하며, 목적 달성 후 즉시 파기합니다.\n또한 동의 철회 시 즉시 파기합니다.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF475569),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '4. 개인정보의 제3자 제공',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '회사는 원칙적으로 이용자의 개인정보를 제3자에게 제공하지 않습니다.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF475569),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '4-1. 개인정보 처리 위탁',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '회사는 서비스 제공 및 운영을 위해 다음과 같이 개인정보 처리 업무를 위탁할 수 있습니다.\n\n• 수탁자: Google LLC(Firebase)\n• 위탁 업무: 데이터 저장 및 관리(Firestore), 웹 호스팅(Hosting), 이용 통계 분석(Analytics)\n• 보유·이용 기간: 개인정보 보유·이용기간 종료 또는 동의 철회 시까지',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF475569),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '4-2. 개인정보의 국외 이전',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '회사는 서비스 제공을 위해 이용자의 개인정보를 국외에 위치한 서버로 이전(전송·보관·처리)할 수 있습니다.\n\n• 이전 받는 자: Google LLC(Firebase) / 이전 국가: 미국 등\n• 이전 항목: 이메일, (선택) 휴대폰 번호, 팀 형태, 창업 단계, 서비스 이용 기록(접속 로그)\n• 이전 목적: 서비스 운영 및 이용 통계 분석\n• 보유·이용 기간: 개인정보 보유·이용기간 종료 또는 동의 철회 시까지',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF475569),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '5. 개인정보 보호 문의처',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '개인정보 관련 문의, 열람/정정/삭제/동의 철회 요청은 아래 채널로 접수하실 수 있습니다.\n\n• 오픈채팅 문의: https://open.kakao.com/o/sNcDRfai\n• 처리 기한: 접수 후 영업일 기준 7일 이내 회신을 원칙으로 합니다.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF475569),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '6. 처리방침의 시행 및 변경',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '• 시행일: 2026. 01. 12\n• 본 개인정보 처리방침의 내용이 추가/삭제/수정될 경우, 웹사이트를 통해 공지합니다.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF475569),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '7. 동의 거부 권리',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '개인정보 수집·이용에 대한 동의를 거부할 권리가 있습니다.\n다만, 동의를 거부할 경우 베타 출시 알림 및 혜택 제공이 제한될 수 있습니다.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF475569),
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              '확인',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    // 폼 검증
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 개인정보 동의 확인
    if (!_isAgreed) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '개인정보 수집·이용에 동의하지 않으면 다음으로 넘어갈 수 없습니다.',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
      return;
    }

    // 이벤트 트래킹: lead_submit_attempt
    main_app.MyApp.analytics.logEvent(name: 'lead_submit_attempt');
    
    setState(() {
      _isSubmitting = true;
    });

    try {
      final email = _emailController.text.trim().toLowerCase();
      final phoneRaw = _phoneController.text.trim();
      final phoneDigits = phoneRaw.replaceAll(RegExp(r'[^\d]'), '');
      final hasPhone = _wantsKakao && phoneDigits.isNotEmpty;
      final firestore = FirebaseFirestore.instance;

      // UTM 파라미터 추출
      final uri = Uri.parse(html.window.location.href);
      final utmSource = uri.queryParameters['utm_source'];
      final utmCampaign = uri.queryParameters['utm_campaign'];
      final utmAdset = uri.queryParameters['utm_adset'];
      final utmAd = uri.queryParameters['utm_ad'];

      // source 결정: utm_source가 있으면 "meta_ad", 없으면 "landing"
      final source = utmSource != null ? 'meta_ad' : 'landing';

      // 중복 체크: 이메일(필수) / 전화번호(선택)
      print('중복 체크 시작... 이메일: $email, 전화번호: ${hasPhone ? phoneDigits : "(없음)"}');

      final existingByEmail = await firestore
          .collection('leads')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      QuerySnapshot? existingByPhone;
      if (hasPhone) {
        existingByPhone = await firestore
            .collection('leads')
            .where('phone', isEqualTo: phoneDigits)
            .limit(1)
            .get();
      }

      final duplicateFound = existingByEmail.docs.isNotEmpty || (existingByPhone?.docs.isNotEmpty ?? false);
      print('중복 체크 결과: email=${existingByEmail.docs.length}개, phone=${existingByPhone?.docs.length ?? 0}개');

      if (duplicateFound) {
        // 중복 연락처인 경우
        setState(() {
          _isSubmitting = false;
        });
        // 이벤트 트래킹: lead_submit_duplicate
        main_app.MyApp.analytics.logEvent(name: 'lead_submit_duplicate');
        _showDuplicateDialog();
        return;
      }

      // Firestore에 저장
      final leadData = <String, dynamic>{
        'createdAt': FieldValue.serverTimestamp(),
        'source': source,
        'consentPrivacy': true,
      };

      // 이메일(필수) / 전화번호(선택) 저장
      leadData['email'] = email;
      if (hasPhone) {
        leadData['phone'] = phoneDigits;
      }

      // 선택 필드 저장
      if (_teamType != null && _teamType!.isNotEmpty) {
        leadData['teamType'] = _teamType;
      }
      if (_stage != null && _stage!.isNotEmpty) {
        leadData['stage'] = _stage;
      }

      // UTM 파라미터가 있으면 추가
      if (utmSource != null) {
        leadData['utmSource'] = utmSource;
      }
      if (utmCampaign != null) {
        leadData['utmCampaign'] = utmCampaign;
      }
      if (utmAdset != null) {
        leadData['utmAdset'] = utmAdset;
      }
      if (utmAd != null) {
        leadData['utmAd'] = utmAd;
      }

      print('=== Firestore 저장 시작 ===');
      print('저장할 데이터: $leadData');
      
      final docRef = await firestore.collection('leads').add(leadData);
      
      print('✅ Firestore 저장 완료! 문서 ID: ${docRef.id}');

      // 이벤트 트래킹: lead_submit_success
      main_app.MyApp.analytics.logEvent(name: 'lead_submit_success');

      // 성공 처리
      if (mounted) {
        Navigator.of(context).pop();
        _showSuccessDialog();
      }
    } catch (e, stackTrace) {
      // 에러 처리
      print('❌ === Firestore 저장 에러 ===');
      print('에러 타입: ${e.runtimeType}');
      print('에러 메시지: $e');
      print('스택 트레이스: $stackTrace');
      
      // 이벤트 트래킹: lead_submit_error
      main_app.MyApp.analytics.logEvent(name: 'lead_submit_error');
      
      setState(() {
        _isSubmitting = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('오류가 발생했습니다: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  void _showDuplicateDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.blue[600],
              size: 28,
            ),
            const SizedBox(width: 12),
            const Text(
              '이미 신청 완료',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          '이미 신청 완료되었습니다. 출시 시 동일 연락처로 안내드립니다.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              '확인',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green[600],
              size: 28,
            ),
            const SizedBox(width: 12),
            const Text(
              '신청 완료',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          '감사합니다! 🎉\n오픈 시 연락처로 우선 안내드리겠습니다.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              '확인',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallMobile = screenWidth <= 480;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: isSmallMobile ? double.infinity : 500,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.black, width: 1),
        ),
        padding: EdgeInsets.all(isSmallMobile ? 24 : 32),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 닫기 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '베타 출시 알림 신청',
                        style: TextStyle(
                          fontSize: isSmallMobile ? 20 : 24,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                SizedBox(height: isSmallMobile ? 16 : 24),
                // 사회적 증명
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F9FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFBAE6FD), width: 1),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.people,
                        color: const Color(0xFF2563EB),
                        size: isSmallMobile ? 20 : 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '창업팀 35팀이 사전 신청했습니다',
                          style: TextStyle(
                            fontSize: isSmallMobile ? 13 : 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E40AF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isSmallMobile ? 24 : 32),
                // 혜택 리스트
                Container(
                  padding: EdgeInsets.all(isSmallMobile ? 16 : 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF86EFAC), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '사전 신청 혜택',
                        style: TextStyle(
                          fontSize: isSmallMobile ? 14 : 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      SizedBox(height: isSmallMobile ? 12 : 16),
                      _buildBenefitItem('출시 즉시 우선 안내', isSmallMobile),
                      SizedBox(height: isSmallMobile ? 8 : 12),
                      _buildBenefitItem('사전 신청자 전용 30% 할인 쿠폰', isSmallMobile),
                      SizedBox(height: isSmallMobile ? 8 : 12),
                      _buildBenefitItem('Pro 질문 일부 무료 체험', isSmallMobile),
                      SizedBox(height: isSmallMobile ? 10 : 12),
                      Text(
                        '쿠폰 및 무료 체험 혜택은 출시 시점에 신청하신 연락처로 발급됩니다.',
                        style: TextStyle(
                          fontSize: isSmallMobile ? 12 : 12,
                          color: const Color(0xFF64748B),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isSmallMobile ? 24 : 32),
                // 서비스 소개 텍스트
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isSmallMobile ? 0 : 8),
                  child: Text(
                    isSmallMobile
                        ? '✓ CoSync는 말 꺼내기 어려운 질문을,\n싸움이 아닌 합의로 만듭니다.'
                        : '✓ CoSync는 말 꺼내기 어려운 질문을, 싸움이 아닌 합의로 만듭니다.',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: isSmallMobile ? 13 : 14,
                      color: const Color(0xFF64748B),
                      height: 1.6,
                    ),
                  ),
                ),
                SizedBox(height: isSmallMobile ? 24 : 32),
                // 이메일 입력 필드 (필수)
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: '이메일 (필수)',
                    hintText: 'example@company.com',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '이메일을 입력해주세요';
                    }
                    final trimmedValue = value.trim();
                    final isEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(trimmedValue);
                    if (!isEmail) {
                      return '올바른 이메일 형식을 입력해주세요';
                    }
                    return null;
                  },
                ),
                SizedBox(height: isSmallMobile ? 12 : 14),
                // 카톡 안내(선택)
                InkWell(
                  onTap: () {
                    setState(() {
                      _wantsKakao = !_wantsKakao;
                      if (!_wantsKakao) {
                        _phoneController.clear();
                      }
                    });
                  },
                  child: Row(
                    children: [
                      Checkbox(
                        value: _wantsKakao,
                        onChanged: (v) {
                          setState(() {
                            _wantsKakao = v ?? false;
                            if (!_wantsKakao) {
                              _phoneController.clear();
                            }
                          });
                        },
                        activeColor: const Color(0xFF2563EB),
                      ),
                      Expanded(
                        child: Text(
                          '카톡으로도 안내받기 (선택)',
                          style: TextStyle(
                            fontSize: isSmallMobile ? 13 : 14,
                            color: const Color(0xFF64748B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_wantsKakao) ...[
                  SizedBox(height: isSmallMobile ? 8 : 10),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: '휴대폰 번호 (선택)',
                      hintText: '010-1234-5678',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    validator: (value) {
                      if (!_wantsKakao) return null;
                      final trimmedValue = (value ?? '').trim();
                      if (trimmedValue.isEmpty) return null;
                      final digitsOnly = trimmedValue.replaceAll(RegExp(r'[^\d]'), '');
                      final isPhone = digitsOnly.startsWith('010') && (digitsOnly.length == 10 || digitsOnly.length == 11);
                      if (!isPhone) {
                        return '올바른 휴대폰 번호 형식을 입력해주세요';
                      }
                      return null;
                    },
                  ),
                ],
                SizedBox(height: isSmallMobile ? 20 : 24),
                // 팀 형태 선택 필드 (선택)
                DropdownButtonFormField<String>(
                  value: _teamType,
                  decoration: InputDecoration(
                    labelText: '팀 형태 (선택)',
                    hintText: '선택해주세요',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  items: const [
                    DropdownMenuItem(value: '2인', child: Text('2인')),
                    DropdownMenuItem(value: '3인+', child: Text('3인+')),
                    DropdownMenuItem(value: '기타', child: Text('기타')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _teamType = value;
                    });
                  },
                ),
                SizedBox(height: isSmallMobile ? 20 : 24),
                // 단계 선택 필드 (선택)
                DropdownButtonFormField<String>(
                  value: _stage,
                  decoration: InputDecoration(
                    labelText: '단계 (선택)',
                    hintText: '선택해주세요',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: '아이디어/예비창업',
                      child: Text('아이디어/예비창업 (Pre-startup)'),
                    ),
                    DropdownMenuItem(
                      value: '초기 창업',
                      child: Text('초기 창업 (Pre-seed)'),
                    ),
                    DropdownMenuItem(
                      value: '투자 유치 후 운영 중',
                      child: Text('투자 유치 후 운영 중 (Seed+)'),
                    ),
                    DropdownMenuItem(
                      value: '기타/잘 모르겠음',
                      child: Text('기타/잘 모르겠음'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _stage = value;
                    });
                  },
                ),
                SizedBox(height: isSmallMobile ? 20 : 24),
                // 개인정보 동의 체크박스
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _isAgreed,
                          onChanged: (value) {
                            setState(() {
                              _isAgreed = value ?? false;
                            });
                          },
                          activeColor: const Color(0xFF2563EB),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isAgreed = !_isAgreed;
                                    });
                                  },
                                  child: Text(
                                    '개인정보 수집·이용에 동의합니다 (필수) ',
                                    style: TextStyle(
                                      fontSize: isSmallMobile ? 13 : 14,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: '자세히 보기',
                                    style: TextStyle(
                                      fontSize: isSmallMobile ? 13 : 14,
                                      color: const Color(0xFF2563EB),
                                      fontWeight: FontWeight.w700,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()..onTap = _showPrivacyPolicyDialog,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: isSmallMobile ? 48 : 52, top: 4),
                      child: Text(
                        '수집 항목: 이메일(필수), 전화번호(선택) · 이용 목적: 베타 출시 안내/쿠폰 발송 · 보유 기간: 안내 종료 또는 동의 철회 시까지',
                        style: TextStyle(
                          fontSize: isSmallMobile ? 12 : 12,
                          color: const Color(0xFF94A3B8),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isSmallMobile ? 24 : 32),
                // Primary CTA 버튼
                SizedBox(
                  width: double.infinity,
                  height: isSmallMobile ? 52 : 56,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F172A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '알림 + 30% 쿠폰 받기',
                                style: TextStyle(
                                  fontSize: isSmallMobile ? 15 : 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, size: 20),
                            ],
                          ),
                  ),
                ),
                SizedBox(height: isSmallMobile ? 12 : 16),
                // Secondary 버튼
                SizedBox(
                  width: double.infinity,
                  height: isSmallMobile ? 52 : 56,
                  child: OutlinedButton(
                    onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF64748B),
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      '닫기',
                      style: TextStyle(
                        fontSize: isSmallMobile ? 15 : 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String text, bool isSmallMobile) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check_circle,
          size: isSmallMobile ? 18 : 20,
          color: const Color(0xFF16A34A),
        ),
        SizedBox(width: isSmallMobile ? 8 : 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: isSmallMobile ? 13 : 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1E293B),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

