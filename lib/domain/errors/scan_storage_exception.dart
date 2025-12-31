class ScanStorageException implements Exception {
  ScanStorageException(this.message, {this.recoverable = true});

  final String message;
  final bool recoverable;

  factory ScanStorageException.validation(String message) {
    return ScanStorageException(message, recoverable: true);
  }

  factory ScanStorageException.write(Object cause) {
    return ScanStorageException(
      'Unable to save scan image (${cause.runtimeType}).',
      recoverable: true,
    );
  }

  @override
  String toString() => message;
}
