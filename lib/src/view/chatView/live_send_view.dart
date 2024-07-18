import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/provider/live_comment.dart';

class LiveSendView extends ConsumerWidget {
  final String username;
  final String roomId;

  const LiveSendView({
    super.key,
    required this.username,
    required this.roomId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveCommentViewModel = ref.read(liveCommentProvider(roomId).notifier);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: liveCommentViewModel.controller,
              autocorrect: false,
              decoration: InputDecoration(
                hintText: '실시간 댓글로 방청자와 소통해보세요!',
                fillColor: Colors.grey[200],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
              ),
              onSubmitted: (value) {
                liveCommentViewModel.sendMessage(value);
                liveCommentViewModel.controller.clear();
              },
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              liveCommentViewModel
                  .sendMessage(liveCommentViewModel.controller.text);
              liveCommentViewModel.controller.clear();
            },
            icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
          ),
        ],
      ),
    );
  }
}
