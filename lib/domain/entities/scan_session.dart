import 'package:freezed_annotation/freezed_annotation.dart';

part 'scan_session.freezed.dart';
part 'scan_session.g.dart';

enum ScanSessionState {
  normal,
  initializing,
  cameraUnavailable,
  permissionDenied,
  disabled,
}

@freezed
abstract class ScanSession with _$ScanSession {
  const ScanSession._();

  const factory ScanSession({
    required String id,
    required DateTime openedAt,
    required ScanSessionState state,
    @Default(<String>[]) List<String> imageIds,
    required DateTime lastUpdatedAt,
    String? sourceScreen,
  }) = _ScanSession;

  factory ScanSession.fromJson(Map<String, dynamic> json) =>
      _$ScanSessionFromJson(json);
}
