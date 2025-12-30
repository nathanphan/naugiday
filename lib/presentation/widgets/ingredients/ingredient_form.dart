import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naugiday/core/constants/ingredient_constants.dart';
import 'package:naugiday/domain/entities/ingredient_category.dart';
import 'package:naugiday/domain/usecases/create_category.dart';
import 'package:naugiday/presentation/providers/ingredient_filters_provider.dart';
import 'package:naugiday/presentation/providers/ingredient_form_controller.dart';
import 'package:naugiday/presentation/providers/ingredient_repository_provider.dart';
import 'package:uuid/uuid.dart';

class IngredientForm extends ConsumerStatefulWidget {
  const IngredientForm({super.key});

  @override
  ConsumerState<IngredientForm> createState() => _IngredientFormState();
}

class _IngredientFormState extends ConsumerState<IngredientForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(ingredientFormControllerProvider);
    _nameController = TextEditingController(text: state.name);
    _quantityController = TextEditingController(text: state.quantityText);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(ingredientFormControllerProvider);
    final formController = ref.read(ingredientFormControllerProvider.notifier);
    final categoriesAsync = ref.watch(ingredientCategoriesProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_nameController.text != formState.name) {
      _nameController.text = formState.name;
    }
    if (_quantityController.text != formState.quantityText) {
      _quantityController.text = formState.quantityText;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: _PhotoTile(
            onPressed: () {},
          ),
        ),
        const SizedBox(height: 16),
        const _FieldLabel('Ingredient Name'),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          textInputAction: TextInputAction.next,
          decoration: _inputDecoration(
            context,
            hintText: 'e.g. Fresh Tomatoes',
            prefixIcon: Icons.local_grocery_store,
            showClear: _nameController.text.isNotEmpty,
            onClear: () {
              _nameController.clear();
              formController.setName('');
            },
          ),
          onChanged: formController.setName,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _QuantityField(
                controller: _quantityController,
                onChanged: formController.setQuantityText,
                onIncrement: () => formController.adjustQuantity(1),
                onDecrement: () => formController.adjustQuantity(-1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _UnitField(
                unit: formState.unit,
                onChanged: formController.setUnit,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const _FieldLabel('Storage Location'),
        const SizedBox(height: 8),
        categoriesAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (_, __) => Text(
            'Unable to load categories',
            style: theme.textTheme.bodySmall,
          ),
          data: (categories) {
            if (categories.isEmpty) {
              return const SizedBox.shrink();
            }
            final ordered = _orderCategories(categories);
            if (formState.categoryId.isEmpty) {
              final defaultCategory = ordered.firstWhere(
                (category) => category.name.toLowerCase() == 'fridge',
                orElse: () => ordered.first,
              );
              WidgetsBinding.instance.addPostFrameCallback((_) {
                formController.setCategory(defaultCategory);
              });
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CategoryGrid(
                  categories: ordered,
                  selectedId: formState.categoryId,
                  onSelected: formController.setCategory,
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () => _showAddCategoryDialog(
                    context,
                    ref,
                    categories,
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Add custom location'),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        const _FieldLabel('Buy Date'),
        const SizedBox(height: 8),
        _DateField(
          icon: Icons.shopping_cart,
          value: formState.buyDate,
          placeholder: 'mm/dd/yyyy',
          onTap: () => _pickDate(
            context: context,
            initialDate: formState.buyDate ?? DateTime.now(),
            onSelected: formController.setBuyDate,
          ),
        ),
        const SizedBox(height: 16),
        _ExpiryHeader(
          label: 'Expiry Date',
          isOptional: true,
        ),
        const SizedBox(height: 8),
        _DateField(
          icon: Icons.event,
          value: formState.expiryDate,
          placeholder: 'mm/dd/yyyy',
          onTap: () => _pickDate(
            context: context,
            initialDate: formState.expiryDate ?? DateTime.now(),
            onSelected: formController.setExpiryDate,
          ),
        ),
        if (formState.expiryDate != null)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => formController.setExpiryDate(null),
              child: const Text('Clear expiry date'),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            'We\'ll remind you before it expires.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Fresh'),
          subtitle: Text(
            formState.expiryDate == null
                ? 'Used when no expiry date is set'
                : 'Expiry date determines freshness',
          ),
          value: formState.freshnessOverride ?? true,
          onChanged: formState.expiryDate == null
              ? (value) => formController.setFreshnessOverride(value)
              : null,
        ),
        if (formState.hasDuplicate)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'This name already exists. Consider editing the existing item.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.secondary,
              ),
            ),
          ),
        if (formState.errors.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: formState.errors
                  .map(
                    (error) => Text(
                      error,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }

  InputDecoration _inputDecoration(
    BuildContext context, {
    required String hintText,
    required IconData prefixIcon,
    bool showClear = false,
    VoidCallback? onClear,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: colorScheme.surface,
      prefixIcon: Icon(prefixIcon, color: colorScheme.onSurfaceVariant),
      suffixIcon: showClear
          ? IconButton(
              tooltip: 'Clear text',
              icon: Icon(Icons.cancel, color: colorScheme.onSurfaceVariant),
              onPressed: onClear,
            )
          : null,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  List<IngredientCategory> _orderCategories(
    List<IngredientCategory> categories,
  ) {
    const priority = {
      'fridge': 0,
      'pantry': 1,
      'freezer': 2,
    };
    final ordered = [...categories];
    ordered.sort((a, b) {
      final aKey = priority[a.name.toLowerCase()] ?? 100;
      final bKey = priority[b.name.toLowerCase()] ?? 100;
      if (aKey != bKey) {
        return aKey.compareTo(bKey);
      }
      return a.name.compareTo(b.name);
    });
    return ordered;
  }

  Future<void> _pickDate({
    required BuildContext context,
    required DateTime initialDate,
    required ValueChanged<DateTime?> onSelected,
  }) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 10),
    );
    if (picked != null) {
      onSelected(picked);
    }
  }

  Future<void> _showAddCategoryDialog(
    BuildContext context,
    WidgetRef ref,
    List<IngredientCategory> categories,
  ) async {
    final controller = TextEditingController();
    final created = await showDialog<IngredientCategory?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add category'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Category name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isEmpty) return;
              final exists = categories.any(
                (category) => category.name.toLowerCase() == name.toLowerCase(),
              );
              if (exists) {
                Navigator.of(ctx).pop(null);
                return;
              }
              Navigator.of(ctx).pop(
                IngredientCategory(
                  id: const Uuid().v4(),
                  name: name,
                  isCustom: true,
                  createdAt: DateTime.now(),
                ),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (created == null) return;
    final repository = ref.read(ingredientRepositoryProvider);
    final createCategory = CreateCategory(repository);
    await createCategory(created);
    ref.invalidate(ingredientCategoriesProvider);
    ref
        .read(ingredientFormControllerProvider.notifier)
        .setCategory(created);
  }
}

class _PhotoTile extends StatelessWidget {
  final VoidCallback onPressed;

  const _PhotoTile({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: 'Add photo',
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: CustomPaint(
          painter: _DashedBorderPainter(
            color: colorScheme.outlineVariant,
            radius: 20,
          ),
          child: SizedBox(
            height: 128,
            width: 128,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      Icons.add_a_photo,
                      color: colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add Photo',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: theme.textTheme.labelLarge?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _QuantityField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _QuantityField({
    required this.controller,
    required this.onChanged,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel('Quantity'),
        const SizedBox(height: 8),
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Row(
            children: [
              IconButton(
                tooltip: 'Decrease quantity',
                onPressed: onDecrement,
                icon: Icon(Icons.remove, color: colorScheme.primary),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '0',
                  ),
                  onChanged: onChanged,
                ),
              ),
              IconButton(
                tooltip: 'Increase quantity',
                onPressed: onIncrement,
                icon: Icon(Icons.add, color: colorScheme.primary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UnitField extends StatelessWidget {
  final String unit;
  final ValueChanged<String> onChanged;

  const _UnitField({
    required this.unit,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final units = unit.isEmpty || defaultIngredientUnits.contains(unit)
        ? defaultIngredientUnits
        : [...defaultIngredientUnits, unit];
    final selectedUnit = unit.isEmpty ? defaultIngredientUnits.first : unit;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel('Unit'),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedUnit,
          items: units
              .map(
                (value) => DropdownMenuItem(
                  value: value,
                  child: Text(value),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value == null) return;
            onChanged(value);
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: colorScheme.surface,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
        ),
      ],
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  final List<IngredientCategory> categories;
  final String selectedId;
  final ValueChanged<IngredientCategory> onSelected;

  const _CategoryGrid({
    required this.categories,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.95,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: categories
          .map(
            (category) => _CategoryTile(
              category: category,
              isSelected: category.id == selectedId,
              onSelected: onSelected,
            ),
          )
          .toList(growable: false),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final IngredientCategory category;
  final bool isSelected;
  final ValueChanged<IngredientCategory> onSelected;

  const _CategoryTile({
    required this.category,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final icon = _iconForCategory(category.name);
    return Semantics(
      button: true,
      selected: isSelected,
      label: category.name,
      child: InkWell(
        onTap: () => onSelected(category),
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primaryContainer
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      icon,
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  category.name,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _iconForCategory(String name) {
    switch (name.toLowerCase()) {
      case 'fridge':
        return Icons.kitchen;
      case 'pantry':
        return Icons.storefront;
      case 'freezer':
        return Icons.ac_unit;
      case 'produce':
        return Icons.local_florist;
      case 'dairy':
        return Icons.icecream;
      case 'meat':
        return Icons.restaurant;
      case 'seafood':
        return Icons.set_meal;
      case 'bakery':
        return Icons.cake;
      case 'beverages':
        return Icons.local_cafe;
      case 'spices':
        return Icons.spa;
      default:
        return Icons.category;
    }
  }
}

class _DateField extends StatelessWidget {
  final IconData icon;
  final DateTime? value;
  final String placeholder;
  final VoidCallback onTap;

  const _DateField({
    required this.icon,
    required this.value,
    required this.placeholder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final label = value == null
        ? placeholder
        : MaterialLocalizations.of(context).formatShortDate(value!);
    return Semantics(
      button: true,
      label: 'Select date',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: InputDecorator(
          decoration: InputDecoration(
            filled: true,
            fillColor: colorScheme.surface,
            prefixIcon: Icon(icon, color: colorScheme.onSurfaceVariant),
            suffixIcon: Icon(
              Icons.expand_more,
              color: colorScheme.onSurfaceVariant,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: value == null
                  ? colorScheme.onSurfaceVariant
                  : colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _ExpiryHeader extends StatelessWidget {
  final String label;
  final bool isOptional;

  const _ExpiryHeader({
    required this.label,
    this.isOptional = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _FieldLabel(label),
        if (isOptional)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: colorScheme.outline,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Optional',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;
  final double dashWidth;
  final double dashSpace;

  const _DashedBorderPainter({
    required this.color,
    required this.radius,
    this.dashWidth = 6,
    this.dashSpace = 6,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, next),
          paint,
        );
        distance = next + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.radius != radius ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace;
  }
}
