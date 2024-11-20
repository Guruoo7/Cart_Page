import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const CartPage({super.key, required this.cartItems});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<Map<String, dynamic>> cartItems;

  @override
  void initState() {
    super.initState();
    cartItems = widget.cartItems;
  }

  // Function to calculate the total price based on quantities
  double calculateTotalPrice() {
    return cartItems.fold(
        0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  // Function to remove an item from the cart
  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  // Function to update the quantity of an item
  void updateQuantity(int index, int change) {
    setState(() {
      int newQuantity = cartItems[index]['quantity'] + change;
      cartItems[index]['quantity'] =
          newQuantity > 0 ? newQuantity : 1; // Ensure quantity stays at least 1
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1.0,
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Text('Your cart is empty'),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.white,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(width: 17.0),
                              // Checkbox
                              // Checkbox(
                              //   value: item['selected'] ?? true,
                              //   onChanged: (bool? value) {
                              //     setState(() {
                              //       item['selected'] = value;
                              //     });
                              //   },
                              // ),
                              // Product Image
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.asset(
                                      item['image'],
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  // if (item['discount'] != null)
                                  //   Positioned(
                                  //     top: 4.0,
                                  //     right: 4.0,
                                  //     child: Container(
                                  //       padding: const EdgeInsets.symmetric(
                                  //           horizontal: 6.0, vertical: 2.0),
                                  //       decoration: BoxDecoration(
                                  //         color: Colors.red,
                                  //         borderRadius:
                                  //             BorderRadius.circular(4.0),
                                  //       ),
                                  //       child: Text(
                                  //         '${item['discount']}% off',
                                  //         style: const TextStyle(
                                  //           color: Colors.white,
                                  //           fontSize: 12.0,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                ],
                              ),
                              const SizedBox(width: 17.0),
                              // Product Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.0,
                                      ),
                                    ),
                                    const SizedBox(height: 6.0),
                                    Text(
                                      '₹${item['price']}',
                                      style: const TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10.0),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                              Icons.remove_circle_outline),
                                          onPressed: () =>
                                              updateQuantity(index, -1),
                                        ),
                                        Text(
                                          '${item['quantity']}',
                                          style:
                                              const TextStyle(fontSize: 16.0),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                              Icons.add_circle_outline),
                                          onPressed: () =>
                                              updateQuantity(index, 1),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Delete Button
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => removeItem(index),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total:',
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'INR ₹${calculateTotalPrice().toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(21, 179, 146, 1),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 24.0),
                    ),
                    onPressed: () {
                      // Implement checkout functionality here
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Proceeding to pay...'),
                        ),
                      );
                    },
                    child: const Text(
                      'Buy Products',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
