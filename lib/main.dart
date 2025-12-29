import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naugiday/data/local/hive_setup.dart';
import 'package:naugiday/data/services/crash_reporting_service.dart';
import 'package:naugiday/presentation/providers/feature_flag_provider.dart';
import 'package:naugiday/presentation/providers/telemetry_provider.dart';
import 'package:naugiday/presentation/router/app_router.dart';
import 'package:naugiday/presentation/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForRecipes();
  await CrashReportingService.initialize();

  runApp(const ProviderScope(child: NauGiDayApp()));
}

class NauGiDayApp extends ConsumerStatefulWidget {
  const NauGiDayApp({super.key});

  @override
  ConsumerState<NauGiDayApp> createState() => _NauGiDayAppState();
}

class _NauGiDayAppState extends ConsumerState<NauGiDayApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(featureFlagControllerProvider.notifier).refresh();
      await ref.read(telemetryControllerProvider.notifier).flushPending();
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      title: 'NauGiDay',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
