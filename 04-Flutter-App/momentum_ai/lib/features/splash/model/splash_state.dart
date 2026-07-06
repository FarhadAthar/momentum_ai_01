class SplashState {
  final bool isFinished;

  const SplashState({this.isFinished = false});

  SplashState copyWith({bool? isFinished}) {
    return SplashState(isFinished: isFinished ?? this.isFinished);
  }
}
