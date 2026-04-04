class ApiResponse<T> {
  final T? data;
  final String? error;
  final bool isLoading;

  ApiResponse({this.data, this.error, this.isLoading = false});

  factory ApiResponse.loading() {
    return ApiResponse(isLoading: true);
  }

  factory ApiResponse.success(T data) {
    return ApiResponse(data: data);
  }

  factory ApiResponse.error(String error) {
    return ApiResponse(error: error);
  }

  bool get hasData => data != null;
  bool get hasError => error != null;
}
