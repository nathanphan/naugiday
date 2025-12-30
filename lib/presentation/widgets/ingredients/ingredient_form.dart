import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naugiday/core/constants/ingredient_constants.dart';
import 'package:naugiday/domain/entities/ingredient_category.dart';
import 'package:naugiday/domain/entities/ingredient_photo.dart';
import 'package:naugiday/domain/usecases/create_category.dart';
import 'package:naugiday/presentation/providers/feature_flag_provider.dart';
import 'package:naugiday/presentation/providers/ingredient_filters_provider.dart';
import 'package:naugiday/presentation/providers/ingredient_form_controller.dart';
import 'package:naugiday/presentation/providers/ingredient_repository_provider.dart';
import 'package:naugiday/presentation/widgets/ingredients/ingredient_photo_viewer.dart';
import 'package:uuid/uuid.dart';

class IngredientForm extends ConsumerStatefulWidget {
  const IngredientForm({super.key});

  @override
  ConsumerState<IngredientForm> createState() => _IngredientFormState();
}

class _IngredientFormState extends ConsumerState<IngredientForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;
  bool _isPickingPhoto = false;

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
    final flagsAsync = ref.watch(featureFlagControllerProvider);
    final photosEnabled =
        flagsAsync.value?.ingredientPhotosEnabled ?? true;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final missingPhotos = formState.photos
        .where(
          (photo) =>
              photo.path.trim().isEmpty || !File(photo.path).existsSync(),
        )
        .toList(growable: false);
    final missingIds = missingPhotos.map((photo) => photo.id).toSet();
    String? photoError;
    for (final error in formState.errors) {
      if (error.toLowerCase().contains('photo')) {
        photoError = error;
        break;
      }
    }

    if (_nameController.text != formState.name) {
      _nameController.text = formState.name;
    }
    if (_quantityController.text != formState.quantityText) {
      _quantityController.text = formState.quantityText;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (photosEnabled) ...[
          _PhotoSection(
            photos: formState.photos,
            missingIds: missingIds,
            isPicking: _isPickingPhoto,
            canAdd: !_isPickingPhoto &&
                formState.photos.length < maxIngredientPhotos,
            errorText: photoError,
            onRemoveMissing: missingPhotos.isEmpty
                ? null
                : () {
                    for (final photo in missingPhotos) {
                      formController.removePhoto(photo.id);
                    }
                  },
            onAdd: () => _showPhotoSourceSheet(
              context,
              formController,
            ),
            onRemove: (photo) => formController.removePhoto(photo.id),
            onView: (photo) => IngredientPhotoViewer.show(
              context,
              photos: formState.photos,
              initialPhotoId: photo.id,
            ),
          ),
          const SizedBox(height: 16),
        ],
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

  Future<void> _showPhotoSourceSheet(
    BuildContext context,
    IngredientFormController formController,
  ) async {
    if (formController.state.photos.length >= maxIngredientPhotos) {
      _showPhotoMessage(
        context,
        'You can add up to $maxIngredientPhotos photos.',
      );
      return;
    }
    final source = await showModalBottomSheet<_PhotoSource>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Take photo'),
              onTap: () => Navigator.of(ctx).pop(_PhotoSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from library'),
              onTap: () => Navigator.of(ctx).pop(_PhotoSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    await _pickPhoto(context, source, formController);
  }

  Future<void> _pickPhoto(
    BuildContext context,
    _PhotoSource source,
    IngredientFormController formController,
  ) async {
    final picker = ref.read(ingredientPhotoPickerProvider);
    try {
      setState(() => _isPickingPhoto = true);
      final photo = source == _PhotoSource.camera
          ? await picker.pickFromCamera()
          : await picker.pickFromGallery();
      if (photo == null) return;
      formController.addPhoto(photo);
    } on PlatformException catch (_) {
      _showPhotoMessage(
        context,
        'Photo access is unavailable. Check permissions in Settings.',
      );
    } catch (_) {
      _showPhotoMessage(
        context,
        'Unable to add photo. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() => _isPickingPhoto = false);
      }
    }
  }

  void _showPhotoMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
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

enum _PhotoSource { camera, gallery }

class _PhotoSection extends StatelessWidget {
  final List<IngredientPhoto> photos;
  final Set<String> missingIds;
  final bool isPicking;
  final bool canAdd;
  final String? errorText;
  final VoidCallback? onRemoveMissing;
  final VoidCallback onAdd;
  final ValueChanged<IngredientPhoto> onRemove;
  final ValueChanged<IngredientPhoto> onView;

  const _PhotoSection({
    required this.photos,
    required this.missingIds,
    required this.isPicking,
    required this.canAdd,
    required this.errorText,
    required this.onRemoveMissing,
    required this.onAdd,
    required this.onRemove,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final missingCount = missingIds.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel('Photos'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (var index = 0; index < photos.length; index += 1)
              _PhotoThumbnail(
                key: ValueKey('ingredient-photo-thumb-${photos[index].id}'),
                photo: photos[index],
                indexLabel: index + 1,
                isMissing: missingIds.contains(photos[index].id),
                onRemove: () => onRemove(photos[index]),
                onView: () => onView(photos[index]),
              ),
            _AddPhotoTile(
              key: const ValueKey('ingredient-photo-add'),
              enabled: canAdd,
              onPressed: onAdd,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Add up to $maxIngredientPhotos photos.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        if (isPicking) ...[
          const SizedBox(height: 8),
          const LinearProgressIndicator(minHeight: 2),
        ],
        if (errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            errorText!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.error,
            ),
          ),
        ],
        if (missingCount > 0) ...[
          const SizedBox(height: 8),
          Text(
            'Some photos are missing. Remove or reselect them.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.error,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onRemoveMissing,
              icon: const Icon(Icons.delete_outline),
              label: Text('Remove missing photos ($missingCount)'),
            ),
          ),
        ],
      ],
    );
  }
}

class _PhotoThumbnail extends StatelessWidget {
  final IngredientPhoto photo;
  final int indexLabel;
  final bool isMissing;
  final VoidCallback onRemove;
  final VoidCallback onView;

  const _PhotoThumbnail({
    super.key,
    required this.photo,
    required this.indexLabel,
    required this.isMissing,
    required this.onRemove,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Semantics(
      label: isMissing ? 'Photo $indexLabel missing' : 'Photo $indexLabel',
      button: true,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          InkWell(
            onTap: onView,
            borderRadius: BorderRadius.circular(16),
            key: ValueKey('ingredient-photo-thumb-ink-${photo.id}'),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 88,
                width: 88,
                child: Image.file(
                  File(photo.path),
                  fit: BoxFit.cover,
                  cacheWidth: 176,
                  cacheHeight: 176,
                  errorBuilder: (_, __, ___) => Container(
                    color: colorScheme.surfaceContainerHighest,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (isMissing)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    'Missing',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colorScheme.onErrorContainer,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ),
            ),
          Positioned(
            top: -8,
            right: -8,
            child: Semantics(
              button: true,
              label: 'Delete photo $indexLabel',
              child: Material(
                color: colorScheme.surface,
                shape: const CircleBorder(),
                elevation: 1,
                child: IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.close),
                  color: colorScheme.error,
                  iconSize: 16,
                  constraints: const BoxConstraints(
                    minWidth: 44,
                    minHeight: 44,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddPhotoTile extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;

  const _AddPhotoTile({
    super.key,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final content = SizedBox(
      height: 88,
      width: 88,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(
                Icons.add_a_photo,
                color: colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Add',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
    return Semantics(
      button: true,
      enabled: enabled,
      label: 'Add photo',
      child: InkWell(
        key: const ValueKey('ingredient-photo-add-ink'),
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(16),
        child: Opacity(
          opacity: enabled ? 1 : 0.4,
          child: CustomPaint(
            painter: _DashedBorderPainter(
              color: colorScheme.outlineVariant,
              radius: 16,
            ),
            child: content,
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
