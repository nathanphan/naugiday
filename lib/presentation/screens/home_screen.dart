import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naugiday/domain/entities/meal_type.dart';

import 'package:naugiday/presentation/widgets/home_cta_card.dart';
import 'package:naugiday/presentation/widgets/quick_actions_row.dart';
import 'package:naugiday/presentation/widgets/suggested_recipe_card.dart';
import 'package:naugiday/core/constants/app_assets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MealType _selectedMealType = MealType.dinner;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CenterTitleAppBar(
        title: const Text('NauGiDay'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(backgroundImage: AssetImage(AppAssets.appIcon)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {}, // TODO: Profile
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Meal Selector
            SegmentedButton<MealType>(
              segments: const [
                ButtonSegment(
                  value: MealType.breakfast,
                  label: Text('Breakfast'),
                  icon: Icon(Icons.wb_sunny_outlined),
                ),
                ButtonSegment(
                  value: MealType.lunch,
                  label: Text('Lunch'),
                  icon: Icon(Icons.restaurant_outlined),
                ),
                ButtonSegment(
                  value: MealType.dinner,
                  label: Text('Dinner'),
                  icon: Icon(Icons.nights_stay_outlined),
                ),
              ],
              selected: {_selectedMealType},
              onSelectionChanged: (Set<MealType> newSelection) {
                setState(() {
                  _selectedMealType = newSelection.first;
                });
              },
              showSelectedIcon: false,
            ),
            const SizedBox(height: 24),

            // Large CTA Card
            HomeCTACard(
              onTap: () => context.go('/scan', extra: _selectedMealType),
            ),
            const SizedBox(height: 24),

            // Quick Actions
            const QuickActionsRow(),
            const SizedBox(height: 24),

            // Suggested Today
            Text(
              'Suggested Today',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  SuggestedRecipeCard(
                    title: 'Spicy Tomato Pasta',
                    time: '30m',
                    calories: '450 kcal',
                  ),
                  SuggestedRecipeCard(
                    title: 'Grilled Chicken Salad',
                    time: '20m',
                    calories: '320 kcal',
                  ),
                  SuggestedRecipeCard(
                    title: 'Avocado Toast',
                    time: '10m',
                    calories: '250 kcal',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper for Center Title AppBar if not available in standard widget set yet (it is, but just to be safe/custom)
class CenterTitleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final Widget? leading;
  final List<Widget>? actions;

  const CenterTitleAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: title,
      leading: leading,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
