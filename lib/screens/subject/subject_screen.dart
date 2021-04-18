import 'package:bukutugas/screens/subject/subject_sheet.dart';
import 'package:flutter/material.dart';

import './subject_header.dart';

class SubjectScreen extends StatelessWidget {
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
            child: SubjectHeader(),
          ),
          DraggableScrollableSheet(
            initialChildSize: bodySizeFactor,
            minChildSize: bodySizeFactor,
            // 1 - (Tinggi Header + Paddingnya SafeArea)
            maxChildSize: 1 -
                ((MediaQuery.of(context).padding.top + 28 + 24 * 2) /
                    size.height),
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
                      child: SubjectSheet(),
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
          Navigator.of(context).pushNamed('/assignment/create');
          // showMaterialModalBottomSheet(
          //   context: context,
          //   backgroundColor: Colors.transparent,
          //   builder: (context) => Padding(
          //     padding: EdgeInsets.only(
          //         bottom: MediaQuery.of(context).viewInsets.bottom),
          //     child: AddSubject(),
          //   ),
          // );
        },
        elevation: 6,
        child: const Icon(Icons.edit),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
