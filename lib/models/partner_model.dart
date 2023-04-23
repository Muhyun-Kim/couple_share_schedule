//Author : muhyun-kim
//Modified : 2023/04/22
//Function : スケジュール共有相手情報のモデル

import 'package:cloud_firestore/cloud_firestore.dart';

class PartnerModel {
  final String partnerUid;
  final String partnerName;

  PartnerModel({
    required this.partnerUid,
    required this.partnerName,
  });

  factory PartnerModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data()!;
    return PartnerModel(
      partnerUid: data["partnerUid"],
      partnerName: data["partnerName"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "partnerUid": partnerUid,
      "partnerName": partnerName,
    };
  }
}