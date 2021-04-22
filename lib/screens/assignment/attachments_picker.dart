import 'dart:async';
import 'dart:io';

import 'package:bukutugas/helpers/helpers.dart';
import 'package:bukutugas/styles.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';

class AttachmentsPicker extends HookWidget {
  final picker = ImagePicker();

  final void Function(List<File>)? onChanges;

  AttachmentsPicker({this.onChanges});

  @override
  Widget build(BuildContext context) {
    final attachments = useState<List<File>>([]);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...attachments.value.map(
          (attachment) => AttachmentItem(
            attachment: attachment,
            onDelete: () {
              print('onDelete');
              attachments.value = attachments.value
                  .where(
                    (a) => a.path != attachment.path,
                  )
                  .toList();

              onChanges?.call(attachments.value);
            },
          ),
        ),
        DottedBorder(
          color: darken(
            Theme.of(context).bottomSheetTheme.backgroundColor!,
            0.4,
          ),
          strokeWidth: 2,
          radius: AppTheme.rounded.topLeft,
          borderType: BorderType.RRect,
          child: GestureDetector(
            onTap: () async {
              final imageSource = await askSource(context);

              if (imageSource == null) return;

              await pickImage(context, attachments, imageSource);

              onChanges?.call(attachments.value);
            },
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Theme.of(context).shadowColor,
                borderRadius: AppTheme.rounded,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.image_outlined,
                color: darken(
                  Theme.of(context).bottomSheetTheme.backgroundColor!,
                  0.4,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future pickImage(
    BuildContext context,
    ValueNotifier<List<File>> attachments,
    ImageSource imageSource,
  ) async {
    try {
      final pickedFile = await picker.getImage(
        source: imageSource,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 50,
      );

      if (pickedFile == null) return;

      attachments.value = [...attachments.value, File(pickedFile.path)];
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Ada kesalahan'),
        ),
      );
    }
  }

  Future<ImageSource?> askSource(BuildContext context) async {
    final completer = Completer<ImageSource?>();

    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      animationType: DialogTransitionType.scale,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      builder: (context) => AlertDialog(
        actionsPadding: const EdgeInsets.all(0),
        buttonPadding: const EdgeInsets.all(0),
        contentPadding: const EdgeInsets.all(14),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton.icon(
              icon: Icon(
                Icons.camera_alt_rounded,
                color: Theme.of(context).textTheme.headline2!.color,
              ),
              onPressed: () {
                completer.complete(ImageSource.camera);
                Navigator.of(context).pop();
              },
              label: Text(
                'Kamera',
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            SizedBox(width: 8),
            TextButton.icon(
              icon: Icon(
                Icons.image_rounded,
                color: Theme.of(context).textTheme.headline2!.color,
              ),
              onPressed: () {
                completer.complete(ImageSource.gallery);
                Navigator.of(context).pop();
              },
              label: Text(
                'Galeri',
                style: Theme.of(context).textTheme.headline2,
              ),
            )
          ],
        ),
      ),
    );

    return completer.future;
  }
}

class AttachmentItem extends StatelessWidget {
  final File attachment;
  final Function? onDelete;

  const AttachmentItem({
    Key? key,
    required this.attachment,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppTheme.rounded,
      child: Stack(
        children: [
          Container(
            width: 98,
            child: Image.file(attachment),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: InkWell(
              onTap: () {
                onDelete?.call();
              },
              child: Container(
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColorLight,
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 14,
                  color: Theme.of(context).backgroundColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
