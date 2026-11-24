// import 'package:opinion_easy/controller/nav_controller.dart';
// import 'package:opinion_easy/view/home/home_view.dart';
// import 'package:opinion_easy/view/profile/profile_view.dart';
// import 'package:opinion_easy/view/reward/reward_view.dart';
// import 'package:opinion_easy/view/wallet/wallet_view.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'dart:ui';
//
// import 'home/widgets/back_press_exit_handler.dart';
// import 'leaderboard/leaderboard_view.dart';
//
// class BottomNav extends StatefulWidget {
//   final int selectedIndex;
//   const BottomNav({super.key, this.selectedIndex = 0});
//
//   @override
//   State<BottomNav> createState() => _BottomNavState();
// }
//
// class _BottomNavState extends State<BottomNav>
//     with TickerProviderStateMixin, WidgetsBindingObserver {
//   late final BottomNavController bottomNavController;
//   late final List<Widget> pages;
//   late final List<AnimationController> _animControllers;
//   late final List<Animation<double>> _scaleAnims;
//
//   /// Controls blur overlay when app goes to background / recent apps
//   final RxBool _isBlurred = false.obs;
//
//   final List<_NavItem> _navItems = const [
//     _NavItem(icon: Icons.home_rounded, label: "Home"),
//     _NavItem(icon: Icons.account_balance_wallet_rounded, label: "Wallet"),
//     _NavItem(icon: Icons.card_giftcard_rounded, label: "Reward"),
//     _NavItem(icon: Icons.leaderboard_rounded, label: "Board"),
//     _NavItem(icon: Icons.person_rounded, label: "Profile"),
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Register lifecycle observer
//     WidgetsBinding.instance.addObserver(this);
//
//     bottomNavController = Get.put(BottomNavController());
//
//     pages = [
//       HomeView(),
//       WalletView(),
//       RewardView(),
//       LeaderboardView(),
//       ProfileView(),
//     ];
//
//     _animControllers = List.generate(
//       _navItems.length,
//       (i) => AnimationController(
//         vsync: this,
//         duration: const Duration(milliseconds: 180),
//       ),
//     );
//
//     _scaleAnims = _animControllers
//         .map(
//           (c) => Tween<double>(
//             begin: 1.0,
//             end: 0.82,
//           ).animate(CurvedAnimation(parent: c, curve: Curves.easeInOut)),
//         )
//         .toList();
//
//     // Animate the initially selected tab
//     _animControllers[bottomNavController.selectedIndex.value].forward();
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     for (final c in _animControllers) {
//       c.dispose();
//     }
//     super.dispose();
//   }
//
//   /// ── Lifecycle: blur on background, unblur on resume ──────────────────────
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     switch (state) {
//       case AppLifecycleState.inactive:
//       case AppLifecycleState.paused:
//       case AppLifecycleState.hidden:
//         // User pressed home / opened recent apps → show blur
//         _isBlurred.value = true;
//         break;
//       case AppLifecycleState.resumed:
//         // App came back to foreground → remove blur
//         _isBlurred.value = false;
//         break;
//       default:
//         break;
//     }
//   }
//
//   void _onTap(int index) {
//     final prev = bottomNavController.selectedIndex.value;
//     if (prev == index) return;
//     _animControllers[prev].reverse();
//     _animControllers[index].forward();
//     bottomNavController.changeIndex(index);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       return BackPressExitHandler(
//         isHomeTab: bottomNavController.selectedIndex.value == 0,
//         onGoHome: () => bottomNavController.changeIndex(0),
//         child: Stack(
//           children: [
//             // ── Main scaffold ──────────────────────────────────────────────
//             Scaffold(
//               body: pages[bottomNavController.selectedIndex.value],
//               bottomNavigationBar: _buildNavBar(),
//             ),
//
//             // ── Blur overlay (recent apps / background) ────────────────────
//             Obx(
//               () => AnimatedSwitcher(
//                 duration: const Duration(milliseconds: 200),
//                 child: _isBlurred.value
//                     ? _BlurOverlay(key: const ValueKey('blur'))
//                     : const SizedBox.shrink(key: ValueKey('none')),
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }
//
//   Widget _buildNavBar() {
//     return Obx(() {
//       final selected = bottomNavController.selectedIndex.value;
//       return Container(
//         decoration: BoxDecoration(
//           color: const Color(0xFF0D0D0D),
//           border: Border(
//             top: BorderSide(color: Colors.white.withOpacity(0.08), width: 1),
//           ),
//         ),
//         child: SafeArea(
//           top: false,
//           child: SizedBox(
//             height: 72,
//             child: Row(
//               children: List.generate(_navItems.length, (i) {
//                 final isSelected = selected == i;
//                 return Expanded(
//                   child: GestureDetector(
//                     onTap: () => _onTap(i),
//                     behavior: HitTestBehavior.opaque,
//                     child: ScaleTransition(
//                       scale: _scaleAnims[i],
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           // Icon — white filled box when active, ghost when not
//                           AnimatedContainer(
//                             duration: const Duration(milliseconds: 220),
//                             curve: Curves.easeOut,
//                             padding: EdgeInsets.all(isSelected ? 10 : 8),
//                             decoration: BoxDecoration(
//                               color: isSelected
//                                   ? Colors.white
//                                   : Colors.transparent,
//                               borderRadius: BorderRadius.circular(14),
//                             ),
//                             child: Icon(
//                               _navItems[i].icon,
//                               size: isSelected ? 30 : 24,
//                               color: isSelected
//                                   ? Colors.black
//                                   : Colors.white.withOpacity(0.38),
//                             ),
//                           ),
//                           const SizedBox(height: 5),
//                           // Label
//                           AnimatedDefaultTextStyle(
//                             duration: const Duration(milliseconds: 220),
//                             style: TextStyle(
//                               fontSize: 10,
//                               fontWeight: isSelected
//                                   ? FontWeight.w900
//                                   : FontWeight.w400,
//                               color: isSelected
//                                   ? Colors.white
//                                   : Colors.white.withOpacity(0.38),
//                               letterSpacing: 0.2,
//                             ),
//                             child: Text(_navItems[i].label),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }
//
// // ── Blur overlay widget ────────────────────────────────────────────────────────
// class _BlurOverlay extends StatelessWidget {
//   const _BlurOverlay({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Positioned.fill(
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
//         child: Container(
//           color: Colors.black.withOpacity(0.60),
//           child: Center(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.white.withOpacity(0.06),
//                     border: Border.all(
//                       color: Colors.white.withOpacity(0.14),
//                       width: 1.5,
//                     ),
//                   ),
//                   child: const Icon(
//                     Icons.lock_outline_rounded,
//                     color: Colors.white,
//                     size: 30,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 const Text(
//                   "Opinion Easy",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.w700,
//                     letterSpacing: 0.4,
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   "Resume to continue",
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.45),
//                     fontSize: 13,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _NavItem {
//   final IconData icon;
//   final String label;
//   const _NavItem({required this.icon, required this.label});
// }
import 'package:opinion_easy/controller/nav_controller.dart';
import 'package:opinion_easy/view/home/home_view.dart';
import 'package:opinion_easy/view/profile/profile_view.dart';
import 'package:opinion_easy/view/reward/reward_view.dart';
import 'package:opinion_easy/view/wallet/wallet_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';

import 'home/widgets/back_press_exit_handler.dart';
import 'leaderboard/leaderboard_view.dart';

class BottomNav extends StatefulWidget {
  final int selectedIndex;
  const BottomNav({super.key, this.selectedIndex = 0});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final BottomNavController bottomNavController;
  late final List<Widget> pages;
  late final List<AnimationController> _animControllers;
  late final List<Animation<double>> _scaleAnims;

  final RxBool _isBlurred = false.obs;

  final List<_NavItem> _navItems = const [
    _NavItem(icon: Icons.home_rounded, label: "Home"),
    _NavItem(icon: Icons.account_balance_wallet_rounded, label: "Wallet"),
    _NavItem(icon: Icons.card_giftcard_rounded, label: "Reward"),
    _NavItem(icon: Icons.leaderboard_rounded, label: "Board"),
    _NavItem(icon: Icons.person_rounded, label: "Profile"),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    bottomNavController = Get.put(BottomNavController());

    pages = [
      HomeView(),
      WalletView(),
      RewardView(),
      LeaderboardView(),
      ProfileView(),
    ];

    _animControllers = List.generate(
      _navItems.length,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 180),
      ),
    );

    _scaleAnims = _animControllers
        .map(
          (c) => Tween<double>(begin: 1.0, end: 0.82)
              .animate(CurvedAnimation(parent: c, curve: Curves.easeInOut)),
        )
        .toList();

    _animControllers[bottomNavController.selectedIndex.value].forward();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    for (final c in _animControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        _isBlurred.value = true;
        break;
      case AppLifecycleState.resumed:
        _isBlurred.value = false;
        break;
      default:
        break;
    }
  }

  void _onTap(int index) {
    final prev = bottomNavController.selectedIndex.value;
    if (prev == index) return;
    _animControllers[prev].reverse();
    _animControllers[index].forward();
    bottomNavController.changeIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return BackPressExitHandler(
        isHomeTab: bottomNavController.selectedIndex.value == 0,
        onGoHome: () => bottomNavController.changeIndex(0),
        child: Stack(
          children: [
            Scaffold(
              body: pages[bottomNavController.selectedIndex.value],
              bottomNavigationBar: _buildNavBar(),
            ),
            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _isBlurred.value
                    ? _BlurOverlay(key: const ValueKey('blur'))
                    : const SizedBox.shrink(key: ValueKey('none')),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildNavBar() {
    return Obx(() {
      final selected = bottomNavController.selectedIndex.value;
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0D0D0D),
          border: Border(
            top: BorderSide(color: Colors.white.withOpacity(0.08), width: 1),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 72,
            child: Row(
              children: List.generate(_navItems.length, (i) {
                final isSelected = selected == i;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _onTap(i),
                    behavior: HitTestBehavior.opaque,
                    child: ScaleTransition(
                      scale: _scaleAnims[i],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOut,
                            padding: EdgeInsets.all(isSelected ? 10 : 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              _navItems[i].icon,
                              size: isSelected ? 30 : 24,
                              color: isSelected
                                  ? Colors.black
                                  : Colors.white.withOpacity(0.38),
                            ),
                          ),
                          const SizedBox(height: 5),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 220),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isSelected
                                  ? FontWeight.w900
                                  : FontWeight.w400,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.38),
                              letterSpacing: 0.2,
                            ),
                            child: Text(_navItems[i].label),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      );
    });
  }
}

class _BlurOverlay extends StatelessWidget {
  const _BlurOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          color: Colors.black.withOpacity(0.60),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.06),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.14),
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.lock_outline_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Opinion Easy",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Resume to continue",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.45),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
