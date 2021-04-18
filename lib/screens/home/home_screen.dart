import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:bukutugas/widgets/widgets.dart';

import 'home_header.dart';
import 'home_sheet.dart';

class HomeScreen extends HookWidget {
  final _headerHeight = 280.0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bodySizeFactor = 1 - (_headerHeight / size.height);

    return Scaffold(
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
            maxChildSize: bodySizeFactor + (0.12),
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
              child: AddSubject(),
            ),
          );
        },
        elevation: 6,
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
