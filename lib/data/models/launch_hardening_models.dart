class FeatureFlagRecord {
  final bool aiEnabled;
  final bool imagesEnabled;
  final bool ingredientsEnabled;
  final bool ingredientPhotosEnabled;
  final bool scanEnabled;
  final DateTime updatedAt;

  const FeatureFlagRecord({
    required this.aiEnabled,
    required this.imagesEnabled,
    required this.ingredientsEnabled,
    required this.ingredientPhotosEnabled,
    required this.scanEnabled,
    required this.updatedAt,
  });

  factory FeatureFlagRecord.fromJson(Map<String, dynamic> json) {
    return FeatureFlagRecord(
      aiEnabled: json['ai_enabled'] as bool? ?? true,
      imagesEnabled: json['images_enabled'] as bool? ?? true,
      ingredientsEnabled: json['ingredients_enabled'] as bool? ?? true,
      ingredientPhotosEnabled:
          json['ingredient_photos_enabled'] as bool? ?? true,
      scanEnabled: json['scan_enabled'] as bool? ?? true,
      updatedAt: DateTime.tryParse(json['updated_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'ai_enabled': aiEnabled,
        'images_enabled': imagesEnabled,
        'ingredients_enabled': ingredientsEnabled,
        'ingredient_photos_enabled': ingredientPhotosEnabled,
        'scan_enabled': scanEnabled,
        'updated_at': updatedAt.toIso8601String(),
      };
}

class TelemetryEventRecord {
  final String name;
  final DateTime occurredAt;
  final String? screenName;
  final Map<String, String>? metadata;

  const TelemetryEventRecord({
    required this.name,
    required this.occurredAt,
    this.screenName,
    this.metadata,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'occurred_at': occurredAt.toIso8601String(),
        if (screenName != null) 'screen_name': screenName,
        if (metadata != null) 'metadata': metadata,
      };
}

class ReleaseChecklistItemRecord {
  final String id;
  final String title;
  final String status;
  final String? owner;
  final String? notes;

  const ReleaseChecklistItemRecord({
    required this.id,
    required this.title,
    required this.status,
    this.owner,
    this.notes,
  });

  factory ReleaseChecklistItemRecord.fromJson(Map<String, dynamic> json) {
    return ReleaseChecklistItemRecord(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      owner: json['owner'] as String?,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'status': status,
        if (owner != null) 'owner': owner,
        if (notes != null) 'notes': notes,
      };
}
