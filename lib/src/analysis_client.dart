import 'dart:convert';

import 'package:stream_channel/stream_channel.dart';

import 'lsp_packet_transformer.dart';

/// The [AnalysisClient] wraps a [StreamChannel] that is assumed to be a
/// directly streaming bytes to & from an analysis_server process, where each
/// message has been encoded according to the LSP spec, see: https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#baseProtocol
class AnalysisClient {
  AnalysisClient(this._serverChannel);

  final StreamChannel<List<int>> _serverChannel;
  final buffer = <int>[];

  void initializeServer() {}

  /// Call a server method by wrapping and sending the passed RPC params,
  /// prefixed with the required LSP headers.
  void call(
      {required String method, required Map<String, Object?> params, int? id}) {
    Map<String, Object?> bodyJson = {
      'jsonrpc': '2.0',
      'method': method,
      'params': params,
      'id': id,
    };

    // Encode header as ascii & body as utf8, as per LSP spec.
    final jsonEncodedBody = jsonEncode(bodyJson);
    final utf8EncodedBody = utf8.encode(jsonEncodedBody);
    final header = 'Content-Length: ${utf8EncodedBody.length}\r\n'
        'Content-Type: application/vscode-jsonrpc; charset=utf-8\r\n\r\n';
    final asciiEncodedHeader = ascii.encode(header);

    // Send the message to the analysis_server process' stdin
    _serverChannel.sink.add(asciiEncodedHeader);
    _serverChannel.sink.add(utf8EncodedBody);
  }

  //
  Stream<Map<String, Object?>> get onJsonFromServer => _serverChannel.stream
      .transform(LspPacketTransformer())
      .map((event) => jsonDecode(event) as Map<String, Object?>);
}
