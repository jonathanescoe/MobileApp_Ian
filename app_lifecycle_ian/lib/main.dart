import 'package:flutter/material.dart';

void main() => runApp(const WidgetBindingObserverExampleApp());

class WidgetBindingObserverExampleApp extends StatelessWidget {
  const WidgetBindingObserverExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('App Lifecycle States')),
        body: const WidgetBindingsObserverSample(),
      ),
    );
  }
}

class WidgetBindingsObserverSample extends StatefulWidget {
  const WidgetBindingsObserverSample({super.key});

  @override
  State<WidgetBindingsObserverSample> createState() =>
      _WidgetBindingsObserverSampleState();
}

class _WidgetBindingsObserverSampleState
    extends State<WidgetBindingsObserverSample>
    with WidgetsBindingObserver {
  final List<AppLifecycleState> _stateHistoryList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    final initialState = WidgetsBinding.instance.lifecycleState;
    if (initialState != null) {
      _stateHistoryList.add(initialState);
      debugPrint('App lifecycle state: $initialState');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // This prints a message every time the APP lifecycle state changes.
    debugPrint('App lifecycle changed to: $state');

    setState(() {
      _stateHistoryList.add(state);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_stateHistoryList.isNotEmpty) {
      return ListView.builder(
        itemCount: _stateHistoryList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('State is: ${_stateHistoryList[index].name}'),
          );
        },
      );
    }

    return const Center(
      child: Text('There are no app lifecycle states to show.'),
    );
  }
}
