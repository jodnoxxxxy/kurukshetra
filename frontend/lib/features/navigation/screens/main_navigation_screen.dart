import 'package:flutter/material.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:kurukshetra/features/home/screens/home_screen.dart';
import 'package:kurukshetra/features/dashboard/screens/dashboard_screen.dart';
import 'package:kurukshetra/features/learn/screens/learn_screen.dart';
import 'package:kurukshetra/features/profile/screens/profile_screen.dart';
import 'package:kurukshetra/features/navigation/widgets/kurukshetra_drawer.dart';
import 'package:kurukshetra/features/navigation/providers/navigation_provider.dart';
import 'package:kurukshetra/features/support/widgets/support_assistant_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _screens = [
    const HomeScreen(),
    const FarmerDashboardScreen(), // CHC mapping
    const LearnScreen(), // Videos mapping
    const ProfileScreen(), // Shetishala mapping
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(navigationProvider);
    return Scaffold(
      key: _scaffoldKey,
      drawer: const KurukshetraDrawer(),
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
      ),
      floatingActionButton: SizedBox(
        height: 64,
        width: 64,
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (context) => const SupportAssistantSheet(),
            );
          },
          backgroundColor: AppColors.primaryGreen,
          elevation: 6,
          shape: const CircleBorder(),
          child: const Icon(Icons.chat_bubble_rounded, color: Colors.white, size: 28),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 70,
        padding: EdgeInsets.zero,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10.0,
        color: Colors.white,
        elevation: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTab(Icons.home_rounded, 'Home', 0),
            _buildTab(Icons.dashboard_rounded, 'Dashboard', 1),
            const SizedBox(width: 56), // Increased FAB space
            _buildTab(Icons.play_circle_fill_rounded, 'Shetishala', 2),
            _buildTab(Icons.person_rounded, 'Profile', 3),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(IconData icon, String label, int index) {
    final currentIndex = ref.watch(navigationProvider);
    final isSelected = currentIndex == index;
    final color = isSelected ? const Color(0xFF138808) : Colors.grey.shade400;

    return InkWell(
      onTap: () => ref.read(navigationProvider.notifier).setIndex(index),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label, 
              style: TextStyle(
                color: color, 
                fontSize: 10, 
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
