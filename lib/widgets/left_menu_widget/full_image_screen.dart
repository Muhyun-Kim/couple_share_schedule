import 'dart:io';

import 'package:couple_share_schedule/provider/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final storage = FirebaseStorage.instance;
final storageRef = storage.ref();
final userUid = FirebaseAuth.instance.currentUser!.uid;

class FullImageScreen extends StatefulHookConsumerWidget {
  const FullImageScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FullImageScreenState();
}

class _FullImageScreenState extends ConsumerState<FullImageScreen> {
  final profileImgRef = storageRef.child("profileImg/$userUid");
  //function to get image from gallery

  File? image;
  // 画像をギャラリーから選ぶ関数
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  //function to upload image to firebase storage
  Future uploadImageToStorage(BuildContext context) async {
    if (image != null) {
      try {
        await profileImgRef.putFile(image!);
      } on FirebaseException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message!),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("画像が選択されていません"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //profile image provider
    String currentUserPhotoURL;
    var watchCurrentUser = ref.watch(currentUserProvider);
    currentUserPhotoURL = watchCurrentUser == null
        ? FirebaseAuth.instance.currentUser!.photoURL ?? ""
        : watchCurrentUser.photoURL ?? "";

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(
            Icons.cancel,
            color: Color.fromARGB(255, 103, 103, 103),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            child: const Text(
              "編集",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
            onPressed: () {
              pickImage();
            },
          ),
          if (image != null)
            TextButton(
              child: const Text(
                "決定",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () async {
                await uploadImageToStorage(context);
                if (mounted) {
                  final chagedUserImg = await profileImgRef.getDownloadURL();
                  await FirebaseAuth.instance.currentUser!
                      .updatePhotoURL(chagedUserImg);
                  if (mounted) {
                    Navigator.pop(context);
                    final user = FirebaseAuth.instance.currentUser!;
                    final userProvider = ref.read(currentUserProvider.notifier);
                    userProvider.setUser(user);
                  }
                }
              },
            ),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: image != null
                ? Image.file(
                    image!,
                  )
                : Image(
                    image: NetworkImage(currentUserPhotoURL),
                  ),
          ),
        ),
      ),
    );
  }
}
