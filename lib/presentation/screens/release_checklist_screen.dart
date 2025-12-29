import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naugiday/presentation/providers/release_checklist_provider.dart';

class ReleaseChecklistScreen extends ConsumerWidget {
  const ReleaseChecklistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checklistAsync = ref.watch(releaseChecklistControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Release Checklist'),
        centerTitle: true,
      ),
      body: checklistAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('No checklist items yet.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final item = items[index];
              return CheckboxListTile(
                value: item.status == 'complete',
                title: Text(item.title),
                subtitle: item.notes != null ? Text(item.notes!) : null,
                onChanged: (value) {
                  ref
                      .read(releaseChecklistControllerProvider.notifier)
                      .toggleItem(item.id, value ?? false);
                },
              );
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: items.length,
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Could not load checklist: $err'),
        ),
      ),
    );
  }
}
