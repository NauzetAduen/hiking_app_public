import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'custom_appbar.dart';

class LeadingAppbar extends CustomAppBar {
  LeadingAppbar(Widget title) : super(title);

  @override
  final List<Widget> actions = null;

  @override
  final Widget leading = Builder(builder: (BuildContext context) {
    return IconButton(
        icon: Icon(FontAwesomeIcons.arrowLeft),
        onPressed: () => Navigator.pop(context));
  });
}
