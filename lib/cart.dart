import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';


class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const CartPage({super.key, required this.cartItems});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Razorpay _razorpay;

  late List<Map<String, dynamic>> cartItems;

  @override
  void initState() {
    super.initState();
    cartItems = widget.cartItems;

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear(); // Clear the Razorpay instance
    super.dispose();
  }


  // Start the Razorpay payment process
  void _startPayment() {
    var options = {
      'key': 'rzp_test_lXgKWZiM9MKPHM', // Replace with your Razorpay test key
      'amount': (calculateTotalPrice() * 100).toInt(), // Amount in paise
      'name': 'AGventures',
      'description': 'Product Purchase',
      'prefill': {
        'contact': '9025476322', // Pre-fill contact number
        'email': 'agventure06@gmail.com', // Pre-fill email address
      },
      'theme': {'color': '#3399cc'}, // Theme color for Razorpay UI
    };

    try {
      _razorpay.open(options); // Open Razorpay checkout
    } catch (e) {
      debugPrint('Error: $e'); // Handle any errors during Razorpay setup
    }
  }

  // Handle payment success
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Successful'),
        content: Text('Payment ID: ${response.paymentId}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Handle payment error
  void _handlePaymentError(PaymentFailureResponse response) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Failed'),
        content: Text('Error: ${response.message}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  // Handle external wallet option
  void _handleExternalWallet(ExternalWalletResponse response) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('External Wallet Selected'),
        content: Text('Wallet Name: ${response.walletName}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
              child: Text(
                'Your cart is empty',
                style: TextStyle(fontSize: 18.0, color: Colors.grey),
              ),
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
                              // Product Image with Error Handling
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.asset(
                                      item['image'],
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 80,
                                          height: 80,
                                          color: Colors.grey.shade300,
                                          child: const Icon(
                                            Icons.broken_image,
                                            color: Colors.grey,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
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
                        const Text(
                          'Total:',
                          style: TextStyle(
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
                        onPressed: cartItems.isEmpty ? null : _startPayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text(
                          'Buy Products',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                ],
              ),
            ),
    );
  }
}

// Payment Gateway Placeholder Page
class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Gateway'),
      ),
      body: const Center(
        child: Text(
          'Mock Payment Gateway Integration',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}
