import 'package:flutter/material.dart';

class FilledButtonLarge extends StatefulWidget {
  const FilledButtonLarge({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;

  final void Function()? onPressed;

  @override
  State<FilledButtonLarge> createState() => _FilledButtonLargeState();
}

class _FilledButtonLargeState extends State<FilledButtonLarge>
    with SingleTickerProviderStateMixin {
  WidgetStatesController buttonStateController = WidgetStatesController();
  late final AnimationController animationController;
  late final Animation<BorderRadius?> animation;

  Tween<BorderRadius> tween = Tween(
    begin: BorderRadius.all(Radius.circular(99)),
    end: BorderRadius.all(Radius.circular(16)),
  );

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 350),
    );
    animation = tween.animate(
      CurvedAnimation(
        parent: animationController,
        curve: Cubic(0.42, 1.67, 0.21, 0.90),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,

      builder: (context, child) {
        return Listener(
          onPointerDown: (event) {
            animationController.forward();
          },

          onPointerUp: (event) {
            animationController.reverse();
          },

          child: SizedBox(
            height: 96,
            child: FilledButton(
              statesController: buttonStateController,
              onPressed: widget.onPressed,
              style: ButtonStyle(
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 48),
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: animation.value ?? BorderRadius.circular(99),
                  ),
                ),
              ),
              child: Text(widget.label, style: TextStyle(fontSize: 24)),
            ),
          ),
        );
      },
    );
  }
}

class ExpressiveFastSpatial extends Curve {
  @override
  double transform(double t) {
    // TODO: implement transform
    return super.transform(t);
  }
}
