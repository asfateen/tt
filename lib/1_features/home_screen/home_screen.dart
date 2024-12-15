import 'package:batee5/1_features/home_screen/widgets/banner_scroller/banner.dart';
import 'package:batee5/1_features/home_screen/widgets/banner_scroller/banner_scroller.dart';
import 'package:batee5/1_features/home_screen/widgets/location_selector.dart';
import 'package:batee5/1_features/home_screen/widgets/preview_section/preview_section.dart';
import 'package:batee5/a_core/constants/app_colors.dart';
import 'package:batee5/a_core/widgets/batee5_app_bar/batee5_app_bar.dart';
import 'package:batee5/a_core/widgets/batee5_search_bar.dart';
import 'package:batee5/a_core/widgets/product_card/product_card.dart';
import 'package:batee5/a_core/widgets/svg_button.dart';
import 'package:flutter/material.dart';
import 'package:batee5/a_core/services/api_service.dart';
import 'package:batee5/a_core/models/category.dart' as models;
import 'package:batee5/a_core/models/product.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  Map<String, models.Category> categories = {};
  Map<String, Product> products = {};
  String? selectedCategory; // null means show all products
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    try {
      final cats = await _apiService.getCategories();
      
      if (mounted) {
        setState(() {
          categories = cats;
          // If no category is selected, select the first one
          if (selectedCategory == null && cats.isNotEmpty) {
            selectedCategory = cats.keys.first;
          }
        });
      }

      if (selectedCategory != null) {
        final prods = await _apiService.getProductsByCategory(selectedCategory!);
        if (mounted) {
          setState(() {
            products = prods;
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading data: $e');
      if (mounted) {
        setState(() {
          categories = {};
          products = {};
        });
      }
    }
  }

  Future<void> _toggleFavorite(String productId) async {
    if (selectedCategory == null) return;
    
    try {
      final newStatus = await _apiService.toggleFavorite(selectedCategory, productId);
      setState(() {
        products[productId]?.isFavorite = newStatus;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  double height = 0;
  double width = 0;
  String imageUrl = 'assets/images/fashion.jpg';
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Batee5AppBar(
        toolbarHeight: 100,
        title: Text(
          'Welcome back',
          style: TextStyle(
            color: AppColors.blue,
            fontSize: width * .02,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
          ),
        ),
        barHeight: 100,
        actions: [
          SvgButton(svgPath: 'assets/icons/heart.svg', onPressed: () {}),
          SizedBox(width: width * .042 > 10 ? 10 : width * .042),
          SvgButton(svgPath: 'assets/icons/notification.svg', onPressed: () {}),
          const SizedBox(width: 15),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              SizedBox(height: height * 0.02),
              Row(
                children: [
                  SizedBox(width: width * 0.045),
                  LocationSelector(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/location');
                      debugPrint('location pressed');
                    },
                  ),
                  SizedBox(width: width * 0.01),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('/search');
                    },
                    child: Batee5SearchBar(
                      enabled: false,
                      hintText: "What are you looking for?",
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.02),
              // BannerScroller(
              //   banners: [
              //     Batee5Banner(
              //       imagePath: 'assets/images/sofa.jpeg',
              //       title: 'best furniture items',
              //       subTitle: 'Cairo, Egypt',
              //     ),
              //     Batee5Banner(
              //       imagePath: 'assets/images/sofa.jpeg',
              //       title: 'best furniture items',
              //       subTitle: 'Cairo, Egypt',
              //     ),
              //     Batee5Banner(
              //       imagePath: 'assets/images/sofa.jpeg',
              //       title: 'best furniture items',
              //       subTitle: 'Cairo, Egypt',
              //     ),
              //   ],
              // ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Categories',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: width * 0.04 > 16 ? 16 : width * 0.04,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // "All" option
                        GestureDetector(
                          onTap: () => onCategorySelected(null),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: width * 0.025 > 40 ? 40 : width * 0.025,
                                  backgroundColor: AppColors.lightGrey,
                                  child: Icon(Icons.grid_view_rounded, 
                                    color: selectedCategory == null ? AppColors.blue : Colors.black,
                                  ),
                                ),
                                Text(
                                  'All',
                                  style: TextStyle(
                                    color: selectedCategory == null 
                                        ? AppColors.blue 
                                        : Colors.black,
                                    fontSize: width * 0.04 > 20 ? 20 : width * 0.04,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Regular categories
                        ...categories.values.map((category) => 
                          GestureDetector(
                            onTap: () => onCategorySelected(category.id),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: width * 0.025 > 40 ? 40 : width * 0.025,
                                    foregroundImage: category.icon.startsWith('http')
                                        ? NetworkImage(category.icon)
                                        : AssetImage(category.icon) as ImageProvider,
                                  ),
                                  Text(
                                    category.name,
                                    style: TextStyle(
                                      color: selectedCategory == category.id 
                                          ? AppColors.blue 
                                          : Colors.black,
                                      fontSize: width * 0.04 > 20 ? 20 : width * 0.04,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ).toList(),
                      ],
                    ),
                  ),
                ],
              ),
              PreviewSection(
                spacing: 35,
                crossAxisCount: 3,
                title: 'Special Items',
                fullItemCount: products.length,
                items: products.values.map((product) => Column(
                  children: [
                    ProductCard(
                      id: product.id,
                      category: product.category,
                      size: width * .35,
                      onPressed: () {
                        debugPrint('product pressed');
                      },
                      onFavoriteToggled: (bool newStatus) {
                        _toggleFavorite(product.id);
                      },
                      isFavorite: product.isFavorite,
                      imageUrl: product.imageUrl,
                      title: product.title,
                      description: product.description,
                      price: product.price,
                      location: product.location,
                      dateListed: product.dateListed,
                      area: product.area,
                      numberOfBedrooms: product.numberOfBedrooms,
                      numberOfBathrooms: product.numberOfBathrooms,
                    ),
                  ],
                )).toList(),
                mainAxisExtent: width * .47,
              ),
              SizedBox(height: height * .145),
            ],
          ),
        ),
      ),
    );
  }

  void onCategorySelected(String? categoryId) {
    setState(() {
      selectedCategory = categoryId;
    });
    _loadData();
  }
}
