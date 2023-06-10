import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authStateProvider = StreamProvider.autoDispose<User?>((ref) {
  final firebaseAuth = FirebaseAuth.instance;
  return firebaseAuth.authStateChanges();
});