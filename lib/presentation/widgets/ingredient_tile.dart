import 'package:flutter/material.dart';
import 'package:naugiday/domain/entities/ingredient.dart';

class IngredientTile extends StatelessWidget {
  final Ingredient ingredient;
  final bool isAvailable;

  const IngredientTile({
    super.key,
    required this.ingredient,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        isAvailable ? Icons.check_circle : Icons.shopping_cart_outlined,
        color: isAvailable
            ? theme.colorScheme.secondary
            : theme.colorScheme.tertiary,
      ),
      title: Text(ingredient.name),
      subtitle: Text(ingredient.quantity),
      dense: false,
      minVerticalPadding: 12,
    );
  }
}
