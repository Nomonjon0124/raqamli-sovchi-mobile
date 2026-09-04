import 'package:equatable/equatable.dart';

enum ComplaintReason {
  abusiveLanguage('abusive_language'),
  fakeProfile('fake_profile'),
  fraud('fraud'),
  spam('spam'),
  falseInformation('false_information'),
  threat('threat'),
  noSeriousIntent('no_serious_intent'),
  other('other');

  const ComplaintReason(this.apiName);

  final String apiName;

  static ComplaintReason fromApiName(String? value) {
    return ComplaintReason.values.firstWhere(
      (reason) => reason.apiName == value,
      orElse: () => ComplaintReason.other,
    );
  }
}

enum ComplaintStatus {
  pending('pending'),
  approved('approved'),
  rejected('rejected');

  const ComplaintStatus(this.apiName);

  final String apiName;

  static ComplaintStatus fromApiName(String? value) {
    return ComplaintStatus.values.firstWhere(
      (status) => status.apiName == value,
      orElse: () => ComplaintStatus.pending,
    );
  }
}

final class Complaint extends Equatable {
  const Complaint({
    required this.id,
    required this.reason,
    required this.reasonLabel,
    required this.status,
    required this.statusLabel,
    required this.createdAt,
    required this.updatedAt,
    this.message,
    this.fromUser,
    this.toUser,
    this.chatRoom,
  });

  final String id;
  final ComplaintReason reason;
  final String reasonLabel;
  final ComplaintStatus status;
  final String statusLabel;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? message;
  final ComplaintUserShort? fromUser;
  final ComplaintUserShort? toUser;
  final ComplaintChatRoomShort? chatRoom;

  @override
  List<Object?> get props => [
    id,
    reason,
    reasonLabel,
    status,
    statusLabel,
    createdAt,
    updatedAt,
    message,
    fromUser,
    toUser,
    chatRoom,
  ];
}

final class ComplaintUserShort extends Equatable {
  const ComplaintUserShort({
    required this.id,
    required this.displayId,
    required this.fullName,
  });

  final String id;
  final String displayId;
  final String fullName;

  @override
  List<Object?> get props => [id, displayId, fullName];
}

final class ComplaintChatRoomShort extends Equatable {
  const ComplaintChatRoomShort({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}
