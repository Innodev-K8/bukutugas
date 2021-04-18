import 'package:bukutugas/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:bukutugas/widgets/widgets.dart';

class DetailAssignmentScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 28 + 24 * 2,
                        padding: const EdgeInsets.all(24.0),
                        child: Stack(
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(24.0),
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Icon(
                                Icons.chevron_left,
                                color: Theme.of(context).backgroundColor,
                                size: 28.0,
                              ),
                            ),
                            Center(
                              child: Text(
                                'Membuat Puisi',
                                style: Theme.of(context).textTheme.headline2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Deadline, 12 Agustus 14:00',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                  ),
                            ),
                            Text(
                              'Membuat Puisi',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(
                                    color: AppTheme.orange,
                                  ),
                            ),
                            SizedBox(height: 14),
                            Text(
                                'Buat puisi dengan 4 sajak, minimal penempatan 2 huruf dan itu aja sih'),
                            SizedBox(height: 14),
                            Text(
                              'Lampiran',
                              style: Theme.of(context).textTheme.headline2,
                            ),
                            SizedBox(height: 14.0),
                            AttachmentList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 14.0,
                ),
                width: double.infinity,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        child: Icon(
                          Icons.delete,
                          color: Colors.red[300],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Selesai',
                          style:
                              Theme.of(context).textTheme.headline4!.copyWith(
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Theme.of(context).accentColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
