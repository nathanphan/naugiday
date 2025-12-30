import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naugiday/presentation/providers/feature_flag_provider.dart';

class MainScaffold extends ConsumerWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String location = GoRouterState.of(context).uri.path;
    final bool hideFab = location.startsWith('/my-recipes');
    final flagsAsync = ref.watch(featureFlagControllerProvider);
    final ingredientsEnabled =
        flagsAsync.value?.ingredientsEnabled ?? true;
    final destinations = <_NavDestination>[
      const _NavDestination(
        label: 'Home',
        route: '/',
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
      ),
      if (ingredientsEnabled)
        const _NavDestination(
          label: 'Ingredients',
          route: '/ingredients',
          icon: Icons.kitchen_outlined,
          selectedIcon: Icons.kitchen,
        ),
      const _NavDestination(
        label: 'My Recipes',
        route: '/my-recipes',
        icon: Icons.receipt_long_outlined,
        selectedIcon: Icons.receipt_long,
      ),
      const _NavDestination(
        label: 'Shopping',
        route: '/shopping-list',
        icon: Icons.shopping_cart_outlined,
        selectedIcon: Icons.shopping_cart,
      ),
    ];
    final selectedIndex = _selectedIndexForLocation(
      location,
      ingredientsEnabled,
    );
    return Scaffold(
      body: child,
      floatingActionButton: hideFab
          ? null
          : FloatingActionButton(
              heroTag: 'main-scaffold-fab',
              tooltip: 'Release checklist',
              onPressed: () => context.go('/release-checklist'),
              child: const Icon(Icons.checklist),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) =>
            context.go(destinations[index].route),
        destinations: destinations
            .map(
              (item) => NavigationDestination(
                icon: Icon(item.icon),
                selectedIcon: Icon(item.selectedIcon),
                label: item.label,
              ),
            )
            .toList(growable: false),
      ),
    );
  }

  static int _selectedIndexForLocation(
    String location,
    bool ingredientsEnabled,
  ) {
    final mapping = <String, int>{
      '/': 0,
      if (ingredientsEnabled) '/ingredients': 1,
      '/my-recipes': ingredientsEnabled ? 2 : 1,
      '/shopping-list': ingredientsEnabled ? 3 : 2,
    };
    for (final entry in mapping.entries) {
      if (location.startsWith(entry.key)) {
        return entry.value;
      }
    }
    return 0;
  }
}

class _NavDestination {
  final String label;
  final String route;
  final IconData icon;
  final IconData selectedIcon;

  const _NavDestination({
    required this.label,
    required this.route,
    required this.icon,
    required this.selectedIcon,
  });
}
