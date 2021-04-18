import 'package:bukutugas/styles.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

class EmojiSelector extends StatefulWidget {
  final String? emoji;
  final void Function(String emoji)? onChange;

  const EmojiSelector({Key? key, this.emoji, this.onChange}) : super(key: key);

  @override
  _EmojiSelectorState createState() => _EmojiSelectorState();
}

class _EmojiSelectorState extends State<EmojiSelector> {
  String _emoji = '';

  @override
  void initState() {
    super.initState();

    _emoji = widget.emoji ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showEmojiPicker();
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppTheme.rounded,
                ),
                alignment: Alignment.center,
                child: Text(
                  _emoji,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ),
          ),
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

  void showEmojiPicker() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        backgroundColor: Theme.of(context).primaryColorLight,
        content: Container(
          height: 400,
          child: EmojiPicker(
            onEmojiSelected: (category, emoji) {
              setState(() {
                _emoji = emoji.emoji;
              });

              widget.onChange?.call(_emoji);

              Navigator.pop(context);
            },
            config: Config(
              columns: 4,
              emojiSizeMax: 32.0,
              verticalSpacing: 0,
              horizontalSpacing: 0,
              initCategory: Category.RECENT,
              bgColor: Theme.of(context).primaryColorLight,
              indicatorColor: Colors.blue,
              iconColor: Colors.grey,
              iconColorSelected: Colors.blue,
              progressIndicatorColor: Colors.blue,
              showRecentsTab: true,
              recentsLimit: 28,
              noRecentsText: "No Recents",
              noRecentsStyle:
                  const TextStyle(fontSize: 20, color: Colors.black26),
              categoryIcons: const CategoryIcons(),
              buttonMode: ButtonMode.MATERIAL,
            ),
          ),
        ),
      ),
    );
  }
}
