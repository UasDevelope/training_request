import 'dart:convert';
import 'dart:developer';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import '../core/key_constants.dart';

class StripeService {
  static final StripeService _instance = StripeService._internal();
  factory StripeService() => _instance;
  StripeService._internal();

  Map<String, dynamic>? paymentIntent;

  /// Initialize Stripe with publishable key
  static Future<void> initialize() async {
    Stripe.publishableKey = publishable_key;
    await Stripe.instance.applySettings();
  }

  /// Create a payment intent with the specified amount and currency
  Future<Map<String, dynamic>?> createPaymentIntent(String amount, String currency) async {
    try {
      // Convert amount to cents (multiply by 100 and round to avoid floating point issues)
      final amountInCents = (double.parse(amount) * 100).round();
      
      log('Creating payment intent for amount: $amount, currency: $currency, amount in cents: $amountInCents');
      
      Map<String, dynamic> body = {
        'currency': currency,
        'amount': amountInCents.toString(),
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer $secret_key',
            'Content-Type': 'application/x-www-form-urlencoded'
          });

      log('Payment intent response: ${response.statusCode}');
      return jsonDecode(response.body);
    } catch (e) {
      log('Error creating payment intent: $e');
      return null;
    }
  }

  /// Initialize the payment sheet with the given parameters
  Future<bool> initializePaymentSheet({
    required String clientSecret,
    String merchantDisplayName = 'Training Request',
    String countryCode = 'US',
    String currencyCode = 'USD',
    bool testEnvironment = true,
  }) async {
    try {
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              customFlow: true,
              merchantDisplayName: merchantDisplayName,
              paymentIntentClientSecret: clientSecret,
              googlePay: PaymentSheetGooglePay(
                merchantCountryCode: countryCode,
                currencyCode: currencyCode,
                testEnv: testEnvironment,
              )));
      return true;
    } catch (e) {
      log('Error initializing payment sheet: $e');
      return false;
    }
  }

  /// Display the payment sheet and handle the payment
  Future<bool> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then(
        (value) async {
          await Stripe.instance.confirmPaymentSheetPayment();
        },
      );
      paymentIntent = null;
      return true;
    } on StripeException catch (e) {
      log('Stripe exception: $e');
      return false;
    } catch (e) {
      log('Error displaying payment sheet: $e');
      return false;
    }
  }

  /// Complete payment process - creates intent, initializes sheet, and displays it
  Future<bool> makePayment({
    required String amount,
    String currency = 'USD',
    String merchantDisplayName = 'Training Request',
    String countryCode = 'US',
    bool testEnvironment = true,
  }) async {
    try {
      // Create payment intent
      paymentIntent = await createPaymentIntent(amount, currency);
      
      if (paymentIntent == null || paymentIntent!['client_secret'] == null) {
        log('Failed to create payment intent');
        return false;
      }

      // Initialize payment sheet
      bool initialized = await initializePaymentSheet(
        clientSecret: paymentIntent!['client_secret'],
        merchantDisplayName: merchantDisplayName,
        countryCode: countryCode,
        currencyCode: currency,
        testEnvironment: testEnvironment,
      );

      if (!initialized) {
        log('Failed to initialize payment sheet');
        return false;
      }

      // Display payment sheet
      return await displayPaymentSheet();
    } catch (e) {
      log('Error in makePayment: $e');
      return false;
    }
  }

  /// Get the current payment intent
  Map<String, dynamic>? get currentPaymentIntent => paymentIntent;

  /// Clear the current payment intent
  void clearPaymentIntent() {
    paymentIntent = null;
  }
}
