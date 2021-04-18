import 'package:bukutugas/helpers/helpers.dart';
import 'package:bukutugas/providers/available_color_provider.dart';
import 'package:bukutugas/styles.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ColorSelector extends StatefulWidget {
  final Color color;
  final void Function(Color color)? onChange;
  final bool readOnly;

  const ColorSelector(
      {Key? key, required this.color, this.onChange, this.readOnly = false})
      : super(key: key);

  @override
  _ColorSelectorState createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<ColorSelector> {
  Color _color = Color(0xFFFFF);

  @override
  void initState() {
    super.initState();

    _color = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!widget.readOnly) showColorPicker();
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: DottedBorder(
                color: widget.readOnly
                    ? darken(Theme.of(context).backgroundColor)
                    : Colors.transparent,
                strokeWidth: 2,
                radius: AppTheme.rounded.topLeft,
                borderType: BorderType.RRect,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _color,
                    borderRadius: AppTheme.rounded,
                  ),
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
          if (!widget.readOnly)
            Positioned(
              bottom: 0,
              right: 0,
              child: Icon(
                Icons.edit,
                color: Theme.of(context).backgroundColor,
              ),
            ),
        ],
      ),
    );
  }

  void showColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        backgroundColor: Theme.of(context).primaryColorLight,
        title: Text('Pilih Warna'),
        content: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Wrap(
            children: context
                .read(availableColorProvider)
                .map(
                  (color) => GestureDetector(
                    onTap: () {
                      setState(() {
                        _color = color;
                      });

                      widget.onChange?.call(color);

                      Navigator.of(context).pop();
                    },
                    child: SizedBox(
                      width: constraints.maxWidth / 4,
                      height: constraints.maxWidth / 4,
                      child: _buildColorPickerItem(color, _color),
                    ),
                  ),
                )
                .toList(),
          );
        }),
      ),
    );

    // showDialog(
    //   context: context,
    //   builder: (_) => AlertDialog(
    //     // contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
    //     backgroundColor: Theme.of(context).primaryColorLight,
    //     title: Text('Pilih Warna'),
    //     content: SingleChildScrollView(
    //       child: BlockPicker(
    //         pickerColor: _color,
    //         onColorChanged: (color) {},
    //         availableColors: [
    //           HexColor('#F8A488'),
    //           HexColor('#5AA897'),
    //           HexColor('#45526C'),
    //           HexColor('#8996AE')
    //         ],
    //         itemBuilder: (color, isCurrentColor, changeColor) => AspectRatio(
    //           aspectRatio: 1,
    //           child: Container(
    //             margin: const EdgeInsets.all(4.0),
    //             decoration: BoxDecoration(
    //               color: color,
    //               shape: BoxShape.circle,
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  Container _buildColorPickerItem(Color color, Color currentColor) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: color == currentColor
            ? Border.all(
                color: darken(color),
                width: 4.0,
              )
            : null,
      ),
    );
  }
}
