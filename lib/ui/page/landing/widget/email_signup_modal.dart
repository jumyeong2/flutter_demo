import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EmailSignupModal extends StatefulWidget {
  const EmailSignupModal({super.key});

  @override
  State<EmailSignupModal> createState() => _EmailSignupModalState();
}

class _EmailSignupModalState extends State<EmailSignupModal> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isAgreed = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate() && _isAgreed) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        final email = _emailController.text.trim().toLowerCase();
        final firestore = FirebaseFirestore.instance;

        // UTM 파라미터 추출
        final uri = Uri.parse(html.window.location.href);
        final utmSource = uri.queryParameters['utm_source'];
        final utmCampaign = uri.queryParameters['utm_campaign'];
        final utmAdset = uri.queryParameters['utm_adset'];
        final utmAd = uri.queryParameters['utm_ad'];

        // source 결정: utm_source가 있으면 "meta_ad", 없으면 "landing"
        final source = utmSource != null ? 'meta_ad' : 'landing';

        // 중복 체크: 이메일로 검색
        final existingLeads = await firestore
            .collection('leads')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

        if (existingLeads.docs.isNotEmpty) {
          // 중복 이메일인 경우
          setState(() {
            _isSubmitting = false;
          });
          _showDuplicateDialog();
          return;
        }

        // Firestore에 저장
        final leadData = <String, dynamic>{
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
          'source': source,
          'consentPrivacy': true,
        };

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

        await firestore.collection('leads').add(leadData);

        // 성공 처리
        if (mounted) {
          Navigator.of(context).pop();
          _showSuccessDialog();
        }
      } catch (e) {
        // 에러 처리
        setState(() {
          _isSubmitting = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('오류가 발생했습니다: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
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
          '이미 신청 완료되었습니다. 출시 시 동일 이메일로 안내드립니다.',
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
          '감사합니다! 🎉\n베타 출시 시 이메일로 알려드리겠습니다.\n30% 할인 쿠폰도 함께 보내드립니다.',
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
                          '이미 127명의 창업 팀이 사전 신청했습니다',
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
                      _buildBenefitItem('베타 우선 접근 또는 무료 체험 연장', isSmallMobile),
                    ],
                  ),
                ),
                SizedBox(height: isSmallMobile ? 24 : 32),
                // 이메일 입력 필드
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: '이메일 주소',
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
                    if (value == null || value.isEmpty) {
                      return '이메일을 입력해주세요';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return '올바른 이메일 형식을 입력해주세요';
                    }
                    return null;
                  },
                ),
                SizedBox(height: isSmallMobile ? 20 : 24),
                // 개인정보 동의 체크박스
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
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isAgreed = !_isAgreed;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            '개인정보 처리방침에 동의합니다 (필수)',
                            style: TextStyle(
                              fontSize: isSmallMobile ? 13 : 14,
                              color: const Color(0xFF64748B),
                            ),
                          ),
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

