import 'package:flutter/material.dart';
import 'package:naugiday/domain/entities/cooking_step.dart';
import 'package:uuid/uuid.dart';

class StepsList extends StatelessWidget {
  final List<CookingStep> steps;
  final void Function(CookingStep step) onAdd;
  final void Function(int index, CookingStep step) onUpdate;
  final void Function(int index) onRemove;
  final void Function(int index) onMoveUp;
  final void Function(int index) onMoveDown;

  const StepsList({
    super.key,
    required this.steps,
    required this.onAdd,
    required this.onUpdate,
    required this.onRemove,
    required this.onMoveUp,
    required this.onMoveDown,
  });

  void _showStepDialog(BuildContext context, {CookingStep? step, int? index}) {
    final instructionCtrl =
        TextEditingController(text: step?.instruction ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(step == null ? 'Add Step' : 'Edit Step'),
        content: TextField(
          controller: instructionCtrl,
          decoration: const InputDecoration(labelText: 'Instruction'),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final text = instructionCtrl.text.trim();
              if (text.isEmpty) return;
              final newStep = step?.copyWith(instruction: text) ??
                  CookingStep(
                    id: const Uuid().v4(),
                    position: steps.length + 1,
                    instruction: text,
                  );
              if (index != null) {
                onUpdate(index, newStep);
              } else {
                onAdd(newStep);
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Save'),
          )
        ],
      ),
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
              'Cooking Steps',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () => _showStepDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Step'),
            ),
          ],
        ),
        if (steps.isEmpty) const Text('Add steps to guide cooking order.'),
        ...steps.asMap().entries.map((entry) {
          final idx = entry.key;
          final step = entry.value;
          return Card(
            child: ListTile(
              title: Text('${step.position}. ${step.instruction}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_upward),
                    onPressed: () => onMoveUp(idx),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_downward),
                    onPressed: () => onMoveDown(idx),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () =>
                        _showStepDialog(context, step: step, index: idx),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => onRemove(idx),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
