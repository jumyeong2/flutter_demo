import 'package:flutter/material.dart';

class AgreementAdjustPage extends StatelessWidget {
  const AgreementAdjustPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agreement Adjust"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          "계속하기 후 이동하는 조율 단계 페이지입니다.",
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

