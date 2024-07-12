import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/models/debate_info.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tito_app/models/login_info.dart';
import 'package:tito_app/provider/debate_provider.dart';
import 'package:tito_app/provider/nav_provider.dart';
import 'package:tito_app/provider/login_provider.dart';
import 'package:tito_app/screen/list_screen.dart';
import 'package:tito_app/widgets/reuse/notification.dart';

class DebateGuest extends ConsumerStatefulWidget {
  final String? debateId;

  const DebateGuest({super.key, this.debateId});

  @override
  ConsumerState<DebateGuest> createState() => _DebateGuestState();
}

class _DebateGuestState extends ConsumerState<DebateGuest> {
  final _formKey = GlobalKey<FormState>();
  var myArguments = '';
  var opponentArguments = '';
  late Future<DebateInfo?> debateInfoFuture;
  bool isOpponentJoined = false;
  bool startdebate = false;

  @override
  void initState() {
    super.initState();
    debateInfoFuture = widget.debateId != null
        ? fetchDebateInfo(widget.debateId!)
        : Future.value(null);
  }

  Future<DebateInfo?> fetchDebateInfo(String debateId) async {
    final url = Uri.https(
        'tito-f8791-default-rtdb.firebaseio.com', 'debate_list/$debateId.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        return DebateInfo.fromMap(debateId, data);
      }
    } else {
      throw Exception('Failed to load debate info');
    }
    return null;
  }

  Future<void> _updateDebateState(String debateId) async {
    final url = Uri.https(
        'tito-f8791-default-rtdb.firebaseio.com', 'debate_list/$debateId.json');
    final loginInfo = ref.read(loginInfoProvider);
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {'opponentId': loginInfo?.email},
      ),
    );

    if (response.statusCode == 200) {
      setState(() {
        isOpponentJoined = true;
        ref.read(debateInfoProvider.notifier).updateDebateInfo(
              opponentId: loginInfo?.email,
            );
      });
    } else {
      throw Exception('Failed to update debate state');
    }
  }

  void _createDebateRoom(DebateInfo debateInfo) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    await _updateDebateState(debateInfo.id);

    ref.read(selectedIndexProvider.notifier).state = 1;
    // Navigator.pushAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(builder: (context) => const ListScreen()),
    //   (Route<dynamic> route) => false,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => const ListScreen(),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: FutureBuilder<DebateInfo?>(
        future: debateInfoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data available'));
          } else {
            final debateInfo = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      debateInfo.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '개설자 주장',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Text(
                        debateInfo.myArgument,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '당신의 주장',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Text(
                        debateInfo.opponentArgument,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      (debateInfo.opponentId!.isNotEmpty || isOpponentJoined)
                          ? '토론이 곧 시작돼요! 토론 시작 알림을 받아보세요!'
                          : '토론 참여자를 기다리고 있어요!',
                      style: const TextStyle(color: Color(0xff8E48F8)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: IconButton(
                            onPressed: () {
                              FlutterLocalNotification.showNotification();
                            },
                            icon: Image.asset('assets/images/alarm.png'),
                            iconSize: 32.0,
                          ),
                        ),
                        const SizedBox(width: 8.0), // 아이콘과 버튼 사이의 간격을 추가
                        Expanded(
                          child: ElevatedButton(
                            onPressed: (debateInfo.opponentId!.isNotEmpty ||
                                    isOpponentJoined)
                                ? null
                                : () => _createDebateRoom(debateInfo),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  (debateInfo.opponentId!.isNotEmpty ||
                                          isOpponentJoined)
                                      ? Colors.grey[200]
                                      : const Color(0xff8E48F8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                            ),
                            child: const Text(
                              '참여하기',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}