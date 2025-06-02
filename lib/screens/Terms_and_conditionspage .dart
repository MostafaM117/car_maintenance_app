import 'package:car_maintenance/constants/app_colors.dart';
import 'package:flutter/material.dart';

import '../generated/l10n.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Text(
              s.termsTitle,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Text(
              s.termsIntro,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            _buildSection(s.section1Title, s.section1Body),
            _buildSection(s.section2Title, s.section2Body),
            _buildSection(s.section3Title, s.section3Body),
            _buildSection(s.section4Title, s.section4Body),
            _buildSection(s.section5Title, s.section5Body),
            _buildSection(s.section6Title, s.section6Body),
            _buildSection(s.section7Title, s.section7Body),
            _buildSection(s.section8Title, s.section8Body),
            _buildSection(s.section9Title, s.section9Body),
            _buildSection(s.section10Title, s.section10Body),
            _buildSection(s.section11Title, s.section11Body),
            _buildSection(s.section12Title, s.section12Body),
            const SizedBox(height: 24),
            Text(
              s.contactUs,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              s.contactUsBody,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(body, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
