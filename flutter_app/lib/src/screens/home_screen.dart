import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String valueReceived = '';
  static const channelName = MethodChannel('example.com/channel');
  static const getMethodData = "data";

  Future<void> getValueReceived() async {
    try {
      valueReceived = await channelName.invokeMethod(getMethodData);
    } on PlatformException {
      valueReceived = '';
    }
    setState(() {
      valueReceived;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => SystemNavigator.pop(animated: true),
        ),
        title: const Text('Flutter'),
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Value received:',
            ),
            Text(
              valueReceived,
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getValueReceived,
        tooltip: 'Generate',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
