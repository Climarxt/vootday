import 'package:bootdv2/blocs/auth/auth_bloc.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:bootdv2/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation/router.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting(
      'fr_FR', null); // Initialisation du formatage des dates
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark));
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider<UserRepository>(
          create: (context) => UserRepository(),
        ),
        RepositoryProvider<PostRepository>(
          create: (context) => PostRepository(),
        ),
        RepositoryProvider<StorageRepository>(
          create: (context) => StorageRepository(),
        ),
        RepositoryProvider<NotificationRepository>(
          create: (context) => NotificationRepository(),
        ),
      ],
      child: BlocProvider(
        create: (context) =>
            AuthBloc(authRepository: context.read<AuthRepository>()),
        child: Builder(
          builder: (context) => MaterialApp.router(
            title: 'VOOTDAY',
            theme: theme(),
            routerConfig: createRouter(context),
          ),
        ),
      ),
    );
  }
}
