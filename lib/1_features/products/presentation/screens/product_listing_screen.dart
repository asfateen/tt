import 'package:flutter/material.dart';
import 'package:batee5/1_features/products/data/models/product_model.dart';
import 'package:batee5/1_features/products/data/services/product_service.dart';
import 'package:batee5/a_core/widgets/product_card/product_card.dart';
import 'package:batee5/a_core/widgets/batee5_app_bar/batee5_app_bar.dart';

class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({Key? key}) : super(key: key);

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  final ProductService _productService = ProductService();
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _productService.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: Batee5AppBar(
        toolbarHeight: height * .1,
        barHeight: height * .1,
        title: const Text('Products'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _productsFuture = _productService.getProducts();
          });
        },
        child: FutureBuilder<List<Product>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${snapshot.error}'),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _productsFuture = _productService.getProducts();
                        });
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No products available'),
              );
            }

            return GridView.builder(
              padding: EdgeInsets.all(width * .032),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: width * .032,
                mainAxisSpacing: width * .032,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final product = snapshot.data![index];
                return ProductCard(
                  product: product,
                  size: width * .35,
                  onPressed: () {
                    // Navigate to product details
                    Navigator.pushNamed(
                      context,
                      '/product-details',
                      arguments: product,
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add product screen
          Navigator.pushNamed(context, '/add-product').then((_) {
            // Refresh products list when returning from add product screen
            setState(() {
              _productsFuture = _productService.getProducts();
            });
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}