class IngredientStorageException implements Exception {
  IngredientStorageException(this.message, {this.recoverable = true});

  final String message;
  final bool recoverable;

  factory IngredientStorageException.corrupted(Iterable<dynamic> keys) {
    final keyList = keys.map((k) => '$k').join(', ');
    final reason = keyList.isEmpty ? 'unknown entries' : 'entries: $keyList';
    return IngredientStorageException(
      'Ingredient storage is corrupted for $reason.',
      recoverable: true,
    );
  }

  factory IngredientStorageException.write(Object cause) {
    return IngredientStorageException(
      'Unable to write ingredient data (${cause.runtimeType}).',
      recoverable: true,
    );
  }

  factory IngredientStorageException.read(Object cause) {
    return IngredientStorageException(
      'Unable to read ingredients (${cause.runtimeType}).',
      recoverable: true,
    );
  }

  factory IngredientStorageException.validation(String message) {
    return IngredientStorageException(
      message,
      recoverable: true,
    );
  }

  @override
  String toString() => message;
}
