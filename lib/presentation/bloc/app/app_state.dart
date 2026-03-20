abstract class AppState {
  const AppState();

  List<Object?> get props => [];
}

class AppInitial extends AppState {
  const AppInitial();
}

class AppReady extends AppState {
  final bool hasSeenOnboarding;

  const AppReady({required this.hasSeenOnboarding});

  @override
  List<Object?> get props => [hasSeenOnboarding];
}
