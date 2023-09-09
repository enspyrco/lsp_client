# lsp_client

*A Dart client for communicating with the Dart analysis server using the Language Server Protocol (LSP).*

## Features

Dart's [analysis_server](https://github.com/dart-lang/sdk/tree/main/pkg/analysis_server) provides on-going static analysis results for a code base as the code changes.

This package provides:

- Dart classes for the Requests, Responses, Notifications and Errors described in the LSP spec
- Serialisation for sending Requests and receiving Responses over the wire as JSONRPC2 Objects

## Getting started

```dart
final AnalysisServer server; = AnalysisServer(
  config: AnalysisServerConfig(
    clientId: 'mycompany.com',
    clientVersion: '0.0.1',
    logFile: 'analysis_server_utils.log',
    sdkPath: '<path_to_flutter>/bin/cache/dart-sdk',
  ),
);

final AnalysisClient client =
  AnalysisClient(server.streamChannel);
```

## Usage

A Dart package that using the [lsp_client] must run the analysis server in a separate process and connect stdin/stdout...

```dart
const like = 'sample';
```

## Additional information

Language Server Protocol support is documented in [tool/lsp_spec/README.md](https://github.com/dart-lang/sdk/blob/main/pkg/analysis_server/tool/lsp_spec/README.md)

- See the [Official page for Language Server Protocol](https://microsoft.github.io/language-server-protocol/)

[JSON-RPC 2.0 Specification](https://www.jsonrpc.org/specification)
