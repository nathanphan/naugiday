import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naugiday/domain/entities/meal_type.dart';

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
      appBar: AppBar(
        title: const Text('NauGiDay'),
        actions: [
          IconButton(
            icon: const Icon(Icons.book),
            onPressed: () => context.go('/my-recipes'),
            tooltip: 'My Recipes',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'What are we cooking for?',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SegmentedButton<MealType>(
              segments: const [
                ButtonSegment(value: MealType.breakfast, label: Text('Breakfast')),
                ButtonSegment(value: MealType.lunch, label: Text('Lunch')),
                ButtonSegment(value: MealType.dinner, label: Text('Dinner')),
              ],
              selected: {_selectedMealType},
              onSelectionChanged: (Set<MealType> newSelection) {
                setState(() {
                  _selectedMealType = newSelection.first;
                });
              },
            ),
            const Spacer(),
            FilledButton.icon(
              onPressed: () {
                // Pass meal type to scan screen via extra or query param
                context.go('/scan', extra: _selectedMealType);
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('Scan Ingredients'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                textStyle: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
