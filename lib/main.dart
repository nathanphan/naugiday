import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naugiday/data/local/hive_setup.dart';
import 'package:naugiday/presentation/router/app_router.dart';
import 'package:naugiday/presentation/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForRecipes();

  runApp(const ProviderScope(child: NauGiDayApp()));
}

class NauGiDayApp extends ConsumerWidget {
  const NauGiDayApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      title: 'NauGiDay',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
