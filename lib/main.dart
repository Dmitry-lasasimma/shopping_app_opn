import 'package:flutter/material.dart';

void main() {
  runApp(ShoppingApp());
}

class ShoppingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping App',
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
                            ),
                          ),
                        );
                      },
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

  PaymentPage({required this.productName, required this.productPrice});

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
          // Top product details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Product: ${widget.productName}\nPrice: \$${widget.productPrice}',
              style: TextStyle(fontSize: 18),
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
                    'assets/images/promptpay.png', // Replace with your PromptPay asset
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
                // _buildPaymentOptionCard(
                //   title: 'Pay with Points',
                //   subtitle: '84,600',
                //   icon: Icon(Icons.flash_on, color: Colors.orange, size: 40),
                //   isSelected: selectedPaymentMethod == 'points',
                //   onTap: () {
                //     setState(() {
                //       selectedPaymentMethod = 'points';
                //     });
                //   },
                // ),
                _buildPaymentOptionCard(
                  title: 'Credit card / Debit',
                  subtitle: 'No Fees',
                  icon: Image.asset(
                    'assets/icons/group_cradit_cardpng.png', // Replace with your Credit card asset
                    width: 40,
                    height: 40,
                  ),
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
                            paymentMethod: selectedPaymentMethod!,
                          ),
                        ),
                      );
                    },
              child: Text('Proceed to Pay'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ),
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
          // "Add Card" button in the top-right corner
          TextButton(
            onPressed: () {
              // Add your card adding logic here
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
            // Placeholder image
            Image.asset(
              'assets/images/no_data.png', // Replace with your asset
              width: 150,
              height: 150,
            ),
            SizedBox(height: 16),
            // Placeholder text
            Text(
              'ขณะนี้คุณยังไม่มีข้อมูล...',
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
      appBar: AppBar(title: Text('Add Card')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Cardholder Name',
                hintText: 'Enter Cardholder Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: cardNumberController,
              decoration: InputDecoration(
                labelText: 'Card Number',
                hintText: 'Enter Card Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            Row(
              children: [
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
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Save card details logic
                  Navigator.pop(context);
                },
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReceiptPage extends StatelessWidget {
  final String productName;
  final double productPrice;
  final String paymentMethod;

  ReceiptPage({
    required this.productName,
    required this.productPrice,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment Receipt')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 72),
            SizedBox(height: 16),
            Text('Payment Successful!', style: TextStyle(fontSize: 24)),
            SizedBox(height: 16),
            Text('Product: $productName'),
            Text('Price: \$${productPrice.toStringAsFixed(2)}'),
            Text('Payment Method: $paymentMethod'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
