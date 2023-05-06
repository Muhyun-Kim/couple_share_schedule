//Author : muhyun-kim
//Modified : 2023/05/06
//Function : ログイン状態の時、最初表示される画面

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentUserProvider =
    StateNotifierProvider<AuthState, User?>((ref) => AuthState(ref));

class AuthState extends StateNotifier<User?> {
  AuthState(this.ref) : super(null);
  Ref ref;

  void setUser(User user) {
    state = user;
    ref.invalidate(currentUserProvider);
  }

  String getCurrentUserName() {
    return state?.displayName ?? "ゲスト";
  }

  String getCurrentUserPhotoURL() {
    return state?.photoURL ?? "";
  }

  String getCurrentUserUid() {
    return state?.uid ?? "";
  }
}
