import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import 'package:naugiday/domain/entities/meal_type.dart';
import 'package:naugiday/presentation/providers/telemetry_provider.dart';
import 'package:naugiday/presentation/screens/home_screen.dart';
import 'package:naugiday/presentation/screens/release_checklist_screen.dart';

import 'package:naugiday/presentation/screens/scan_screen.dart';
import 'package:naugiday/presentation/screens/my_recipes_screen.dart';
import 'package:naugiday/presentation/screens/recipe_detail_screen.dart';
import 'package:naugiday/presentation/screens/create_recipe_screen.dart';
import 'package:naugiday/presentation/screens/recipe_suggestions_screen.dart';
import 'package:naugiday/presentation/screens/shopping_list_screen.dart';
import 'package:naugiday/presentation/screens/main_scaffold.dart';
import 'package:naugiday/domain/entities/recipe.dart';

part 'app_router.g.dart';

@riverpod
GoRouter goRouter(Ref ref) {
  final rootNavigatorKey = GlobalKey<NavigatorState>();
  final shellNavigatorKey = GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    observers: [TelemetryRouteObserver(ref)],
    initialLocation: '/',
    routes: [
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) {
          return MainScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
            routes: [
              GoRoute(
                path: 'scan',
                name: 'scan',
                parentNavigatorKey: rootNavigatorKey,
                builder: (context, state) => const ScanScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/my-recipes',
            name: 'my-recipes',
            builder: (context, state) => const MyRecipesScreen(),
          ),
          GoRoute(
            path: '/shopping-list',
            name: 'shopping-list',
            builder: (context, state) => const ShoppingListScreen(),
          ),
          GoRoute(
            path: '/release-checklist',
            name: 'release-checklist',
            builder: (context, state) => const ReleaseChecklistScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/suggestions',
        name: 'suggestions',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return RecipeSuggestionsScreen(
            imagePaths: extra['images'] as List<String>,
            labels: (extra['labels'] as List<dynamic>? ?? const <dynamic>[])
                .map((e) => e.toString())
                .toList(),
            mealType: extra['mealType'] as MealType,
          );
        },
      ),
      GoRoute(
        path: '/create-recipe',
        name: 'create-recipe',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return CreateRecipeScreen(
            initialRecipe: extra != null ? extra['recipe'] as Recipe? : null,
          );
        },
      ),
      GoRoute(
        path: '/recipe-detail',
        name: 'recipe-detail',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return RecipeDetailScreen(
            recipe: extra['recipe'] as Recipe,
            detectedIngredients: extra['detected'] as List<String>,
          );
        },
      ),
    ],
  );
}

class TelemetryRouteObserver extends NavigatorObserver {
  TelemetryRouteObserver(this._ref);

  final Ref _ref;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _record(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) {
      _record(newRoute);
    }
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  void _record(Route<dynamic> route) {
    final name = route.settings.name ?? route.settings.toString();
    _ref.read(telemetryControllerProvider.notifier).recordScreenView(name);
  }
}
