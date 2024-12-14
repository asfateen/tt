import 'package:batee5/a_core/constants/app_colors.dart';
import 'package:batee5/a_core/utils/datetime_utils.dart';
import 'package:batee5/a_core/widgets/batee5_app_bar/components/multi_color_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final double size;
  final String title;
  final String description;
  final double price;
  final String location;
  final DateTime dateListed;
  final int? numberOfBedrooms;
  final int? numberOfBathrooms;
  final int? area;
  final int productId;
  final VoidCallback? onPressed;

  ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.location,
    required this.dateListed,
    this.numberOfBedrooms,
    this.numberOfBathrooms,
    this.area,
    required this.productId,
    required this.onPressed,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: size * .19,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageUrl.startsWith("http")
                          ? NetworkImage(imageUrl) as ImageProvider
                          : AssetImage(imageUrl) as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(
                  "EGP ${price}",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: size * .04,
                    color: AppColors.darkBlue,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: size * .037,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: size * .05,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(width: size * .005),
                      numberOfBedrooms != null
                          ? SvgPicture.asset(
                            width: size * .05,
                            'assets/icons/bedroom.svg',
                          )
                          : const SizedBox(),
                      SizedBox(width: size * .015),
                      numberOfBathrooms != null
                          ? SvgPicture.asset(
                            width: size * .05,
                            'assets/icons/bathroom.svg',
                          )
                          : const SizedBox(),
                      SizedBox(width: size * .015),
                      numberOfBedrooms != null
                          ? Row(
                            children: [
                              SvgPicture.asset(
                                width: size * .05,
                                'assets/icons/area.svg',
                              ),
                              SizedBox(width: size * .01),
                              Text(
                                "${area} m²",
                                style: TextStyle(
                                  color: AppColors.darkGrey2,
                                  fontSize: size * .032,
                                ),
                              ),
                            ],
                          )
                          : const SizedBox(),
                    ],
                  ),
                ),
                Text(
                  location,
                  style: TextStyle(
                    fontSize: size * .037,
                    fontWeight: FontWeight.w400,
                    color: AppColors.darkGrey,
                  ),
                ),
                Text(
                  DateTimeUtils.getFormattedDuration(
                    DateTime.now().difference(dateListed),
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: size * .037,
                    color: AppColors.darkGrey,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment(.9, -1.08),
              child: SizedBox(
                width: size * .04,
                child: OutlinedMultiColorButton(
                  fillColor: Colors.white,
                  filledIcon:
                      Icon(
                        size: size * .022,
                        Icons.favorite_rounded,
                        color: Colors.red,
                      ),
                  borderIcon: Icon(
                    size: size * .022,
                    Icons.favorite_outline_rounded,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    Provider.of<ProductProvider>(context, listen: false)
                        .toggleFavorite(productId);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
