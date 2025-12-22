import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listm/core/resources/app_routes.dart';
import 'package:listm/presentation/widgets/checklist_painter.dart';
import 'package:listm/presentation/widgets/globe_painter.dart';
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
              Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      width: double.infinity,
                      child: CustomPaint(
                        painter: SuitcasePainter(),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Plan your trips',
                            style: Theme.of(context).textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Text(
                                'Create a trip by clicking the ',
                                style: TextStyle(fontSize: 16),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const Text(
                                ' button',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      width: double.infinity,
                      child: CustomPaint(
                        painter: ChecklistPainter(),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Never forget an item',
                            style: Theme.of(context).textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Keep track of your items and ensure you have everything you need for your journey.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      width: double.infinity,
                      child: CustomPaint(
                        painter: GlobePainter(),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Ready for takeoff',
                            style: Theme.of(context).textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Enjoy your trip with peace of mind knowing you are fully prepared.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
