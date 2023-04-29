import 'package:couple_share_schedule/provider/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FullImageScreen extends ConsumerStatefulWidget {
  const FullImageScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FullImageScreenState();
}

class _FullImageScreenState extends ConsumerState<FullImageScreen> {
  @override
  Widget build(BuildContext context) {
    String currentUserPhotoURL;
    if (ref.watch(currentUserProvider) == null) {
      currentUserPhotoURL = FirebaseAuth.instance.currentUser!.photoURL ?? "";
    } else {
      currentUserPhotoURL = ref.watch(currentUserProvider)!.photoURL ?? "";
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text("編集"),
          )
        ],
      ),
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Image.network(currentUserPhotoURL),
        ),
      ),
    );
  }
}
