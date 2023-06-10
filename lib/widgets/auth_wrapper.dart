//Author : muhyun-kim
//Modified : 2023/06/08
//Function : 最初アプリを開い際、ログイン状態による画面表示

import 'package:couple_share_schedule/provider/auth_state_provider.dart';
import 'package:couple_share_schedule/screens/home_screen.dart';
import 'package:couple_share_schedule/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthWrapper extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsync = ref.watch(authStateProvider);
    return authStateAsync.when(
      data: (user) => user != null ? HomeScreen() : LoadingScreen(),
      loading: () => const LoadingScreen(),
      error: (err, stack) => Text("Error: $err"),
    );
  }
}
