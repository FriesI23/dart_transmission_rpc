// Copyright (c) 2024 Fries_I23
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

class TransmissionError implements Exception {
  final String reason;

  const TransmissionError(this.reason);

  @override
  String toString() {
    return "TransmissionError: $reason";
  }
}

class TransmissionAuthError extends TransmissionError {
  const TransmissionAuthError(super.reason);
  @override
  String toString() {
    return "TransmissionAuthError: $reason";
  }
}

class TranmissionConnectionError extends TransmissionError {
  const TranmissionConnectionError(super.reason);
  @override
  String toString() {
    return "TranmissionConnectionError: $reason";
  }
}

class TransmissionTimeoutError extends TransmissionError {
  const TransmissionTimeoutError(super.reason);
  @override
  String toString() {
    return "TransmissionTimeoutError: $reason";
  }
}

class TranmissionMaxRetryRequestError extends TransmissionError {
  final int retryCount;

  const TranmissionMaxRetryRequestError(super.reason, this.retryCount);
  @override
  String toString() {
    return "TranmissionMaxRetryRequestError: $reason, for $retryCount times";
  }
}

class TransmissionRpcDataError extends TransmissionError {
  const TransmissionRpcDataError(super.reason);
  @override
  String toString() {
    return "TransmissionRpcDataError: $reason";
  }
}

class TransmissionCheckError extends TransmissionError {
  const TransmissionCheckError(super.reason);
  @override
  String toString() {
    return "TransmissionCheckError: $reason";
  }
}

class TransmissionVersionError extends TransmissionCheckError {
  final num serverRpcVersion;
  final num serverRpcVersionMinimum;
  const TransmissionVersionError(
    super.reason,
    this.serverRpcVersion,
    this.serverRpcVersionMinimum,
  );

  @override
  String toString() {
    return "TransmissionVersionError: $reason, "
        "version=[$serverRpcVersionMinimum,$serverRpcVersion]";
  }
}
