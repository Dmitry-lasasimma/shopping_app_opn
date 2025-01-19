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
    {'name': 'Product 1', 'price': 100.0},
    {'name': 'Product 2', 'price': 200.0},
    {'name': 'Product 3', 'price': 300.0},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Product: ${widget.productName}\nPrice: \$${widget.productPrice}',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Pay by Card'),
            leading: Radio<String>(
              value: 'card',
              groupValue: selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Pay by PromptPay'),
            leading: Radio<String>(
              value: 'promptpay',
              groupValue: selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value;
                });
              },
            ),
          ),
          Spacer(),
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
            ),
          ),
        ],
      ),
    );
  }
}

class ReceiptPage extends StatelessWidget {
  final String productName;
  final double productPrice;
  final String paymentMethod;

  ReceiptPage(
      {required this.productName,
      required this.productPrice,
      required this.paymentMethod});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment Receipt')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Successful!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Product: $productName', style: TextStyle(fontSize: 18)),
            Text('Price: \$${productPrice.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18)),
            Text('Payment Method: $paymentMethod',
                style: TextStyle(fontSize: 18)),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Text('Back to Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
