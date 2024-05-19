import 'package:flutter/material.dart';

class NoConnectionWidget extends StatelessWidget {
  const NoConnectionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Spacer(),
              Icon(
                Icons.signal_wifi_off_rounded,
                size: 72,
              ),
              Text(
                "  OR ",
                style: TextStyle(fontSize: 36),
              ),
              Icon(
                Icons.signal_cellular_nodata_rounded,
                size: 72,
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
