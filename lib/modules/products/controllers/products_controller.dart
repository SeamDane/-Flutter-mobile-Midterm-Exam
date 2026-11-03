import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/utils/app_snack.dart';
import '../../../data/models/product.dart';
import '../../../data/repositories/product_repository.dart';

class ProductsController extends GetxController {
  ProductsController(this._repo);
  final ProductRepository _repo;

  static const _pageSize = 20;

  final products = <Product>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final error = RxnString();
  final query = ''.obs;
  final scroll = ScrollController();

  int _total = 0;
  bool get hasMore => products.length < _total;

  @override
  void onInit() {
    super.onInit();
    scroll.addListener(_onScroll);
    debounce(query, (_) => load(), time: const Duration(milliseconds: 500));
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    error.value = null;
    try {
      final page = await _repo.getProducts(limit: _pageSize, skip: 0, query: query.value);
      products.assignAll(page.items);
      _total = page.total;
    } on ApiException catch (e) {
      error.value = e.message;
      if (products.isNotEmpty) AppSnack.error(e.message);
    } catch (_) {
      error.value = 'Unable to load products.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoading.value || isLoadingMore.value || !hasMore) return;
    isLoadingMore.value = true;
    try {
      final page = await _repo.getProducts(
          limit: _pageSize, skip: products.length, query: query.value);
      products.addAll(page.items);
      _total = page.total;
    } on ApiException catch (e) {
      AppSnack.error(e.message);
    } finally {
      isLoadingMore.value = false;
    }
  }

  void _onScroll() {
    if (scroll.hasClients && scroll.position.pixels >= scroll.position.maxScrollExtent - 240) {
      loadMore();
    }
  }

  @override
  void onClose() {
    scroll.dispose();
    super.onClose();
  }
}
