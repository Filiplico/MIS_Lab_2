import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lab2/firebase_options.dart';
import 'package:lab2/services/notification_service.dart';
import 'package:lab2/services/meal_detail_service.dart';
import 'screens/home_screen.dart';
import 'screens/meal_detail_screen.dart';

// Background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Background message received: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set up background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize notification service
  final notificationService = NotificationService();
  await notificationService.initialize();

  // Set up notification tap handler
  notificationService.onNotificationTapped = (mealId) {
    // This will be handled by the app when it's running
    print('Notification tapped with mealId: $mealId');
  };

  runApp(FoodRecipesApp(notificationService: notificationService));
}

class FoodRecipesApp extends StatefulWidget {
  final NotificationService notificationService;

  const FoodRecipesApp({super.key, required this.notificationService});

  @override
  State<FoodRecipesApp> createState() => _FoodRecipesAppState();
}

class _FoodRecipesAppState extends State<FoodRecipesApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    // Set up notification tap handler to navigate to random recipe
    widget.notificationService.onNotificationTapped = (mealId) async {
      if (mealId.isEmpty) {
        // If no mealId, fetch a random meal
        final service = MealDetailService();
        final randomMeal = await service.fetchRandomMeal();
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => MealDetailScreen(mealId: randomMeal.id),
          ),
        );
      } else {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => MealDetailScreen(mealId: mealId),
          ),
        );
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Food Recipes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}