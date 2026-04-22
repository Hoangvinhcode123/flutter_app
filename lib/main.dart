import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'screens/about_screen.dart';
import 'screens/news_screen.dart';
import 'screens/disclaimer_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/shop_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/admin_dashboard_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/orders_history_screen.dart';
import 'screens/wishlist_screen.dart';
import 'screens/notifications_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
      title: 'ĐƯƠNG',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFC39366)),
      ),
      home: FutureBuilder(
        future: Provider.of<AuthProvider>(context, listen: false).tryAutoLogin(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          return const HomeScreen();
        },
      ),
      routes: {
        '/': (context) => const HomeScreen(),
        '/home': (context) => const HomeScreen(),
        '/about': (context) => const AboutScreen(),
        '/news': (context) => const NewsScreen(),
        '/disclaimer': (context) => const DisclaimerScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/shop': (context) => const ShopScreen(),
        '/cart': (context) => const CartScreen(),
        '/admin': (context) => const AdminDashboardScreen(),
        '/checkout': (context) => const CheckoutScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/orders': (context) => const OrdersHistoryScreen(),
        '/wishlist': (context) => const WishlistScreen(),
        '/notifications': (context) => const NotificationsScreen(),
      },
    ));
  }
}
