import 'package:endless_runner/auth/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:provider/provider.dart';

import 'app_lifecycle/app_lifecycle.dart';
import 'audio/audio_controller.dart';
import 'firebase_options.dart';
import 'player_progress/player_progress.dart';
import 'router.dart';
import 'settings/settings.dart';
import 'style/palette.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  FirebaseApp app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AuthService(app: app).signInAnonymously();
  runApp(const MyGame());
}

class MyGame extends StatelessWidget {
  const MyGame({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLifecycleObserver(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => PlayerProgress()),
          Provider(create: (context) => SettingsController()),
          // Set up audio.
          ProxyProvider2<SettingsController, AppLifecycleStateNotifier,
              AudioController>(
            // Ensures that music starts immediately.
            lazy: false,
            create: (context) => AudioController(),
            update: (context, settings, lifecycleNotifier, audio) {
              audio!.attachDependencies(lifecycleNotifier, settings);
              return audio;
            },
            dispose: (context, audio) => audio.dispose(),
          ),
        ],
        child: Builder(builder: (context) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);

          return MaterialApp.router(
            showSemanticsDebugger: false,
            debugShowCheckedModeBanner: false,
            title: 'Endless Runner',
            theme: flutterNesTheme().copyWith(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Palette.seed,
                background: Palette.backgroundMain,
              ),
              textTheme: GoogleFonts.pressStart2pTextTheme().apply(
                bodyColor: Palette.text,
                displayColor: Palette.text,
              ),
            ),
            routeInformationProvider: router.routeInformationProvider,
            routeInformationParser: router.routeInformationParser,
            routerDelegate: router.routerDelegate,
          );
        }),
      ),
    );
  }
}
