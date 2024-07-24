import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/debate_provider.dart';

class DebateCreate extends ConsumerStatefulWidget {
  const DebateCreate({super.key});

  @override
  ConsumerState<DebateCreate> createState() => _DebateCreateState();
}

class _DebateCreateState extends ConsumerState<DebateCreate> {
  final _formKey = GlobalKey<FormState>();
  int selectedIndex = 0;
  var title = '';
  final List<String> labels = ['연애', '정치', '연예', '자유', '스포츠'];

  void _goNextCreate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    // title 값을 저장
    ref.read(debateInfoProvider.notifier).updateDebateInfo(
        title: title,
        category: labels[selectedIndex],
        myArgument: '',
        opponentArgument: '',
        time: '',
        debateState: '토론 참여가능');

    if (!context.mounted) {
      return;
    }

    context.push('/debate_create_second');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 키보드 내리기
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: LinearPercentIndicator(
                    width: 200,
                    animation: true,
                    animationDuration: 1000,
                    lineHeight: 5.0,
                    percent: 0.5,
                    linearStrokeCap: LinearStrokeCap.butt,
                    progressColor: ColorSystem.purple,
                    backgroundColor: Colors.grey,
                    barRadius: const Radius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    '카테고리 선택',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(labels.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: SizedBox(
                          width: (MediaQuery.of(context).size.width - 80) * 0.2,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              textStyle:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              padding: const EdgeInsets.all(0),
                              backgroundColor: selectedIndex == index
                                  ? ColorSystem.black
                                  : ColorSystem.ligthGrey,
                              foregroundColor: selectedIndex == index
                                  ? Colors.white
                                  : const Color(0xff6B6B6B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            child: Text(
                              labels[index],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    '토론 주제',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: '입력하세요',
                      fillColor: Colors.grey[200],
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '주제를 입력하세요';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      title = value!;
                    },
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      // Handle AI topic generation
                    },
                    child: Row(
                      children: [
                        Image.asset('assets/images/ai_purple.png'),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'AI 주제 생성하기',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Color(0xff8E48F8),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _goNextCreate,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff8E48F8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text(
                '다음',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
