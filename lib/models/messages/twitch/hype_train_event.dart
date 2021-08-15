import 'package:flutter/cupertino.dart';
import 'package:rtchat/models/messages/message.dart';

class TwitchHypeTrainEventModel extends MessageModel {
  final int level;
  final int progress;
  final int goal;
  final int total;
  final bool isSuccessful;
  final bool hasEnded;

  const TwitchHypeTrainEventModel(
      {required bool pinned,
      required String messageId,
      required this.level,
      required this.progress,
      required this.goal,
      required this.total,
      this.isSuccessful = false,
      this.hasEnded = false})
      : super(messageId: messageId, pinned: pinned);

  static TwitchHypeTrainEventModel fromDocumentData(
      Map<String, dynamic>? data) {
    return TwitchHypeTrainEventModel(
        pinned: true,
        messageId: "channel.hype_train-${data!['event']['id']}",
        level: data['event']['level'] ?? 1,
        progress: data['event']['progress'],
        goal: data['event']['goal'],
        total: data['event']['total']);
  }

  TwitchHypeTrainEventModel withProgress(Map<String, dynamic>? data) {
    final level = data!['event']['level'];
    final total = data['event']['total'];

    if (this.level > level || this.total > total) {
      return this;
    }

    return fromDocumentData(data);
  }

  TwitchHypeTrainEventModel withEnd(
      {required Map<String, dynamic>? data, required bool pinned}) {
    final level = data!['event']['level'];
    final total = data['event']['total'];

    final wasSuccessful = level > 1;
    final previousLevel = level == 1 ? 1 : level - 1;
    final endLevel = progress >= goal ? level : previousLevel;

    return TwitchHypeTrainEventModel(
        pinned: pinned,
        messageId: messageId,
        level: endLevel,
        progress: progress,
        goal: goal,
        total: total,
        isSuccessful: wasSuccessful,
        hasEnded: true);
  }

  @override
  bool operator ==(Object other) =>
      other is TwitchHypeTrainEventModel &&
      other.level == level &&
      other.progress == progress &&
      other.goal == goal &&
      other.total == total &&
      other.isSuccessful == isSuccessful &&
      other.hasEnded == hasEnded;

  @override
  int get hashCode =>
      hashValues(level, progress, goal.hashCode, total, isSuccessful, hasEnded);
}