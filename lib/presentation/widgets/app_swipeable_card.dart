import 'package:flutter/material.dart';

/// Defines an action to be shown when swiping the card.
class SwipeAction {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const SwipeAction({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });
}

/// A generic swipeable card that reveals actions on swipe and supports full swipe to delete.
class AppSwipeableCard extends StatefulWidget {
  final Widget child;
  final List<SwipeAction> actions;
  final VoidCallback? onDelete;
  final double actionWidth;
  final double dismissThreshold;
  final EdgeInsetsGeometry? margin;

  const AppSwipeableCard({
    super.key,
    required this.child,
    required this.actions,
    this.onDelete,
    this.actionWidth = 70.0,
    this.dismissThreshold = 0.7,
    this.margin,
  });

  @override
  State<AppSwipeableCard> createState() => _AppSwipeableCardState();
}

class _AppSwipeableCardState extends State<AppSwipeableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _maxDragExtent = 0.0;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      upperBound: double.infinity, // Allow unlimited over-drag for flexibility
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _maxDragExtent = widget.actions.length * widget.actionWidth;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_isDismissing || _maxDragExtent == 0) return;

    // Normalize delta: pixel delta / max extent
    final delta = details.primaryDelta! / _maxDragExtent;

    setState(() {
      // Dragging left (negative dx) increases value
      _controller.value -= delta;

      // Calculate max allowed value based on screen width to allow full swipe
      final screenWidth = MediaQuery.of(context).size.width;
      // Allow dragging up to full screen width (plus a bit for safety)
      final maxVal = (screenWidth / _maxDragExtent) + 1.0;

      // Clamp between 0.0 (closed) and maxVal
      _controller.value = _controller.value.clamp(0.0, maxVal);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_isDismissing || _maxDragExtent == 0) return;

    // Thresholds based on normalized value (0.0 to 1.0 is the action area)
    // 1.0 represents fully open actions.

    // Calculate dismiss threshold in normalized terms
    // dismissThreshold (e.g. 0.7 of screen width) needs to be converted to normalized value relative to _maxDragExtent
    final screenWidth = MediaQuery.of(context).size.width;
    final dismissThresholdPx = screenWidth * widget.dismissThreshold;
    final dismissThresholdNormalized = dismissThresholdPx / _maxDragExtent;

    if (widget.onDelete != null &&
        _controller.value > dismissThresholdNormalized) {
      // Full swipe to delete
      setState(() {
        _isDismissing = true;
      });
      // Animate to a value that pushes it off screen
      // Target pixel offset = screenWidth
      // Target normalized value = screenWidth / _maxDragExtent
      final targetValue = screenWidth / _maxDragExtent;

      _controller
          .animateTo(
        targetValue,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      )
          .then((_) {
        if (mounted && widget.onDelete != null) {
          widget.onDelete!();
        }
      });
    } else if (_controller.value > 0.5) {
      // Snap to open (1.0)
      _controller.animateTo(1.0, curve: Curves.easeOut);
    } else {
      // Snap to closed (0.0)
      _controller.animateTo(0.0, curve: Curves.easeOut);
    }
  }

  void _close() {
    _controller.animateTo(0.0, curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    Widget actionContent = Container(
      color: Colors.grey[200],
      margin: widget.margin,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widget.actions.map((action) {
          return Expanded(
            child: InkWell(
              onTap: () {
                action.onTap();
                _close();
              },
              child: Container(
                color: action.color,
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(action.icon, color: Colors.white),
                      const SizedBox(height: 4),
                      Text(
                        action.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );

    return Stack(
      children: [
        // Background Actions
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: (_controller.value * _maxDragExtent)
                  .clamp(0.0, MediaQuery.of(context).size.width),
              child: child!,
            );
          },
          child: actionContent,
        ),
        // Foreground Content
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              // Convert normalized value back to pixels
              offset: Offset(-_controller.value * _maxDragExtent, 0),
              child: child,
            );
          },
          child: GestureDetector(
            onHorizontalDragUpdate: _handleDragUpdate,
            onHorizontalDragEnd: _handleDragEnd,
            child: widget.child,
          ),
        ),
      ],
    );
  }
}
