import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../core/config/app_config.dart';
import '../../domain/entities/chat_realtime_event.dart';
import '../data_sources/chat_data_source.dart';
import '../models/chat_message_model.dart';

final class ChatWebSocketService {
  ChatWebSocketService(this._dataSource);

  final ChatDataSource _dataSource;
  final _events = StreamController<ChatRealtimeEvent>.broadcast();
  StreamSubscription<dynamic>? _subscription;
  WebSocketChannel? _socket;
  Timer? _pingTimer;

  Stream<ChatRealtimeEvent> get events => _events.stream;

  Future<void> connect(String chatRoomId) async {
    await disconnect();
    if (AppConfig.wsUrl.isEmpty) return;

    final ticket = await _dataSource.createWebSocketTicket();
    final endpoint = Uri.parse(AppConfig.wsUrl).replace(
      path: '/ws/chat/$chatRoomId/',
      queryParameters: {'ticket': ticket},
    );
    final socket = WebSocketChannel.connect(endpoint);
    _socket = socket;
    _subscription = socket.stream.listen(
      _onData,
      onError: (_, _) => _events.add(
        const ChatRealtimeEvent.error('WebSocket connection failed.'),
      ),
      onDone: () {
        _pingTimer?.cancel();
        _pingTimer = null;
        _socket = null;
      },
    );
    _pingTimer = Timer.periodic(const Duration(seconds: 30), (_) => _ping());
  }

  void sendTyping() => _send({'type': 'typing'});

  void _ping() => _send({'type': 'ping'});

  void _send(Map<String, String> payload) {
    try {
      _socket?.sink.add(jsonEncode(payload));
    } catch (_) {}
  }

  void _onData(dynamic raw) {
    if (raw is! String) return;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return;
      final data = decoded.map((key, value) => MapEntry(key.toString(), value));
      switch (data['type']?.toString()) {
        case 'message':
          final message = data['message'];
          if (message is Map) {
            _events.add(
              ChatRealtimeEvent.message(
                ChatMessageModel.fromJson(
                  message.map((key, value) => MapEntry(key.toString(), value)),
                ).toEntity(),
              ),
            );
          }
        case 'typing':
          final sender = data['sender']?.toString();
          if (sender != null && sender.isNotEmpty) {
            _events.add(ChatRealtimeEvent.typing(sender));
          }
        case 'error':
          _events.add(
            ChatRealtimeEvent.error(data['detail']?.toString() ?? ''),
          );
        case 'pong':
          _events.add(const ChatRealtimeEvent.pong());
      }
    } catch (_) {}
  }

  Future<void> disconnect() async {
    _pingTimer?.cancel();
    _pingTimer = null;
    await _subscription?.cancel();
    _subscription = null;
    await _socket?.sink.close();
    _socket = null;
  }

  Future<void> dispose() async {
    await disconnect();
    await _events.close();
  }
}
