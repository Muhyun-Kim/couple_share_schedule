//Author : muhyun-kim
//Modified : 2023/05/29
//Function : スケジュール共有相手情報のモデル

import 'package:freezed_annotation/freezed_annotation.dart';

part 'partner_model.freezed.dart';
part 'partner_model.g.dart';


@freezed
class PartnerModel with _$PartnerModel {
  const factory PartnerModel({
    required String partnerUid,
    required String partnerName,
  }) = _PartnerModel;

  factory PartnerModel.fromJson(Map<String, dynamic> json) =>
      _$PartnerModelFromJson(json);

}
