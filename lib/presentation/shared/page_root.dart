import 'package:flutter/material.dart';
import 'package:result_type/result_type.dart';

typedef TransitionResult = Future<Result<void, Exception>>;

class PageRoot extends StatefulWidget {
  const PageRoot({
    super.key,
    required this.onLoading,
    required this.onDisposed,
    required this.success,
    required this.loading,
    required this.failure,
  });

  final TransitionResult Function() onLoading;
  final VoidCallback onDisposed;
  final Widget Function(BuildContext context) success;
  final Widget Function(BuildContext context) loading;
  final Widget Function(BuildContext context, Exception exception) failure;

  @override
  State<PageRoot> createState() => _PageRootState();
}

class _PageRootState extends State<PageRoot> {
  TransitionResult? result;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        result = widget.onLoading();
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.onDisposed();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: result,
      builder: ((context, snapshot) {
        final data = snapshot.data;
        if (snapshot.hasData && data != null) {
          if (data.isSuccess) {
            return widget.success(context);
          } else {
            return widget.failure(context, data.failure);
          }
        } else {
          return widget.loading(context);
        }
      }),
    );
  }
}
