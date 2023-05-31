// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'partner_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PartnerModel _$PartnerModelFromJson(Map<String, dynamic> json) {
  return _PartnerModel.fromJson(json);
}

/// @nodoc
mixin _$PartnerModel {
  String get partnerUid => throw _privateConstructorUsedError;
  String get partnerName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PartnerModelCopyWith<PartnerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PartnerModelCopyWith<$Res> {
  factory $PartnerModelCopyWith(
          PartnerModel value, $Res Function(PartnerModel) then) =
      _$PartnerModelCopyWithImpl<$Res, PartnerModel>;
  @useResult
  $Res call({String partnerUid, String partnerName});
}

/// @nodoc
class _$PartnerModelCopyWithImpl<$Res, $Val extends PartnerModel>
    implements $PartnerModelCopyWith<$Res> {
  _$PartnerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? partnerUid = null,
    Object? partnerName = null,
  }) {
    return _then(_value.copyWith(
      partnerUid: null == partnerUid
          ? _value.partnerUid
          : partnerUid // ignore: cast_nullable_to_non_nullable
              as String,
      partnerName: null == partnerName
          ? _value.partnerName
          : partnerName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PartnerModelCopyWith<$Res>
    implements $PartnerModelCopyWith<$Res> {
  factory _$$_PartnerModelCopyWith(
          _$_PartnerModel value, $Res Function(_$_PartnerModel) then) =
      __$$_PartnerModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String partnerUid, String partnerName});
}

/// @nodoc
class __$$_PartnerModelCopyWithImpl<$Res>
    extends _$PartnerModelCopyWithImpl<$Res, _$_PartnerModel>
    implements _$$_PartnerModelCopyWith<$Res> {
  __$$_PartnerModelCopyWithImpl(
      _$_PartnerModel _value, $Res Function(_$_PartnerModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? partnerUid = null,
    Object? partnerName = null,
  }) {
    return _then(_$_PartnerModel(
      partnerUid: null == partnerUid
          ? _value.partnerUid
          : partnerUid // ignore: cast_nullable_to_non_nullable
              as String,
      partnerName: null == partnerName
          ? _value.partnerName
          : partnerName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PartnerModel implements _PartnerModel {
  const _$_PartnerModel({required this.partnerUid, required this.partnerName});

  factory _$_PartnerModel.fromJson(Map<String, dynamic> json) =>
      _$$_PartnerModelFromJson(json);

  @override
  final String partnerUid;
  @override
  final String partnerName;

  @override
  String toString() {
    return 'PartnerModel(partnerUid: $partnerUid, partnerName: $partnerName)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PartnerModel &&
            (identical(other.partnerUid, partnerUid) ||
                other.partnerUid == partnerUid) &&
            (identical(other.partnerName, partnerName) ||
                other.partnerName == partnerName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, partnerUid, partnerName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PartnerModelCopyWith<_$_PartnerModel> get copyWith =>
      __$$_PartnerModelCopyWithImpl<_$_PartnerModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PartnerModelToJson(
      this,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}

abstract class _PartnerModel implements PartnerModel {
  const factory _PartnerModel(
      {required final String partnerUid,
      required final String partnerName}) = _$_PartnerModel;

  factory _PartnerModel.fromJson(Map<String, dynamic> json) =
      _$_PartnerModel.fromJson;

  @override
  String get partnerUid;
  @override
  String get partnerName;
  @override
  @JsonKey(ignore: true)
  _$$_PartnerModelCopyWith<_$_PartnerModel> get copyWith =>
      throw _privateConstructorUsedError;
}
