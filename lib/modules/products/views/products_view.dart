import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/state_views.dart';
import '../../../data/models/product.dart';
import '../controllers/products_controller.dart';

class ProductsView extends GetView<ProductsController> {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: TextField(
            onChanged: (v) => controller.query.value = v,
            decoration: const InputDecoration(
              hintText: 'Search products',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        Obx(() => controller.isLoading.value
            ? const LinearProgressIndicator(minHeight: 2)
            : const SizedBox(height: 2)),
        Expanded(
          child: Obx(() {
            final items = controller.products;
            if (controller.isLoading.value && items.isEmpty) return const LoadingView();
            if (controller.error.value != null && items.isEmpty) {
              return ErrorView(message: controller.error.value!, onRetry: controller.load);
            }
            if (items.isEmpty) {
              return const EmptyView(icon: Icons.search_off, message: 'No products found');
            }
            return RefreshIndicator(
              onRefresh: controller.load,
              child: ListView.separated(
                controller: controller.scroll,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: items.length + (controller.isLoadingMore.value ? 1 : 0),
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  if (i >= items.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return _ProductCard(product: items[i]);
                },
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showDetails(context),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _Thumb(url: product.thumbnail, size: 84),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    const SizedBox(height: 2),
                    Text(
                      product.brand.isEmpty ? product.category : '${product.brand} • ${product.category}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('\$${product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                                color: scheme.primary, fontWeight: FontWeight.w700, fontSize: 17)),
                        const Spacer(),
                        const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
                        Text(product.rating.toStringAsFixed(1)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: _Thumb(url: product.thumbnail, size: 160)),
              const SizedBox(height: 16),
              Text(product.title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text('\$${product.price.toStringAsFixed(2)}  •  '
                  '${product.discountPercentage.toStringAsFixed(0)}% off  •  '
                  '${product.stock} in stock'),
              const SizedBox(height: 12),
              Text(product.description, style: TextStyle(color: Colors.grey.shade700)),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.url, required this.size});
  final String url;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: size,
        height: size,
        color: const Color(0xFFF1F2F6),
        child: url.isEmpty
            ? const Icon(Icons.image_not_supported_outlined)
            : Image.network(
                url,
                fit: BoxFit.cover,
                loadingBuilder: (_, child, p) => p == null
                    ? child
                    : const Center(child: SizedBox(
                        width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined),
              ),
      ),
    );
  }
}
