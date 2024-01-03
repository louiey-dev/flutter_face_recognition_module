import 'dart:typed_data';

import 'package:cp949_codec/cp949_codec.dart';
import 'package:face_recognition_module/common/widget/w_empty_expanded.dart';
import 'package:face_recognition_module/screen/main/s_main.dart';
import 'package:face_recognition_module/screen/main/tab/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:face_recognition_module/common/util/my_logger.dart';
import 'package:face_recognition_module/common/util/utils.dart';

enum ConfigItem { eSerialCom, eTcpClient, eTcpServer, eUdp }

ConfigItem configIndex = ConfigItem.eSerialCom;

enum ConfigMenuItem {
  eMenuSerial,
}

ConfigMenuItem menuItem = ConfigMenuItem.eMenuSerial;

bool logChecked = false;

class ConfigFragment extends StatefulWidget {
  const ConfigFragment({super.key});

  @override
  State<ConfigFragment> createState() => _ConfigFragmentState();
}

class _ConfigFragmentState extends State<ConfigFragment> {
  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // selectMode(),
        // const EmptyExpanded(),
        const SizedBox(
          height: 20,
        ),
        selectMenu(),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: TextField(
              enabled:
                  (_serialPort != null && _serialPort!.isOpen) ? true : false,
              controller: textInputCtrl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Input string here',
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Expanded(
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: (_serialPort != null && _serialPort!.isOpen)
                      ? () {
                          if (_serialPort!.write(Uint8List.fromList(
                                  textInputCtrl.text.codeUnits)) ==
                              textInputCtrl.text.codeUnits.length) {
                            setState(() {
                              textInputCtrl.text = '';
                            });
                          }
                        }
                      : null,
                  icon: const Icon(Icons.send),
                  label: const Text("Send"),
                ),
                const SizedBox(width: 20),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      receiveDataList.clear();
                      showSnackbar(context, "Rx log cleared");
                    });
                  },
                  icon: const Icon(Icons.cleaning_services),
                  label: const Text("Clear"),
                ),
                const SizedBox(width: 20),
                Checkbox(
                  value: logChecked,
                  onChanged: (value) {
                    setState(() {
                      logChecked = value!;

                      if (logChecked) {
                        showSnackbar(context, "Log enabled");
                      } else {
                        showSnackbar(context, "Log disabled");
                      }
                    });
                  },
                ),
                const Text("Log"),
                const SizedBox(width: 20),
                ElevatedButton(
                    onPressed: () {
                      uartSend("init");
                    },
                    child: const Text("Init")),
                const SizedBox(width: 20),
                ElevatedButton(
                    onPressed: () {
                      uartSend("version");
                    },
                    child: const Text("version")),
                const SizedBox(width: 20),
                ElevatedButton(
                    onPressed: () {
                      uartSend("clear");
                    },
                    child: const Text("clear")),
                const SizedBox(width: 20),
                ElevatedButton(
                    onPressed: () {
                      uartSend("enroll");
                    },
                    child: const Text("enroll")),
                const SizedBox(width: 20),
                ElevatedButton(
                    onPressed: () {
                      uartSend("verify");
                    },
                    child: const Text("verify")),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Card(
            margin: const EdgeInsets.all(10.0),
            child: ListView.builder(
                itemCount: receiveDataList.length,
                itemBuilder: (context, index) {
                  /*
                    OUTPUT for raw bytes
                    return Text(receiveDataList[index].toString());
                    */
                  /* output for string */
                  return Text(String.fromCharCodes(receiveDataList[index]));
                }),
          ),
        ),
      ],
    );
  }

  selectMode() {
    return Column(
      children: [
        RadioListTile(
          title: const Text(
            'Serial(COM)',
          ),
          value: ConfigItem.eSerialCom,
          groupValue: configIndex,
          onChanged: (value) {
            setState(() {
              configIndex = value!;
              menuItem = ConfigMenuItem.eMenuSerial;
            });
            userLog('selected $value');
          },
        ),
      ],
    );
  }

  selectMenu() {
    switch (menuItem) {
      case ConfigMenuItem.eMenuSerial:
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: showMenuSerial(),
        );

      default:
        return const Column(
          children: [
            // Text('menu'),
          ],
        );
    }
  }

  SerialPort? _serialPort;
  List<SerialPort> portList = [];
  List<int> baudRate = [9600, 38400, 115200];
  int menuBaudRate = 115200;
  List<Uint8List> receiveDataList = [];
  final textInputCtrl = TextEditingController();
  var openButtonText = "Open";

  showMenuSerial() {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 20),
            const Text('COM port : '),
            const SizedBox(width: 30),
            DropdownButton(
              value: _serialPort,
              items: portList.map((item) {
                return DropdownMenuItem(
                    value: item, child: Text("${item.name}"));
                // child: Text(
                //     "${item.name}: ${cp949.decodeString(item.description ?? '')}"));
              }).toList(),
              onChanged: (e) {
                setState(() {
                  changedDropDownItem(e as SerialPort);
                });
              },
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                comOpen();
              },
              child: const Text('COM'),
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(width: 20),
            const Text('Baud rate(bps) : '),
            DropdownButton(
              value: menuBaudRate,
              items: baudRate
                  .map((e) => DropdownMenuItem(
                        value: e, // 선택 시 onChanged 를 통해 반환할 value
                        child: Text(e.toString()),
                      ))
                  .toList(),
              onChanged: (value) {
                // items 의 DropdownMenuItem 의 value 반환
                setState(() {
                  menuBaudRate = value!;
                  showSnackbar(context, menuBaudRate.toString());
                });
              },
            ),
            const SizedBox(
              width: 20,
            ),
            ElevatedButton(
              child: Text(openButtonText),
              onPressed: () {
                if (_serialPort == null) {
                  return;
                }
                if (_serialPort!.isOpen) {
                  _serialPort!.close();
                  debugPrint('${_serialPort!.name} closed!');
                  openButtonText = "Open";
                  showSnackbar(context, "COM Port closed");
                } else {
                  if (_serialPort!.open(mode: SerialPortMode.readWrite)) {
                    SerialPortConfig config = _serialPort!.config;
                    // https://www.sigrok.org/api/libserialport/0.1.1/a00007.html#gab14927cf0efee73b59d04a572b688fa0
                    // https://www.sigrok.org/api/libserialport/0.1.1/a00004_source.html
                    config.baudRate = menuBaudRate;
                    config.parity = 0;
                    config.bits = 8;
                    config.cts = 0;
                    config.rts = 0;
                    config.stopBits = 1;
                    config.xonXoff = 0;
                    _serialPort!.config = config;
                    if (_serialPort!.isOpen) {
                      debugPrint('${_serialPort!.name} opened!');
                      openButtonText = "Close";
                      showSnackbar(context, "COM Port opened");
                    }
                    final reader = SerialPortReader(_serialPort!);
                    reader.stream.listen((data) {
                      debugPrint('received: ${data.length}');
                      receiveDataList.add(data);
                      setState(() {});
                    }, onError: (error) {
                      if (error is SerialPortError) {
                        debugPrint(
                            'error: ${cp949.decodeString(error.message)}, code: ${error.errorCode}');
                      }
                    });
                    // setState(() {
                    //   currentTab = TabItem.terminal;
                    // });
                  } else {
                    showSnackbar(context, "COM open error");
                  }
                }
                setState(() {});
              },
            ),
          ],
        ),
      ],
    );
  }

  void changedDropDownItem(SerialPort sp) {
    setState(() {
      _serialPort = sp;
    });
  }

  comOpen() {
    setState(() {
      var i = 0;
      portList.clear();

      for (final name in SerialPort.availablePorts) {
        final sp = SerialPort(name);
        if (true) {
          userLog('${++i}) $name');
          userLog('\tDescription: ${cp949.decodeString(sp.description ?? '')}');
          userLog('\tManufacturer: ${sp.manufacturer}');
          userLog('\tSerial Number: ${sp.serialNumber}');
          userLog('\tProduct ID: 0x${sp.productId?.toRadixString(16) ?? 00}');
          userLog('\tVendor ID: 0x${sp.vendorId?.toRadixString(16) ?? 00}');
        }
        portList.add(sp);
      }
      if (portList.isNotEmpty) {
        _serialPort = portList.first;
      }
    });
  }

  uartSend(String cmdStr) {
    if (_serialPort != null && _serialPort!.isOpen) {
      _serialPort!.write(Uint8List.fromList(cmdStr.codeUnits));
    }
  }
}
