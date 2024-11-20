import 'package:cart_page/categories/Fuji.dart';
import 'package:cart_page/categories/all.dart';
import 'package:cart_page/categories/crops.dart';
import 'package:cart_page/categories/pesticides.dart';
import 'package:flutter/material.dart';
import '../cart.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final List<Map<String, dynamic>> products = [
    {
      'name': 'Product 1',
      'price': 10,
      'image': 'assets/product1.jpg',
      'quantity': 0,
    },
    {
      'name': 'Product 2',
      'price': 20,
      'image': 'assets/product2.jpg',
      'quantity': 0,
    },
    {
      'name': 'Product 3',
      'price': 30,
      'image': 'assets/product3.jpg',
      'quantity': 0,
    },
    {
      'name': 'Product 4',
      'price': 30,
      'image': 'assets/fuji.jpg',
      'quantity': 0,
    },
    {
      'name': 'Product 5',
      'price': 30,
      'image': 'assets/pesticides.png',
      'quantity': 0,
    },
    {
      'name': 'Product 6',
      'price': 30,
      'image': 'assets/crops.jpg',
      'quantity': 0,
    },
  ];

  final List<Map<String, dynamic>> categories = [
    {'label': 'Category 1'},
    {'label': 'Category 2'},
    {'label': 'Category 3'},
  ];

  final List<Map<String, dynamic>> _cartItems = [];

  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      final existingProduct = _cartItems.firstWhere(
        (item) => item['name'] == product['name'],
        orElse: () => {},
      );

      if (existingProduct.isNotEmpty) {
        existingProduct['quantity'] += 1;
      } else {
        _cartItems.add({...product});
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product['name']} added to cart!')),
    );
  }

  void _navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(cartItems: _cartItems),
      ),
    );
  }

  void _increaseQuantity(int index) {
    setState(() {
      products[index]['quantity'] += 1;
    });
  }

  void _decreaseQuantity(int index) {
    setState(() {
      if (products[index]['quantity'] > 1) {
        products[index]['quantity'] -= 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store'),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(115, 236, 139, 1),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.shopping_cart),
        //     onPressed: _navigateToCart,
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(width: 0.5, color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              // Categories Dropdown
              // DropdownButtonHideUnderline(
              //   child: DropdownButton<String>(
              //     hint: const Text('Select a Category'),
              //     items: categories
              //         .map((category) => DropdownMenuItem<String>(
              //               value: category['label'],
              //               child: Text(category['label']),
              //             ))
              //         .toList(),
              //     onChanged: (value) {
              //       // Handle category selection here
              //     },
              //   ),
              // ),
              const SizedBox(height: 16.0),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'The Fastest Delivery',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.red,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: () {
                              _navigateToCart();
                              // Custom function to handle fast delivery
                            },
                            child: const Text('Order now'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Image.asset(
                      'assets/fast.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Categories',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                height: 400,
                child: CategoriesPage(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoriesPage extends StatelessWidget {
  final List<Map<String, String>> categories = [
    {'title': 'Fuji', 'image': 'assets/apples.png'},
    {'title': 'Pesticides', 'image': 'assets/pesticides.png'},
    {'title': 'Crops', 'image': 'assets/product1.jpg'},
    {'title': 'All', 'image': 'assets/all.jpg'},
  ];

  final Map<String, Widget> categoryPages = {
    'Fuji': FujiPage(),
    'Pesticides': PesticidesPage(),
    'Crops': CropsPage(),
    'All': AllProductsPage(),
  };

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final title = categories[index]['title']!;
        final imagePath = categories[index]['image']!;
        return GestureDetector(
          onTap: () {
            // Navigate to the respective category page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => categoryPages[title]!,
              ),
            );
          },
          child: CategoryCard(title: title, imagePath: imagePath),
        );
      },
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String imagePath;

  const CategoryCard({required this.title, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
