
import 'package:app_tuan89/screens/OrderHistoryScreen.dart' as OrderHistoryScreenLib;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

// Screens
// Removed import for non-existent file 'OrderHistoryprovider.dart'
import 'package:app_tuan89/screens/cartscreen.dart';
import 'package:app_tuan89/screens/mainscreen.dart';
import 'package:app_tuan89/screens/RegisterScreen.dart';
import 'package:app_tuan89/screens/ProfileScreen.dart';
import 'package:app_tuan89/screens/LoginScreen.dart';
import 'package:app_tuan89/screens/QRScreen.dart';
import 'package:app_tuan89/screens/orderscreen.dart';
import 'package:app_tuan89/screens/Orderconfirmationscreen.dart';
import 'package:app_tuan89/screens/NotificationsScreen.dart';
import 'package:app_tuan89/screens/MenuScreen.dart';
import 'package:app_tuan89/screens/ForgotPasswordScreen.dart' as ForgotPasswordScreenLib;
import 'package:app_tuan89/screens/DeliveryScreen.dart';
import 'package:app_tuan89/screens/PickupScreen.dart';
import 'package:app_tuan89/screens/promotionscreen.dart';
import 'package:app_tuan89/screens/settingsscreen.dart';
import 'package:app_tuan89/screens/AddNewAddressScreen.dart';
import 'package:app_tuan89/screens/AddressSelectionScreen.dart';
import 'package:app_tuan89/screens/DrinkDetailScreen.dart';

// Providers
import 'package:app_tuan89/providers/cartprovider.dart' as CartProviderLib;
import 'package:app_tuan89/providers/addressprovider.dart' as AddressProviderLib;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Load saved address data
  final addressProvider = AddressProviderLib.AddressProvider();
  await addressProvider.loadAddressesFromPrefs();

  runApp(MyApp(addressProvider: addressProvider));
}

class MyApp extends StatelessWidget {
  final AddressProviderLib.AddressProvider addressProvider;

  const MyApp({super.key, required this.addressProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProviderLib.CartProvider()),
        ChangeNotifierProvider<AddressProviderLib.AddressProvider>.value(
          value: addressProvider,
        ),
        ChangeNotifierProvider(create: (_) => OrderHistoryScreenLib.OrderHistoryProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ĐƯƠNG',
        theme: ThemeData(
          primarySwatch: Colors.brown,
          scaffoldBackgroundColor: Colors.brown[50],
          fontFamily: 'Roboto',
          textTheme: TextTheme(
            headlineLarge: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.brown[900],
            ),
            bodyLarge: TextStyle(fontSize: 16, color: Colors.brown[800]),
            labelLarge: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.brown[700],
            titleTextStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => MainScreen(),
          '/register': (context) => RegisterScreen(),
          '/login': (context) => LoginScreen(),
          '/profile': (context) => ProfileScreen(),
          '/QR': (context) => QRScreen(),
          '/cart': (context) => CartScreen(),
          '/order': (context) => OrderScreen(),
          '/order-confirmation': (context) => OrderConfirmationScreen(),
          '/notifications': (context) => NotificationsScreen(),
          '/menu': (context) => MenuScreen(),
          '/forgotPassword': (context) => ForgotPasswordScreenLib.ForgotPasswordScreen(),
          '/promotions': (context) => const PromotionsScreen(),
          '/delivery': (context) => const DeliveryScreen(),
          '/pickup': (context) => const PickupScreen(),
          '/settings': (context) => const SettingsScreen(),
          '/add-address': (context) => AddNewAddressScreen(),
          '/select-address': (context) => AddressSelectionScreen(),
          '/drink-detail': (context) => const DrinkDetailScreen(title: '', imageUrl: '', price: 0,),
        },
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text('Không tìm thấy trang: ${settings.name}'),
            ),
          ),
        ),
      ),
    );
  }
}
