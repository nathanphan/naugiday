import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:naugiday/presentation/screens/home_screen.dart';

import 'package:naugiday/presentation/screens/scan_screen.dart';
import 'package:naugiday/presentation/screens/my_recipes_screen.dart';
import 'package:naugiday/presentation/screens/recipe_detail_screen.dart';
import 'package:naugiday/presentation/screens/create_recipe_screen.dart';
import 'package:naugiday/domain/entities/recipe.dart';

part 'app_router.g.dart';

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'scan',
            builder: (context, state) => const ScanScreen(),
          ),
          GoRoute(
            path: 'my-recipes',
            builder: (context, state) => const MyRecipesScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/suggestions',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return RecipeSuggestionsScreen(
            imagePaths: extra['images'] as List<String>,
            mealType: extra['mealType'] as MealType,
          );
        },
      ),
      GoRoute(
        path: '/create-recipe',
        builder: (context, state) => const CreateRecipeScreen(),
      ),
      GoRoute(
        path: '/recipe-detail',
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
