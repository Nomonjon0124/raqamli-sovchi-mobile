import 'package:equatable/equatable.dart';

enum FailureType {
  networkTimeout,
  noInternet,
  unauthorized,
  cancelled,
  forbidden,
  notFound,
  validation,
  configuration,
  unsupported,
  server,
  unknown,
}

final class Failure extends Equatable {
  const Failure({
    required this.type,
    this.statusCode,
    this.message,
    this.technicalReason,
  });

  const Failure.networkTimeout({String? message})
    : this(type: FailureType.networkTimeout, message: message);

  const Failure.noInternet({String? message})
    : this(type: FailureType.noInternet, message: message);

  const Failure.unauthorized({String? message})
    : this(type: FailureType.unauthorized, message: message);

  const Failure.cancelled({String? message})
    : this(type: FailureType.cancelled, message: message);

  const Failure.forbidden({String? message})
    : this(type: FailureType.forbidden, message: message);

  const Failure.notFound({String? message})
    : this(type: FailureType.notFound, message: message);

  const Failure.validation({String? message})
    : this(type: FailureType.validation, message: message);

  const Failure.configuration({String? message})
    : this(type: FailureType.configuration, message: message);

  const Failure.unsupported({String? message})
    : this(type: FailureType.unsupported, message: message);

  const Failure.server({int? statusCode, String? message})
    : this(type: FailureType.server, statusCode: statusCode, message: message);

  const Failure.unknown({String? message, String? technicalReason})
    : this(
        type: FailureType.unknown,
        message: message,
        technicalReason: technicalReason,
      );

  final FailureType type;
  final int? statusCode;
  final String? message;
  final String? technicalReason;

  @override
  List<Object?> get props => [type, statusCode, message, technicalReason];
}
