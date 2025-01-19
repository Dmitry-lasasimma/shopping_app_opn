import 'package:flutter/material.dart';

void main() {
  runApp(ShoppingApp());
}

class ShoppingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ProductListPage(),
    );
  }
}

class ProductListPage extends StatelessWidget {
  final List<Map<String, dynamic>> products = [
    {
      'name': 'Product 1',
      'price': 100.0,
      'image':
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZHVjdHxlbnwwfHwwfHx8MA%3D%3D'
    },
    {
      'name': 'Product 2',
      'price': 200.0,
      'image':
          'https://img.freepik.com/fotos-premium/renderizacao-3d-de-oculos-vr-isolados-no-branco_461160-6753.jpg'
    },
    {
      'name': 'Product 3',
      'price': 300.0,
      'image':
          'https://images.pexels.com/photos/90946/pexels-photo-90946.jpeg?cs=srgb&dl=pexels-madebymath-90946.jpg&fm=jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    product['image'],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(product['name']),
                    subtitle: Text('Price: \$${product['price']}'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentPage(
                              productName: product['name'],
                              productPrice: product['price'],
                              productImage: product['image'], // Pass image
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 241, 241, 241), // Set text color to white
                        foregroundColor:
                            const Color.fromARGB(255, 56, 159, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              30), // Optional rounded corners
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12), // Adjust padding
                      ),
                      child: Text('Buy'),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PaymentPage extends StatefulWidget {
  final String productName;
  final double productPrice;
  final String productImage; // Add product image

  PaymentPage({
    required this.productName,
    required this.productPrice,
    required this.productImage,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Payment Method')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product details with image
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Display product image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    widget.productImage,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 16),
                // Product name and price
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.productName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Price: \$${widget.productPrice}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(),

          // Payment methods UI
          Expanded(
            child: ListView(
              children: [
                _buildPaymentOptionCard(
                  title: 'พร้อมเพย์ (PromptPay)',
                  subtitle: 'No Fees',
                  icon: Image.asset(
                    'assets/images/promptpay.png', // Replace with PromptPay asset
                    width: 40,
                    height: 40,
                  ),
                  isSelected: selectedPaymentMethod == 'promptpay',
                  onTap: () {
                    setState(() {
                      selectedPaymentMethod = 'promptpay';
                    });
                  },
                ),
                _buildPaymentOptionCard(
                  title: 'Credit card / Debit',
                  subtitle: 'No Fees',
                  icon: Image.asset(
                    'assets/images/card_debit.png', // Replace with PromptPay asset
                    width: 40,
                    height: 40,
                  ),
                  // icon: Row(
                  //   mainAxisSize: MainAxisSize.min,
                  //   children: [
                  //     Image.asset(
                  //       'assets/icons/visa.png', // Replace with Visa asset
                  //       width: 40,
                  //       height: 40,
                  //     ),
                  //     SizedBox(width: 8),
                  //     Image.asset(
                  //       'assets/icons/mastercard.png', // Replace with Mastercard asset
                  //       width: 40,
                  //       height: 40,
                  //     ),
                  //   ],
                  // ),
                  isSelected: selectedPaymentMethod == 'card',
                  onTap: () {
                    setState(() {
                      selectedPaymentMethod = 'card';
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddCardPage()),
                    );
                  },
                ),
              ],
            ),
          ),

          // Proceed to pay button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: selectedPaymentMethod == null
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReceiptPage(
                            productName: widget.productName,
                            productPrice: widget.productPrice,
                            productImage: widget.productImage, // Add this line
                            paymentMethod: selectedPaymentMethod!,
                          ),
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 40, 155, 248),
                foregroundColor: Colors.white, // Set text color to white
                minimumSize:
                    Size(double.infinity, 50), // Make the button full-width
                textStyle:
                    TextStyle(fontSize: 18), // Set font size for the text
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(30), // Optional rounded corners
                ),
              ),
              child: Text('Proceed to Pay'),
            ),
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }

  // Helper method to build the payment option card
  Widget _buildPaymentOptionCard({
    required String title,
    required String subtitle,
    required Widget icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
            width: 2,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              icon,
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: Colors.blue, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class AddCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Payment Methods'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CardFormPage()),
              );
            },
            child: Text(
              '+ Add Card',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/no_data.png', // Replace with your asset
              width: 150,
              height: 150,
            ),
            SizedBox(height: 16),
            Text(
              'You currently have no information...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardFormPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvcController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Card'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cardholder Name
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Cardholder Name',
                hintText: 'Cardholder Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Card Number with Visa/Mastercard icons
            TextField(
              controller: cardNumberController,
              decoration: InputDecoration(
                labelText: 'Card Number',
                hintText: 'Card Number',
                border: OutlineInputBorder(),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/card_debit.png', // Replace with PromptPay asset
                      width: 40,
                      height: 40,
                    ),
                  ],
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),

            // Expiry Date and CVC in a Row
            Row(
              children: [
                // Expiry Date Field
                Expanded(
                  child: TextField(
                    controller: expiryDateController,
                    decoration: InputDecoration(
                      labelText: 'Expiry Date',
                      hintText: 'MM / YY',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                ),
                SizedBox(width: 16),

                // CVC Field
                Expanded(
                  child: TextField(
                    controller: cvcController,
                    decoration: InputDecoration(
                      labelText: 'CVC',
                      hintText: 'CVV / CVC',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            // Spacer(),
            SizedBox(height: 30),

            // Save Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Logic for saving the card details
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Save',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class ReceiptPage extends StatelessWidget {
//   final String productName;
//   final double productPrice;
//   final String paymentMethod;

//   ReceiptPage({
//     required this.productName,
//     required this.productPrice,
//     required this.paymentMethod,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Payment Receipt')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.check_circle, color: Colors.green, size: 72),
//             SizedBox(height: 16),
//             Text('Payment Successful!', style: TextStyle(fontSize: 24)),
//             SizedBox(height: 16),
//             Text('Product: $productName'),
//             Text('Price: \$${productPrice.toStringAsFixed(2)}'),
//             Text('Payment Method: $paymentMethod'),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.popUntil(context, (route) => route.isFirst);
//               },
//               child: Text('Back to Home'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class ReceiptPage extends StatelessWidget {
  final String productName;
  final double productPrice;
  final String productImage;
  final String paymentMethod;

  ReceiptPage({
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 50),

            // Success Icon and Title
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 80,
            ),
            SizedBox(height: 16),
            Text(
              'Your payment was successful',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'You purchased:',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 8),

            // Product Image and Name
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    productImage,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 16),
                Text(
                  productName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),

            // Receipt Card
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Slip Number and Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Slip Number',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          'Date and Time',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '9uuzn20250119090730718', // Example slip number
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        Text(
                          '19/01/2025 09:07', // Example date
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    Divider(color: Colors.grey[300]),

                    // Paid Through
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Paid Through',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        Text(
                          paymentMethod,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),

                    // Payment Amount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Payment Amount',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        Text(
                          '\$${productPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Successful Button
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Change button color to blue
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Successful',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
