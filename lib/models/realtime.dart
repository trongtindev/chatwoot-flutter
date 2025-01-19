import '/imports.dart';

class TypingUser {
  final int id;
  final String name;
  final String thumbnail;

  const TypingUser({
    required this.id,
    required this.name,
    required this.thumbnail,
  });

  factory TypingUser.fromJson(dynamic json) {
    return TypingUser(
      id: json['id'],
      name: json['name'],
      thumbnail: json['thumbnail'],
    );
  }
}

class TypingData {
  final int account_id;
  final ConversationInfo conversation;
  final TypingUser user;

  const TypingData({
    required this.account_id,
    required this.conversation,
    required this.user,
  });

  factory TypingData.fromJson(dynamic json) {
    return TypingData(
      account_id: json['account_id'],
      conversation: ConversationInfo.fromJson(json['conversation']),
      user: TypingUser.fromJson(json['user']),
    );
  }
}
