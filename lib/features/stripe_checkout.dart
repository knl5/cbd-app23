import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  Map<String, dynamic>? paymentIntent;
  int quantity = 1;
  final TextEditingController _quantityController =
      TextEditingController(text: '1');
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListView(
              padding: EdgeInsetsGeometry.lerp(
                  const EdgeInsets.all(20), const EdgeInsets.all(0), 0.5),
              shrinkWrap: true,
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextFormField(
                  controller: _streetController,
                  decoration:
                      const InputDecoration(labelText: 'Street Address'),
                ),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(labelText: 'City'),
                ),
                TextFormField(
                  controller: _countryController,
                  decoration: const InputDecoration(labelText: 'Country'),
                ),
                TextFormField(
                  controller: _zipCodeController,
                  decoration: const InputDecoration(labelText: 'Zip Code'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    setState(() {
                      quantity = quantity > 1 ? quantity - 1 : 1;
                      _quantityController.text = quantity.toString();
                    });
                  },
                  child: const Icon(Icons.remove),
                ),
                Text(
                  quantity.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      quantity = quantity < 5 ? quantity + 1 : 5;
                      _quantityController.text = quantity.toString();
                    });
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Total Cost: ${calculateCost()}€'),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 127, 0, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
              child: const Text('Checkout'),
              onPressed: () async {
                await makePayment();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> makePayment() async {
    try {
      paymentIntent =
          await createPaymentIntent(calculateCost().toString(), 'EUR');
      //Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  style: ThemeMode.dark,
                  merchantDisplayName: 'CBD Shop Marijane'))
          .then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet();
    } catch (e, s) {
      // ignore: avoid_print
      print('exception:$e$s');
    }
  }

  displayPaymentSheet() async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        // Add purchase details to Firebase
        final clientID = user!.uid;
        const itemName = 'CBD flower';
        final quantity = _quantityController.text;
        final paymentID = paymentIntent!['id'];
        final cost = calculateCost().toString();
        final name = _usernameController.text;
        final street = _streetController.text;
        final city = _cityController.text;
        final country = _countryController.text;
        final zipCode = _zipCodeController.text;
        await FirebaseFirestore.instance.collection('purchases').add({
          'clientID': clientID,
          'paymentID': paymentID,
          'itemName': itemName,
          'quantity': quantity,
          'cost': cost,
          'name': name,
          'street': street,
          'city': city,
          'country': country,
          'zipCode': zipCode,
        });

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                    Text("Payment Successfull"),
                  ],
                ),
              ],
            ),
          ),
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("paid successfully")));
        _usernameController.clear();
        _streetController.clear();
        _cityController.clear();
        _countryController.clear();
        _zipCodeController.clear();
        _quantityController.clear();
        paymentIntent = null;
      }).onError((error, stackTrace) {
        showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            content: Text("Payment Cancelled"),
          ),
        );
      });
    } on StripeException catch (e) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          content: Text("Cancelled "),
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          content: Text("Cancelled "),
        ),
      );
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          "Authorization": 'Bearer ${dotenv.env['API_STRIPE']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      // ignore: avoid_print
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_print
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }

  calculateCost() {
    return 10 * quantity;
  }
}
