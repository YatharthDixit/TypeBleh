// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ClientState {
  final Map<String, dynamic> timer;
  ClientState({
    required this.timer,
  });

  ClientState copyWith({
    Map<String, dynamic>? timer,
  }) {
    return ClientState(
      timer: timer ?? this.timer,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'timer': timer,
    };
  }

  factory ClientState.fromMap(Map<String, dynamic> map) {
    return ClientState(
      timer: Map<String, dynamic>.from((map['timer'] as Map<String, dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory ClientState.fromJson(String source) =>
      ClientState.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ClientState(timer: $timer)';

  @override
  bool operator ==(covariant ClientState other) {
    if (identical(this, other)) return true;

    return mapEquals(other.timer, timer);
  }

  @override
  int get hashCode => timer.hashCode;
}
