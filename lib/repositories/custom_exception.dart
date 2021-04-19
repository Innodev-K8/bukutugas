class CustomException implements Exception {
  final String? message;

  const CustomException({this.message = 'Something went wrong!'});

  @override
  String toString() {
    return "CustomException { message: $message }";
  }
}
