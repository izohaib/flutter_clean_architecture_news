class ApiConstants {
  static const String BASE_URL = 'https://newsapi.org/v2/everything';
  static const String Api_Key = 'apiKey=2e2bc6ad03ec445a90213cc74f82918d';

  static String HeadlineUrl(String county) {
    return '$BASE_URL?q=$county&$Api_Key';
  }
}
