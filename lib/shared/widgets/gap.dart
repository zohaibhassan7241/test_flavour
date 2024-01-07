import 'package:flutter/material.dart';

class Gap extends StatelessWidget {
  const Gap(this.spacing, {super.key});
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final parentWidget = context.findAncestorWidgetOfExactType<Row>() ??
            context.findAncestorWidgetOfExactType<Row>();

        final isRow = parentWidget is Row;
        return SizedBox(
          width: isRow ? spacing : null,
          height: isRow ? null : spacing,
        );
      },
    );
  }
}
