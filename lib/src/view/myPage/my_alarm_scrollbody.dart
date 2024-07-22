import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tito_app/src/screen/home_screen.dart';
import 'package:tito_app/core/constants/style.dart';

class MyAlarmScrollbody extends ConsumerWidget {
  const MyAlarmScrollbody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text ('새로운 알림', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        ),
      ],
    );
  }
}