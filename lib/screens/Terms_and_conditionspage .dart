import 'package:car_maintenance/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Text(
                l10n.termsAndConditionsTitle,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Text(
                l10n.termsAndConditionsIntro,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.serviceDescriptionTitle,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.serviceDescription,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.userResponsibilityTitle,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.userResponsibility,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.maintenanceNotificationsTitle,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.maintenanceNotifications,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.illegalUseTitle,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.illegalUse,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
