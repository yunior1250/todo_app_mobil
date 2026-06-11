class AuthState {
  final bool isLoading;
  final bool isLoggedIn;
  final String? userName;
  final String? errorMessage;

  const AuthState({
    this.isLoading = false,
    this.isLoggedIn = false,
    this.userName,
    this.errorMessage,
  });

  const AuthState.initial()
    : isLoading = false,
      isLoggedIn = false,
      userName = null,
      errorMessage = null;

  AuthState copyWith({
    bool? isLoading,
    bool? isLoggedIn,
    String? userName,
    String? errorMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn?? this.isLoggedIn,
      userName: userName?? this.userName,
      errorMessage: errorMessage?? this.errorMessage,
    );
  }
}
