import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 로그아웃 함수
  Future<void> _signOut(BuildContext context) async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('로그아웃 되었습니다.')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('프로필'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: user == null
            ? Center(child: Text('사용자가 로그인되지 않았습니다.'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 사용자 사진
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: user.photoURL != null
                        ? NetworkImage(user.photoURL!)
                        : AssetImage('assets/default_profile.png') as ImageProvider,
                  ),
                  SizedBox(height: 20),
                  // 사용자 이름
                  Text(
                    user.displayName ?? '이름 없음',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  // 사용자 이메일
                  Text(
                    user.email ?? '이메일 없음',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 30),
                  // 로그아웃 버튼
                  ElevatedButton(
                    onPressed: () => _signOut(context),
                    child: Text('로그아웃'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
