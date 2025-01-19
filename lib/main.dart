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
          'https://images.pexels.com/photos/90946/pexels-photo-90946.jpeg?cs=srgb&dl=pexels-madebymath-90946.jpg&fm=jpg'
    },
    {
      'name': 'Product 2',
      'price': 200.0,
      'image':
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZHVjdHxlbnwwfHwwfHx8MA%3D%3D'
    },
    {
      'name': 'Product 3',
      'price': 300.0,
      'image':
          'https://img.freepik.com/fotos-premium/renderizacao-3d-de-oculos-vr-isolados-no-branco_461160-6753.jpg'
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
          Center(
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
          SizedBox(height: 30)
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
            Center(
              child: Column(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 72),
                  SizedBox(height: 16),
                  Text(
                    'Payment Successful!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            Text('Order Summary', style: TextStyle(fontSize: 18)),
            Divider(),
            ListTile(
              title: Text('Product'),
              trailing: Text(productName),
            ),
            ListTile(
              title: Text('Price'),
              trailing: Text('\$${productPrice.toStringAsFixed(2)}'),
            ),
            ListTile(
              title: Text('Payment Method'),
              trailing: Text(paymentMethod),
            ),
            Divider(),
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
