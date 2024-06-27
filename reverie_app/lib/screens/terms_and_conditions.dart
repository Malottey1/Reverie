import 'package:flutter/material.dart';
import 'vendor_signup_screen.dart';  // Make sure to create this file for vendor sign up
import 'home_screen.dart';  // Ensure this file exists for the home screen

class TermsConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDDBD3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDDDBD3),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Terms of Service',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reverie - Vendor Terms and Conditions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Color(0xFF69734E),
                ),
              ),
              SizedBox(height: 10),
              Text(
                '''Welcome to Reverie!

These Terms and Conditions ("Terms") govern your access to and use of the Reverie mobile application ("App") as a vendor selling clothing items ("Products"). By registering as a vendor on Reverie, you agree to be bound by these Terms.

1. Registration and Fees

1.1. To become a vendor on Reverie, you must:
* Be at least 18 years old and have the legal capacity to enter into contracts.
* Provide accurate and complete registration information, including your legal name, business name (if applicable), contact details, and payment information.
* Comply with all applicable laws and regulations related to the sale of secondhand clothing in your jurisdiction.

1.2. Reverie may charge vendors fees associated with selling on the platform, including listing fees, transaction commissions, and payment processing fees. The current fee structure is available on the App or a dedicated vendor portal. Reverie reserves the right to modify fees upon reasonable notice.

2. Product Listings

2.1. You are solely responsible for the creation, accuracy, and completeness of your product listings. Each listing should include:

* Clear and high-quality photos of the product from various angles.
* A detailed description of the product, including its brand, size, material, condition, and any significant flaws.
* An accurate price for the product.
2.2. You agree to only list clothing items that are in good condition, free of any major defects or undisclosed damage.

2.3. Prohibited Listings: You may not list any items that are:

* Counterfeit, stolen, or infringing on intellectual property rights.
* Dangerous or harmful.
* Sexually suggestive or obscene.
* Not clothing-related.
* In violation of any applicable laws or regulations.
2.4. Reverie reserves the right to remove any listing that violates these Terms or that we deem inappropriate for the platform.

3. Shipping and Fulfillment

3.1. You are responsible for safely packaging and shipping your products to buyers within the timeframe specified in your listing.

3.2. You are responsible for all shipping costs unless otherwise agreed with the buyer.

3.3. You must provide buyers with tracking information upon shipment.

3.4. You are responsible for handling customer inquiries related to order status, shipping, and returns.

3.5. Reverie may offer additional shipping and fulfillment services for a fee.  These will be outlined separately.

4. Content Ownership

4.1. You retain ownership of all intellectual property rights associated with your product descriptions and photos.

4.2. By listing your products on Reverie, you grant Reverie a non-exclusive, worldwide, royalty-free license to use your product descriptions and photos for the purpose of displaying and promoting your listings on the App.

5. Vendor Performance

5.1. You agree to maintain a high standard of customer service by responding promptly to buyer inquiries and resolving any issues efficiently.

5.2. Reverie may monitor vendor performance based on factors such as order fulfillment times, shipping delays, customer ratings, and return rates.

5.3. Reverie may take disciplinary action against vendors for violations of these Terms, including listing removals, account suspension, or termination.

6. Payment and Payouts

6.1. Buyer payments are processed through Reverie's secure payment gateway.

6.2. After a successful purchase, you will receive the sale proceeds minus applicable fees after a predetermined period (which may be subject to change).

6.3. You are responsible for any taxes associated with your sales on Reverie.

7. Disclaimers and Limitations of Liability

7.1. Reverie acts as a platform to connect buyers and sellers. We do not guarantee the quality, safety, or authenticity of any products listed on the App.

7.2. Reverie is not liable for any disputes or transactions between buyers and vendors.

7.3. You agree to indemnify and hold harmless Reverie from any claims, liabilities, or losses arising from your use of the App or your sales on the platform.

8. Term and Termination

8.1. These Terms are effective upon your registration as a vendor on Reverie and will remain in effect until terminated by you or Reverie.

8.2. You may terminate your account at any time.

8.3. Reverie may terminate your account or suspend your access to the App for any reason, including violation of these Terms.

9. Governing Law and Dispute Resolution

9.1. These Terms will be governed by and construed in accordance with the laws of Ghana.

9.2. Any dispute arising out of or relating to these Terms will be subject to the exclusive jurisdiction of the courts located in Ghana

10. Updates to Terms and Conditions

Reverie reserves the right to update these Terms at any time. We will notify you of any changes by posting the updated Terms on the App or sending you an email. Your continued use of the App after the effective date of the revisions constitutes your acceptance of the updated Terms.

11. Entire Agreement

These Terms constitute the entire agreement between you and Reverie regarding your use of the App as a vendor.

12. Severability

If any provision of these Terms is held to be invalid or unenforceable, such provision shall be struck and the remaining provisions shall remain in full force and effect.

13. Waiver

No waiver by Reverie of any breach of these Terms shall be deemed a waiver of any subsequent breach.

Contact Us

If you have any questions about these Terms, please contact us at reveriethrift@gmail.com.

By registering as a vendor on Reverie, you acknowledge that you have read, understood, and agree to be bound by these Terms and Conditions.

Last Updated: 11th July 2024

Please note: This is a sample template and may not be suitable for all situations. You should consult with a lawyer to ensure that your Terms and Conditions are tailored to your specific business needs and comply with all applicable laws and regulations.
                ''',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF69734E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => VendorSignupScreen()),
                      );
                    },
                    child: Text(
                      'I Agree',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  Color.fromARGB(255, 113, 120, 91),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    child: Text(
                      'I Do Not Agree',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}