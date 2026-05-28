import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../feed/create_content_screen.dart';
import '../feed/feed_screen.dart';
import '../profile/profile_screen.dart';
import '../reels/reels_screen.dart';
import '../search/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final GlobalKey<FeedScreenState> feedKey = GlobalKey<FeedScreenState>();

  late final List<Widget> screens = [
    FeedScreen(key: feedKey),
    const SearchScreen(),
    const SizedBox.shrink(),
    const ReelsScreen(),
    const ProfileScreen(),
  ];

  Future<void> onDestinationSelected(int index) async {
    if (index == 2) {
      final created = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CreateContentScreen()),
      );

      if (created == true) {
        setState(() => currentIndex = 0);
        await feedKey.currentState?.loadFeed();
      }
      return;
    }

    setState(() => currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
          indicatorColor: AppColors.accent.withOpacity(0.18),
          onDestinationSelected: onDestinationSelected,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.search),
              selectedIcon: Icon(Icons.search),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.add_box_outlined),
              selectedIcon: Icon(Icons.add_box),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.play_circle_outline),
              selectedIcon: Icon(Icons.play_circle),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
