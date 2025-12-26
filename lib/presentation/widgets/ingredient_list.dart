import 'package:flutter/material.dart';
import 'package:naugiday/domain/entities/ingredient.dart';
import 'package:uuid/uuid.dart';

typedef IngredientChanged = void Function(Ingredient ingredient);
typedef IngredientRemoved = void Function(int index);

class IngredientList extends StatelessWidget {
  final List<Ingredient> ingredients;
  final IngredientChanged onAdd;
  final void Function(int index, Ingredient ingredient) onUpdate;
  final IngredientRemoved onRemove;

  const IngredientList({
    super.key,
    required this.ingredients,
    required this.onAdd,
    required this.onUpdate,
    required this.onRemove,
  });

  void _showIngredientDialog(BuildContext context,
      {Ingredient? ingredient, int? index}) {
    final nameCtrl = TextEditingController(text: ingredient?.name ?? '');
    final quantityCtrl = TextEditingController(text: ingredient?.quantity ?? '');
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(ingredient == null ? 'Add Ingredient' : 'Edit Ingredient'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: quantityCtrl,
                decoration: const InputDecoration(labelText: 'Quantity'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final name = nameCtrl.text.trim();
                final qty = quantityCtrl.text.trim();
                if (name.isEmpty || qty.isEmpty) return;
                final updated = ingredient?.copyWith(
                      name: name,
                      quantity: qty,
                    ) ??
                    Ingredient(
                      id: const Uuid().v4(),
                      name: name,
                      quantity: qty,
                    );
                if (index != null) {
                  onUpdate(index, updated);
                } else {
                  onAdd(updated);
                }
                Navigator.of(ctx).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Ingredients',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () => _showIngredientDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ],
        ),
        if (ingredients.isEmpty)
          const Text('Add at least one ingredient to save the recipe.'),
        ...ingredients.asMap().entries.map(
          (entry) {
            final idx = entry.key;
            final ing = entry.value;
            return Card(
              child: ListTile(
                title: Text(ing.name),
                subtitle: Text(ing.quantity),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () =>
                          _showIngredientDialog(context, ingredient: ing, index: idx),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => onRemove(idx),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
