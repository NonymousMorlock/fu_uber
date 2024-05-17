import 'package:flutter/material.dart';
import 'package:fu_uber/Core/Constants/colorConstants.dart';

class CircularFlatButton extends StatelessWidget {
  final double? size;
  final Widget? child;
  final String name;
  final VoidCallback? onPressed;

  const CircularFlatButton({
    super.key,
    this.size,
    required this.name,
    this.onPressed,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: size,
        width: size,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              // disabledColor: ConstantColors.DeepBlue.withOpacity(0.2),
              disabledBackgroundColor: ConstantColors.DeepBlue.withOpacity(0.2),
            ),
            onPressed: onPressed,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (child != null) child!,
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.deepPurpleAccent,
                  ),
                )
              ],
            )));
  }
}
