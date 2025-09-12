
import 'dart:async';
import 'package:flutter/material.dart';

class AnimatedNetworkStatus extends StatefulWidget implements PreferredSizeWidget {
  final bool isNetworkAvailable;

  const AnimatedNetworkStatus({super.key, required this.isNetworkAvailable});

  @override
  _AnimatedNetworkStatusState createState() => _AnimatedNetworkStatusState();

  @override
  Size get preferredSize => Size.fromHeight(0.0);
}

class _AnimatedNetworkStatusState extends State<AnimatedNetworkStatus> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  // Added a Timer to auto-hide the "Back to online" message after 1 second
  Timer _hideMessageTimer = Timer(Duration(seconds: 1),(){});
  bool isFirstTimeCheckConnection = true;
  bool isVisibleMsg = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000), // Adjust duration as needed
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    // Added listener to start the hide timer when the animation completes
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _startHideTimer();
      }
    });

    // Start the animation only if it's not the first time and isNetworkAvailable is initially false
    if (!isFirstTimeCheckConnection && !widget.isNetworkAvailable) {
      _animationController.value = 1.0;
    }

    // Set isFirstTimeCheckConnection to false after the first build
    isFirstTimeCheckConnection = false;
  }

  @override
  void didUpdateWidget(covariant AnimatedNetworkStatus oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isNetworkAvailable != oldWidget.isNetworkAvailable) {
      if (widget.isNetworkAvailable) {
        // Show "Back to online" when the network becomes available
        _animationController.reverse();
        Future.delayed(const Duration(seconds: 1), () {
          isVisibleMsg = false;
        });
        print("Online Massage $isVisibleMsg");
      } else {
        // Fade out when the network becomes unavailable
        _animationController.forward();
        isVisibleMsg = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return Visibility(
          visible: isVisibleMsg,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 3),
                width: MediaQuery.of(context).size.width,
                color: widget.isNetworkAvailable ? Colors.green : Colors.orange,
                child: Center(
                  child: Text(
                    widget.isNetworkAvailable ? 'You Are Online Now' : 'No network connection',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Method to start the hide timer
  void _startHideTimer() {
    _hideMessageTimer = Timer(Duration(seconds: 1), () {
      // Hide the message after 1 second
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _hideMessageTimer.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }
}
