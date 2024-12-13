import 'package:batee5/a_core/constants/app_colors.dart';
import 'package:batee5/a_core/utils/datetime_utils.dart';
import 'package:batee5/a_core/widgets/batee5_app_bar/components/multi_color_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:batee5/1_features/products/data/models/product_model.dart';
import 'package:batee5/1_features/products/data/services/product_service.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final double size;
  final VoidCallback? onPressed;

  const ProductCard({
    Key? key,
    required this.product,
    required this.size,
    this.onPressed,
  }) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late bool isFavorite;
  final ProductService _productService = ProductService();

  @override
  void initState() {
    super.initState();
    isFavorite = widget.product.isFavorite;
  }

  Future<void> _toggleFavorite() async {
    try {
      await _productService.toggleFavorite(widget.product.id);
      setState(() {
        isFavorite = !isFavorite;
      });
    } catch (e) {
      // Handle error (show snackbar, etc.)
      debugPrint('Error toggling favorite: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        width: widget.size * .3,
        height: widget.size * .47,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          border: Border.all(
            width: widget.size * .00266,
            color: AppColors.borderGrey,
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: widget.size * .19,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: widget.product.imageUrl.startsWith("http")
                          ? NetworkImage(widget.product.imageUrl)
                          : AssetImage(widget.product.imageUrl) as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(widget.size * .02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "EGP ${widget.product.price}",
                        style: TextStyle(
                          fontSize: widget.size * .04,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        widget.product.title,
                        style: TextStyle(
                          fontSize: widget.size * .035,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        widget.product.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: widget.size * .03,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: widget.size * .02,
              right: widget.size * .02,
              child: GestureDetector(
                onTap: _toggleFavorite,
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                  size: widget.size * .06,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
