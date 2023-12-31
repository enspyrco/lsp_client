import 'dart:async';

class MoreTypedStreamController<T, ListenData, PauseData> {
  final StreamController<T> controller;

  /// A wrapper around [StreamController] that statically guarantees its
  /// clients that [onPause] and [onCancel] can only be invoked after
  /// [onListen], and [onResume] can only be invoked after [onPause].
  ///
  /// There is no static guarantee that [onPause] will not be invoked twice.
  ///
  /// Internally the wrapper is not safe, and uses explicit null checks.
  factory MoreTypedStreamController({
    required ListenData Function(StreamController<T>) onListen,
    PauseData Function(ListenData)? onPause,
    void Function(ListenData, PauseData)? onResume,
    FutureOr<void> Function(ListenData)? onCancel,
    bool sync = false,
  }) {
    ListenData? listenData;
    PauseData? pauseData;
    var controller = StreamController<T>(
      onPause: () {
        if (pauseData != null) {
          throw StateError('Already paused');
        }
        var local_onPause = onPause;
        if (local_onPause != null) {
          pauseData = local_onPause(listenData as ListenData);
        }
      },
      onResume: () {
        var local_onResume = onResume;
        if (local_onResume != null) {
          var local_pauseData = pauseData as PauseData;
          pauseData = null;
          local_onResume(listenData as ListenData, local_pauseData);
        }
      },
      onCancel: () {
        var local_onCancel = onCancel;
        if (local_onCancel != null) {
          var local_listenData = listenData as ListenData;
          listenData = null;
          local_onCancel(local_listenData);
        }
      },
      sync: sync,
    );
    controller.onListen = () {
      listenData = onListen(controller);
    };
    return MoreTypedStreamController._(controller);
  }

  MoreTypedStreamController._(this.controller);
}
