import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
final userIdProvider = Provider<String?>((ref) => ref.watch(userProvider).currentUser?.uid);
final userNameProvider = Provider<String?>((ref) => ref.watch(userProvider).currentUser?.displayName);
final userImgProvider = Provider<String?>((ref) => ref.watch(userProvider).currentUser?.photoURL);
