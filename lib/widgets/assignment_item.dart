import 'package:bukutugas/styles.dart';
import 'package:flutter/material.dart';

class AssignmentItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColorLight,
      borderRadius: AppTheme.roundedLg,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed('/assignment/detail');
        },
        borderRadius: AppTheme.roundedLg,
        child: Container(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Membuat Puisi',
                style: Theme.of(context).textTheme.headline2,
              ),
              Text(
                'Deadline, 12 Agustus 14:20',
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.normal,
                      fontSize: 12.0,
                    ),
              ),
              SizedBox(height: 8),
              Text(
                'Buat puisi dengan 4 sajak, minimal penempatan 2 huruf dan itu aja sih',
              ),
              if (true) ...[
                SizedBox(height: 14),
                AttachmentList(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class AttachmentList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Wrap(
        children: [
          Container(
            width: constraints.maxWidth / 3,
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Image.network(
                  'https://images.template.net/wp-content/uploads/2016/03/28101221/Project-initiation-document-template.jpg'),
            ),
          ),
          Container(
            width: constraints.maxWidth / 3,
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Image.network(
                  'https://images.template.net/wp-content/uploads/2016/03/28101221/Project-initiation-document-template.jpg'),
            ),
          ),
          Container(
            width: constraints.maxWidth / 3,
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Image.network(
                  'https://images.template.net/wp-content/uploads/2016/03/28101221/Project-initiation-document-template.jpg'),
            ),
          ),
          Container(
            width: constraints.maxWidth / 3,
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Image.network(
                  'https://images.template.net/wp-content/uploads/2016/03/28101221/Project-initiation-document-template.jpg'),
            ),
          ),
        ],
      );
    });
  }
}
