import 'dart:developer';

import 'package:devtools_app_shared/ui.dart';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FlutterGetItDevToolsExtension());
}

class FlutterGetItDevToolsExtension extends StatefulWidget {
  const FlutterGetItDevToolsExtension({super.key});

  @override
  State<FlutterGetItDevToolsExtension> createState() =>
      _FlutterGetItDevToolsExtensionState();
}

class _FlutterGetItDevToolsExtensionState
    extends State<FlutterGetItDevToolsExtension> {
  String erro = '';
  Map<String, dynamic> data = {};
  List<dynamic> instances = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      findInstances();
    });
    super.initState();
  }

  Future<void> findInstances() async {
    try {
      final response = await serviceManager.callServiceExtensionOnMainIsolate(
          'ext.br.com.academiadoflutter.flutter_getit.listAll');
      setState(() {
        final responseData = response.json?['data'];
        data = responseData ?? {};
      });
    } catch (e, s) {
      setState(() {
        erro = 'Erro $e';
      });
      log('erro', error: e, stackTrace: s);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DevToolsExtension(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: AreaPaneHeader(
              roundedTopBorder: false,
              includeTopBorder: false,
              tall: true,
              dense: true,
              
              title: const Text('Flutter GetIt Instances', style: TextStyle(fontSize: 20),),
              actions: [
                ElevatedButton(onPressed: (){
                   findInstances();
                }, child: const Text('Update List Instances')),
              ],
            ),
          ),
          const SliverToBoxAdapter(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text('Key'),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text('Instances'),
                  ),
                ),
              ],
            ),
          ),
          // SliverGrid.count(
          //   crossAxisCount: 2,
          //   childAspectRatio: 10,
          //   children: const [
          //     Padding(
          //       padding: EdgeInsets.all(10.0),
          //       child: Text('Key'),
          //     ),
          //     Padding(
          //       padding: EdgeInsets.all(10.0),
          //       child: Text('Instances'),
          //     ),
          //   ],
          // ),
          SliverGrid.count(
            crossAxisCount: 2,
            children: [
              ListView.builder(
                itemCount: data.keys.length,
                itemBuilder: (context, index) {
                  final keysList = data.keys.toList();
                  return ListTile(
                    onTap: () {
                      setState(() {
                        instances = data[keysList[index]];
                      });
                    },
                    title: Text(keysList[index]),
                  );
                },
              ),
              ListView.builder(
                itemCount: instances.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        '${instances[index]['className']} (${instances[index]['type']})'),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
