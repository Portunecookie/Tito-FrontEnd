import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:tito_app/core/provider/home_state_provider.dart';

class HomeAppbar extends ConsumerWidget {
  const HomeAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final homeViewModel = ref.read(homeViewModelProvider.notifier);
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          'assets/images/logo.png', // 로고 이미지 경로
          fit: BoxFit.contain,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Image.asset('assets/images/notification.png'),
        ),
        IconButton(
          onPressed: () {
            // homeViewModel.goMyPage(context);
          },
          icon: Image.asset('assets/images/mypage.png'),
        ),
      ],
    );
  }
}