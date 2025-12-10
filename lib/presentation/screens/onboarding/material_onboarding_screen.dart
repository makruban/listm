import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listm/core/resources/app_routes.dart';
import 'package:listm/presentation/widgets/checklist_painter.dart';
import 'package:listm/presentation/widgets/plane_painter.dart';
import 'package:listm/presentation/widgets/suitcase_painter.dart';

class MaterialOnboardingScreen extends StatefulWidget {
  const MaterialOnboardingScreen({super.key});

  @override
  State<MaterialOnboardingScreen> createState() =>
      _MaterialOnboardingScreenState();
}

class _MaterialOnboardingScreenState extends State<MaterialOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onSkip() {
    context.go(AppRoutes.home);
  }

  void _onNext() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              CustomPaint(
                painter: SuitcasePainter(),
                child: Container(),
              ),
              CustomPaint(
                painter: ChecklistPainter(),
                child: Container(),
              ),
              CustomPaint(
                painter: PlanePainter(),
                child: Container(),
              ),
            ],
          ),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _onSkip,
                  child: const Text('Skip'),
                ),
                Row(
                  children: List.generate(3, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                    );
                  }),
                ),
                TextButton(
                  onPressed: _onNext,
                  child: Text(_currentPage == 2 ? 'Done' : 'Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
