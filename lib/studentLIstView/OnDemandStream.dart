// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum StreamConnectionStatus { waiting, success, error }

class OnDemandStream extends StatefulWidget {
  final Query<Map<String, dynamic>> Function() streamProvider;
  final Widget Function(BuildContext context, Iterable<DocumentSnapshot> docs, StreamConnectionStatus, void Function() loadMore) builder;
  late final Widget Function(BuildContext, StreamConnectionStatus) statusHandle;
  final int cacheJumpSize;

  OnDemandStream({
    required this.streamProvider,
    required this.builder,
    statusHandle,
    this.cacheJumpSize = 10,
    super.key,
  }) {
    this.statusHandle = statusHandle ??
        (context, status) {
          return switch (status) {
            StreamConnectionStatus.waiting => const Center(child: CircularProgressIndicator()),
            StreamConnectionStatus.success => const Text("Loading Completed!"),
            StreamConnectionStatus.error => const Text("Loading Failed!"),
          };
        };
  }

  @override
  State<OnDemandStream> createState() => _OnDemandStreamState();
}

class _OnDemandStreamState extends State<OnDemandStream> {
  List<DocumentSnapshot> cache = [];
  StreamConnectionStatus connectionState = StreamConnectionStatus.waiting;

  void loadMore() => widget.streamProvider().startAfterDocument(cache.last).limit(widget.cacheJumpSize).get().then(
        (value) => setState(() => cache.addAll(value.docs)),
        onError: (e) => setState(() => connectionState = StreamConnectionStatus.error),
      );

  @override
  Widget build(BuildContext context) {
    // Initial loading
    if (cache.isEmpty)
      widget.streamProvider().limit(widget.cacheJumpSize).get().then(
            (value) => setState(() {
              cache.addAll(value.docs);
              connectionState = StreamConnectionStatus.success;
            }),
            onError: (e) => setState(() => connectionState = StreamConnectionStatus.error),
          );

    return cache.isEmpty ? widget.statusHandle(context, connectionState) : widget.builder(context, cache, connectionState, loadMore);
  }
}
