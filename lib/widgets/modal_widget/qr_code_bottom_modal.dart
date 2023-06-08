//Author : muhyun-kim
//Modified : 2023/06/07
//Function : ログイン状態の時、最初表示される画面

import 'package:couple_share_schedule/widgets/left_menu_widget/user_qrcode.dart';
import 'package:flutter/material.dart';

class QrCodeBottomModal {
  static void show(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      context: context,
      builder: (BuildContext buildContext) {
        return const UserQRCode();
      },
    );
  }
}