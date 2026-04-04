import 'package:flutter/material.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frequently Asked Questions'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildFAQSection('Getting Started', [
            {
              'question': 'How do I register on Kurukshetra?',
              'answer': 'You can register by clicking on the Sign Up button on the login screen. Fill in your details including name, phone number, and farm location.',
            },
            {
              'question': 'What documents do I need for registration?',
              'answer': 'You need your Aadhaar card, land records, and bank account details for complete registration.',
            },
            {
              'question': 'Is the app free to use?',
              'answer': 'Yes, the basic features of Kurukshetra are free. Premium features may require subscription.',
            },
          ]),
          _buildFAQSection('Crop Management', [
            {
              'question': 'How do I add a new crop?',
              'answer': 'Go to Home screen, tap on "Add Crop" button, select the crop type, enter sowing date and area, then save.',
            },
            {
              'question': 'Can I edit crop details after adding?',
              'answer': 'Yes, go to My Crops section, tap on the three dots menu, and select Edit option.',
            },
            {
              'question': 'How do I delete a crop?',
              'answer': 'In My Crops section, tap on the three dots menu next to the crop and select Delete. Confirm the deletion.',
            },
            {
              'question': 'What is crop health monitoring?',
              'answer': 'Our AI system monitors your crops based on weather, soil conditions, and provides health recommendations.',
            },
          ]),
          _buildFAQSection('Market & Sales', [
            {
              'question': 'How are market prices updated?',
              'answer': 'Market prices are updated daily from local mandis and major agricultural markets.',
            },
            {
              'question': 'Can I sell my crops through the app?',
              'answer': 'Yes, you can list your crops in the Sell Hub section and connect with verified buyers.',
            },
            {
              'question': 'How do I receive payments?',
              'answer': 'Payments are transferred to your registered bank account within 2-3 business days.',
            },
          ]),
          _buildFAQSection('Weather & Climate', [
            {
              'question': 'How accurate is the weather forecast?',
              'answer': 'Our weather data comes from reliable meteorological sources with 85-90% accuracy for 7-day forecasts.',
            },
            {
              'question': 'What are weather alerts?',
              'answer': 'We send alerts for extreme weather conditions that might affect your crops.',
            },
            {
              'question': 'Can I get weather for my specific location?',
              'answer': 'Yes, the app uses your farm location to provide hyperlocal weather information.',
            },
          ]),
          _buildFAQSection('Payments & Banking', [
            {
              'question': 'Is my payment information secure?',
              'answer': 'Yes, we use bank-level encryption to protect all your financial information.',
            },
            {
              'question': 'How do I add my bank details?',
              'answer': 'Go to Profile > Payment Details > Bank tab and enter your account information.',
            },
            {
              'question': 'Can I use UPI for payments?',
              'answer': 'Yes, we support all major UPI apps including Google Pay, PhonePe, and Paytm.',
            },
          ]),
          _buildFAQSection('Technical Support', [
            {
              'question': 'The app is not working, what should I do?',
              'answer': 'Try restarting the app, check your internet connection, or contact our support team.',
            },
            {
              'question': 'How do I report a bug?',
              'answer': 'Go to Help & Support > Report Issue and describe the problem in detail.',
            },
            {
              'question': 'Is my data backed up?',
              'answer': 'Yes, all your data is securely backed up on our servers.',
            },
          ]),
        ],
      ),
    );
  }

  Widget _buildFAQSection(String title, List<Map<String, String>> faqs) {
    return ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      children: faqs.map((faq) {
        return _buildFAQItem(faq['question']!, faq['answer']!);
      }).toList(),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            answer,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
