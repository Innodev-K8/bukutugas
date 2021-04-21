import 'package:bukutugas/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/services.dart';

import 'add_subject.dart';
import 'home_header.dart';
import 'home_sheet.dart';

class HomeScreen extends HookWidget {
  final _headerHeight = 280.0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final headerSizeFactor = (_headerHeight / size.height);
    final bodySizeFactor = 1 - headerSizeFactor;

    // dont forget to change this if we change header height eg. margin & paddings
    final headerContentSizeFactor = (184 / size.height);

    final sheetLimit =
        bodySizeFactor + (headerSizeFactor - headerContentSizeFactor);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Stack(
          children: [
            Container(
              height: _headerHeight,
              child: HomeHeader(),
            ),
            DraggableScrollableSheet(
              initialChildSize: bodySizeFactor,
              minChildSize: bodySizeFactor,
              maxChildSize: sheetLimit,
              builder: (context, scrollController) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: Theme.of(context).dialogBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: HomeSheet(),
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showMaterialModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SubjectBottomSheetDialog(),
              ),
            );
          },
          elevation: 6,
          child: const Icon(Icons.add_rounded),
          backgroundColor: darken(
            Theme.of(context).backgroundColor,
          ),
        ),
      ),
    );
  }
}
