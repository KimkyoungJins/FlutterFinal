import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // FirebaseAuth 인스턴스
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Google 로그인
  Future<UserCredential> signInWithGoogle() async {
    // 사용자에게 Google 로그인 창 표시
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // 로그인 취소한 경우
    if (googleUser == null) {
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: '로그인이 취소되었습니다.',
      );
    }

    // 인증 정보 획득
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Firebase에 인증 정보 생성
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Firebase에 사용자 로그인
    return await _auth.signInWithCredential(credential);
  }

  // 익명 로그인
  Future<UserCredential> signInAnonymously() async {
    return await _auth.signInAnonymously();
  }

  // 로그아웃
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }

  // 인증 상태 변경 스트림
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
