import 'package:equatable/equatable.dart';

import '../../domain/entities/complaint.dart';

final class ComplaintModel extends Equatable {
  const ComplaintModel({
    required this.id,
    required this.reason,
    required this.reasonLabel,
    required this.status,
    required this.statusLabel,
    required this.createdAt,
    required this.updatedAt,
    this.message,
    this.evidence,
    this.fromUserInfo,
    this.toUserInfo,
    this.chatRoomInfo,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: _asString(json['id']) ?? '',
      reason: ComplaintReason.fromApiName(_asString(json['reason'])),
      reasonLabel: _asString(json['reason_label']) ?? '',
      message: _asString(json['message']),
      evidence: json['evidence'],
      status: ComplaintStatus.fromApiName(_asString(json['status'])),
      statusLabel: _asString(json['status_label']) ?? '',
      createdAt:
          _asDateTime(json['created_at']) ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      updatedAt:
          _asDateTime(json['updated_at']) ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      fromUserInfo: json['from_user_info'] is Map
          ? ComplaintUserShortModel.fromJson(_asMap(json['from_user_info']))
          : null,
      toUserInfo: json['to_user_info'] is Map
          ? ComplaintUserShortModel.fromJson(_asMap(json['to_user_info']))
          : null,
      chatRoomInfo: json['chat_room_info'] is Map
          ? ChatRoomShortModel.fromJson(_asMap(json['chat_room_info']))
          : null,
    );
  }

  final String id;
  final ComplaintReason reason;
  final String reasonLabel;
  final String? message;
  final Object? evidence;
  final ComplaintStatus status;
  final String statusLabel;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ComplaintUserShortModel? fromUserInfo;
  final ComplaintUserShortModel? toUserInfo;
  final ChatRoomShortModel? chatRoomInfo;

  Complaint toEntity() => Complaint(
    id: id,
    reason: reason,
    reasonLabel: reasonLabel,
    message: message,
    status: status,
    statusLabel: statusLabel,
    createdAt: createdAt,
    updatedAt: updatedAt,
    fromUser: fromUserInfo?.toEntity(),
    toUser: toUserInfo?.toEntity(),
    chatRoom: chatRoomInfo?.toEntity(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'reason': reason.apiName,
    'reason_label': reasonLabel,
    'message': message,
    'evidence': evidence,
    'status': status.apiName,
    'status_label': statusLabel,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'from_user_info': fromUserInfo?.toJson(),
    'to_user_info': toUserInfo?.toJson(),
    'chat_room_info': chatRoomInfo?.toJson(),
  };

  @override
  List<Object?> get props => [
    id,
    reason,
    reasonLabel,
    message,
    evidence,
    status,
    statusLabel,
    createdAt,
    updatedAt,
    fromUserInfo,
    toUserInfo,
    chatRoomInfo,
  ];
}

final class ComplaintUserShortModel extends Equatable {
  const ComplaintUserShortModel({
    required this.id,
    required this.displayId,
    required this.fullName,
    this.phoneNumber,
    this.email,
  });

  factory ComplaintUserShortModel.fromJson(Map<String, dynamic> json) {
    return ComplaintUserShortModel(
      id: _asString(json['id']) ?? '',
      phoneNumber: _asString(json['phone_number']),
      email: _asString(json['email']),
      displayId: _asString(json['display_id']) ?? '',
      fullName: _asString(json['full_name']) ?? '',
    );
  }

  final String id;
  final String? phoneNumber;
  final String? email;
  final String displayId;
  final String fullName;

  ComplaintUserShort toEntity() =>
      ComplaintUserShort(id: id, displayId: displayId, fullName: fullName);

  Map<String, dynamic> toJson() => {
    'id': id,
    'phone_number': phoneNumber,
    'email': email,
    'display_id': displayId,
    'full_name': fullName,
  };

  @override
  List<Object?> get props => [id, phoneNumber, email, displayId, fullName];
}

final class ChatRoomShortModel extends Equatable {
  const ChatRoomShortModel({required this.id});

  factory ChatRoomShortModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomShortModel(id: _asString(json['id']) ?? '');
  }

  final String id;

  ComplaintChatRoomShort toEntity() => ComplaintChatRoomShort(id: id);

  Map<String, dynamic> toJson() => {'id': id};

  @override
  List<Object?> get props => [id];
}

Map<String, dynamic> _asMap(Object? value) {
  if (value is! Map) return const <String, dynamic>{};
  return value.map((key, value) => MapEntry(key.toString(), value));
}

String? _asString(Object? value) => value?.toString();

DateTime? _asDateTime(Object? value) =>
    DateTime.tryParse(value?.toString() ?? '');
