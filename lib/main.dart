import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Import to use jsonEncode

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
      'price': 15000.0,
      'image':
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZHVjdHxlbnwwfHwwfHx8MA%3D%3D'
    },
    {
      'name': 'Product 2',
      'price': 20000.0,
      'image':
          'https://img.freepik.com/fotos-premium/renderizacao-3d-de-oculos-vr-isolados-no-branco_461160-6753.jpg'
    },
    {
      'name': 'Product 3',
      'price': 30000.0,
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
                    subtitle: Text('Price: \฿${product['price']}'),
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
  final String productImage;

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
  final String paymentApiUrl =
      "http://192.168.110.3:9090/v1/api/payment-histories/omise-payment";
  final String bearerToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3ODhhYWM3ODMyZmQyY2VjODc1M2IyZSIsInN0YXR1cyI6Ik5PVF9SRUdJU1RFUiIsInJvbGUiOiJDVVNUT01FUiIsImZ1bGxOYW1lIjoiZGltYSBsYXMiLCJpYXQiOjE3Mzc1MjcwNzksImV4cCI6MTczNzYxMzQ3OX0.e4Wucj31WZfUCxXWHjCWgb004lkAVqLUqomO_pXmmxQ";

  Future<void> proceedToPay() async {
    if (selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a payment method!")),
      );
      return;
    }

    final Map<String, dynamic> requestBody = {
      "currency": "THB",
      "price": widget.productPrice,
    };

    try {
      final response = await http.post(
        Uri.parse(paymentApiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        // Navigate to receipt page if payment succeeds
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReceiptPage(
              productName: widget.productName,
              productPrice: widget.productPrice,
              productImage: widget.productImage,
              paymentMethod: selectedPaymentMethod!,
            ),
          ),
        );
      } else {
        // Show error message if payment fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Payment failed: ${response.body}",
            ),
          ),
        );
      }
    } catch (e) {
      // Handle connection error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Connection error: $e")),
      );
    }
  }

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
                        'Price: ฿${widget.productPrice}',
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
              onPressed: proceedToPay,
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

class AddCardPage extends StatefulWidget {
  @override
  _AddCardPageState createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final String apiUrl = "http://192.168.110.3:9090/v1/api/cards/";
  final String bearerToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3ODhhYWM3ODMyZmQyY2VjODc1M2IyZSIsInN0YXR1cyI6Ik5PVF9SRUdJU1RFUiIsInJvbGUiOiJDVVNUT01FUiIsImZ1bGxOYW1lIjoiZGltYSBsYXMiLCJpYXQiOjE3Mzc1MjcwNzksImV4cCI6MTczNzYxMzQ3OX0.e4Wucj31WZfUCxXWHjCWgb004lkAVqLUqomO_pXmmxQ";

  List<Map<String, dynamic>> cards = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCards();
  }

  // Fetch cards from the API
  Future<void> fetchCards() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $bearerToken",
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final data = responseData['data'] as List;

        setState(() {
          cards = data
              .map((card) => {
                    'id': card['id'],
                    'cardName': card['cardName'],
                    'cardLastDigit': card['cardLastDigit'],
                    'brand': card['brand'],
                    'expireMonth': card['expireMonth'],
                    'expireYear': card['expireYear'],
                    'defaultCard': card['defaultCard'],
                  })
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print("Failed to fetch cards: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching cards: $e");
    }
  }

  // Set a card as the default card
  Future<void> setDefaultCard(String cardId) async {
    final String url = "$apiUrl/default-card/$cardId";

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $bearerToken",
        },
      );

      if (response.statusCode == 200) {
        print("=======Successfully set default card");
        // Refresh the card list to show updated default card
        fetchCards();
      } else {
        print("Failed to set default card: ${response.statusCode}");
      }
    } catch (e) {
      print("Error setting default card: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Credit Card Account'),
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : cards.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/no_data.png',
                        width: 150,
                        height: 150,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'You currently have no saved cards...',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    final card = cards[index];
                    return GestureDetector(
                      onTap: () {
                        // Trigger the default card update
                        setDefaultCard(card['id']);
                      },
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: card['defaultCard']
                                ? Colors.blue
                                : Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    card['brand'] == 'Visa'
                                        ? 'assets/icons/visa.png'
                                        : 'assets/icons/Mastercard.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      card['cardName'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    card['defaultCard'] ? 'Main account' : '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: card['defaultCard']
                                          ? Colors.blue
                                          : Colors.grey,
                                    ),
                                  ),
                                  if (card['defaultCard'])
                                    Icon(Icons.radio_button_checked,
                                        color: Colors.blue),
                                ],
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Card Number',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '**** ${card['cardLastDigit']}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Expiry Date',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '${card['expireMonth']}/${card['expireYear']}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class CardFormPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryMonthController = TextEditingController();
  final TextEditingController expiryYearController = TextEditingController();
  final TextEditingController cvcController = TextEditingController();

  Future<void> addCard(BuildContext context) async {
    final String url = "http://192.168.110.3:9090/v1/api/cards/create-customer";
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization":
          "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3ODhhYWM3ODMyZmQyY2VjODc1M2IyZSIsInN0YXR1cyI6Ik5PVF9SRUdJU1RFUiIsInJvbGUiOiJDVVNUT01FUiIsImZ1bGxOYW1lIjoiZGltYSBsYXMiLCJpYXQiOjE3Mzc1MjcwNzksImV4cCI6MTczNzYxMzQ3OX0.e4Wucj31WZfUCxXWHjCWgb004lkAVqLUqomO_pXmmxQ"
    };

    final Map<String, dynamic> body = {
      "cardName": nameController.text,
      "cardNumber": cardNumberController.text,
      "cardSecurityCode": cvcController.text,
      "cardExpirationMonth": expiryMonthController.text,
      "cardExpirationYear": expiryYearController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body), // Serialize the body using jsonEncode
      );

      if (response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Success"),
            content: Text("Card added successfully!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to the previous screen
                },
                child: Text("OK"),
              ),
            ],
          ),
        );
      } else {
        // Show error message for failed request
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Error"),
            content: Text("Failed to add card: ${response.body}"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Handle connection errors
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Error"),
          content: Text("Connection error: $e"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

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
                hintText: 'Enter Cardholder Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Card Number
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

            // Expiry Date and CVC
            Row(
              children: [
                // Expiry Month
                Expanded(
                  child: TextField(
                    controller: expiryMonthController,
                    decoration: InputDecoration(
                      labelText: 'Expiry Month',
                      hintText: 'MM',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 16),

                // Expiry Year
                Expanded(
                  child: TextField(
                    controller: expiryYearController,
                    decoration: InputDecoration(
                      labelText: 'Expiry Year',
                      hintText: 'YYYY',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // CVC
            TextField(
              controller: cvcController,
              decoration: InputDecoration(
                labelText: 'CVC',
                hintText: 'Enter CVC',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 30),

            // Save Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  addCard(context);
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
