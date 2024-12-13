import 'package:batee5/1_features/authentication_feature/1_presentation/pages/sign_in/sign_in_screen.dart';

import 'package:batee5/1_features/change_location/change_location.dart';
import 'package:batee5/1_features/home_screen/home_screen.dart';
import 'package:batee5/1_features/search_screen/search_screen.dart';
import 'package:batee5/1_features/wrapper/wrapper.dart';
import 'package:batee5/1_features/products/presentation/screens/product_listing_screen.dart';
import 'package:batee5/1_features/products/presentation/screens/product_details_screen.dart';
import 'package:batee5/1_features/products/presentation/screens/add_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:batee5/1_features/products/data/models/product_model.dart';

bool signedIn = false;

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        // return MaterialPageRoute(builder: (_) => SignInScreen());
        return MaterialPageRoute(
          builder:
              (_) => signedIn ? Wrapper(pages: [HomeScreen()]) : SignInScreen(),
        );

      case '/location':
        return MaterialPageRoute(builder: (_) => ChangeLocation());
      case '/search':
        return MaterialPageRoute(builder: (_) => SearchScreen());
      case '/products':
        return MaterialPageRoute(
          builder: (_) => const ProductListingScreen(),
        );
      case '/product-details':
        final product = settings.arguments as Product;
        return MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(product: product),
        );
      case '/add-product':
        return MaterialPageRoute(
          builder: (_) => const AddProductScreen(),
        );
      default:
        return null;
    }
  }
}
