import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

class DottedSeparator extends StatelessWidget {
  const DottedSeparator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DottedLine(
      direction: Axis.horizontal,
      lineLength: double.infinity,
      lineThickness: 1.0,
      dashLength: 4.0,
      dashColor: Theme.of(context).backgroundColor.withOpacity(0.5),
      dashRadius: 1,
      dashGapLength: 4.0,
      dashGapColor: Colors.transparent,
      dashGapRadius: 0.0,
    );
  }
}
