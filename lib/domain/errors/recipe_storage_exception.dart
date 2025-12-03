class RecipeStorageException implements Exception {
  RecipeStorageException(this.message, {this.recoverable = true});

  final String message;
  final bool recoverable;

  factory RecipeStorageException.corrupted(Iterable<dynamic> keys) {
    final keyList = keys.map((k) => '$k').join(', ');
    final reason = keyList.isEmpty ? 'unknown entries' : 'entries: $keyList';
    return RecipeStorageException(
      'Recipe storage is corrupted for $reason.',
      recoverable: true,
    );
  }

  factory RecipeStorageException.write(Object cause) {
    return RecipeStorageException(
      'Unable to write recipe data (${cause.runtimeType}).',
      recoverable: true,
    );
  }

  factory RecipeStorageException.read(Object cause) {
    return RecipeStorageException(
      'Unable to read recipes (${cause.runtimeType}).',
      recoverable: true,
    );
  }

  @override
  String toString() => message;
}
