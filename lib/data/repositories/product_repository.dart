import '../../core/constants/api_constants.dart';
import '../../core/models/page_result.dart';
import '../../core/network/api_client.dart';
import '../models/product.dart';

abstract class ProductRepository {
  Future<PageResult<Product>> getProducts({int limit = 20, int skip = 0, String query = ''});
}

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this._api);
  final ApiClient _api;

  @override
  Future<PageResult<Product>> getProducts({int limit = 20, int skip = 0, String query = ''}) async {
    final hasQuery = query.trim().isNotEmpty;
    final data = await _api.get(
      hasQuery ? ApiConstants.productSearch : ApiConstants.products,
      query: {'limit': limit, 'skip': skip, if (hasQuery) 'q': query.trim()},
    ) as Map<String, dynamic>;

    final items = (data['products'] as List)
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
    return PageResult(items: items, total: (data['total'] as num?)?.toInt() ?? items.length);
  }
}
