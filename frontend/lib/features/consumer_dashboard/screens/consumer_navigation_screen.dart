import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:kurukshetra/features/consumer/marketplace/screens/marketplace_screen.dart';
import 'package:kurukshetra/features/market_prices/screens/crop_selection_screen.dart' as market_prices;
import 'package:kurukshetra/features/consumer/orders/screens/order_tracking_screen.dart';
import 'package:kurukshetra/features/consumer_profile/screens/consumer_profile_screen.dart';

class ConsumerNavigationScreen extends ConsumerStatefulWidget {
  const ConsumerNavigationScreen({super.key});

  @override
  ConsumerState<ConsumerNavigationScreen> createState() => _ConsumerNavigationScreenState();
}

class _ConsumerNavigationScreenState extends ConsumerState<ConsumerNavigationScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const MarketplaceScreen(isEmbedded: true),
    const market_prices.MarketCropSelectionScreen(isEmbedded: true),
    const OrderTrackingScreen(isEmbedded: true),
    const ConsumerProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: Colors.grey.shade400,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Shopping'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Prices'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
