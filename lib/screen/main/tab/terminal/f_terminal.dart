import 'dart:math';

import 'package:flutter/material.dart';
import 'package:face_recognition_module/common/util/my_logger.dart';

class TerminalFragment extends StatelessWidget {
  const TerminalFragment({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green.withOpacity(0.2),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Terminal"),
          Row(
            children: [
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {},
                child: const Text("Init"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {},
                child: const Text("Enroll"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {},
                child: const Text("Verify"),
              ),
              const SizedBox(width: 10),
            ],
          )
        ],
      ),
    );
  }
}
