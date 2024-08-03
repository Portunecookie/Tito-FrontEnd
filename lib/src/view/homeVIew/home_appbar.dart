import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:tito_app/core/provider/home_state_provider.dart';

class HomeAppbar extends ConsumerWidget {
  const HomeAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final homeViewModel = ref.read(homeViewModelProvider.notifier);
    return AppBar(
      backgroundColor: ColorSystem.white,
      leading: SizedBox(
        width: 66.w,
        height: 33.28.h,
        child: Image.asset(
          'assets/images/logo.png', // 로고 이미지 경로
          //fit: BoxFit.contain,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            context.go('/myalarm');
          },
          icon: SizedBox(
            width: 30.w,
            height: 30.h,
            child: SvgPicture.asset(
              'assets/icons/home_alarm.svg',
            ),
          ),
        ),
      ],
    );
  }
}
