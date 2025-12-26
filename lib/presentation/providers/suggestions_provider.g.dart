// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggestions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(suggestions)
const suggestionsProvider = SuggestionsFamily._();

final class SuggestionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<
            ({List<String> detectedIngredients, List<Recipe> recipes})
          >,
          ({List<String> detectedIngredients, List<Recipe> recipes}),
          FutureOr<({List<String> detectedIngredients, List<Recipe> recipes})>
        >
    with
        $FutureModifier<
          ({List<String> detectedIngredients, List<Recipe> recipes})
        >,
        $FutureProvider<
          ({List<String> detectedIngredients, List<Recipe> recipes})
        > {
  const SuggestionsProvider._({
    required SuggestionsFamily super.from,
    required ({
      List<String> imagePaths,
      MealType mealType,
      List<String>? labels,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'suggestionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$suggestionsHash();

  @override
  String toString() {
    return r'suggestionsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<
    ({List<String> detectedIngredients, List<Recipe> recipes})
  >
  $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<({List<String> detectedIngredients, List<Recipe> recipes})> create(
    Ref ref,
  ) {
    final argument =
        this.argument
            as ({
              List<String> imagePaths,
              MealType mealType,
              List<String>? labels,
            });
    return suggestions(
      ref,
      imagePaths: argument.imagePaths,
      mealType: argument.mealType,
      labels: argument.labels,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SuggestionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$suggestionsHash() => r'd43fb361ab1e5694f77b26382cfba5f93d8793e6';

final class SuggestionsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<({List<String> detectedIngredients, List<Recipe> recipes})>,
          ({List<String> imagePaths, MealType mealType, List<String>? labels})
        > {
  const SuggestionsFamily._()
    : super(
        retry: null,
        name: r'suggestionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SuggestionsProvider call({
    required List<String> imagePaths,
    required MealType mealType,
    List<String>? labels,
  }) => SuggestionsProvider._(
    argument: (imagePaths: imagePaths, mealType: mealType, labels: labels),
    from: this,
  );

  @override
  String toString() => r'suggestionsProvider';
}
