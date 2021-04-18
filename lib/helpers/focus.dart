import 'package:flutter/cupertino.dart';

void clearFocus(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}
