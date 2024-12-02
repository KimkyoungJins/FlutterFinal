import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';

class SignInPage extends StatelessWidget {
  final AuthService _authService = AuthService();

  SignInPage({super.key});

  void _showError(BuildContext context, String message) {
    // 에러 메시지를 보여주는 함수
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인 페이지'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Google 로그인 버튼
              ElevatedButton(
                onPressed: () async {
                  try {
                    await _authService.signInWithGoogle();
                  } on FirebaseAuthException catch (e) {
                    _showError(context, e.message ?? '인증 에러가 발생했습니다.');
                  } catch (e) {
                    _showError(context, '에러가 발생했습니다.');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent, // 버튼 색상
                ),
                child: Text('Google로 로그인'),
              ),
              const SizedBox(height: 16.0),
              // 익명 로그인 버튼
              ElevatedButton(
                onPressed: () async {
                  try {
                    await _authService.signInAnonymously();
                  } on FirebaseAuthException catch (e) {
                    _showError(context, e.message ?? '인증 에러가 발생했습니다.');
                  } catch (e) {
                    _showError(context, '에러가 발생했습니다.');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey, // 버튼 색상
                ),
                child: Text('게스트로 로그인'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
