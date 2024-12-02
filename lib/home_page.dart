import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';

class HomePage extends StatelessWidget {
  final User user;
  final AuthService _authService = AuthService();

  HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    String displayName = user.displayName ?? '게스트';
    String email = user.email ?? '이메일 없음';
    String uid = user.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('홈 페이지'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '환영합니다, $displayName 님!',
                style: const TextStyle(fontSize: 24.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                'UID: $uid',
                style: const TextStyle(fontSize: 16.0),
              ),
              if (user.photoURL != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundImage: NetworkImage(user.photoURL!),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
