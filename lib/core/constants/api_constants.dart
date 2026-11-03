/// Change [baseUrl] (and the paths) to point at your own backend.
/// Demo backend: https://dummyjson.com  (login: emilys / emilyspass)
abstract class ApiConstants {
  static const baseUrl = 'https://dummyjson.com';

  static const login = '/auth/login';
  static const me = '/auth/me';
  static const products = '/products';
  static const productSearch = '/products/search';
  static const employees = '/users';
  static const employeeAdd = '/users/add';

  /// DummyJSON only *simulates* writes (nothing is persisted), so records
  /// created in-app are kept locally. Set to false for a real backend.
  static const simulatedBackend = true;
}
