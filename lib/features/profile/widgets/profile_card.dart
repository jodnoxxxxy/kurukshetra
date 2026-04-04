import 'package:flutter/material.dart';
import 'package:kurukshetra/core/theme/app_text_styles.dart';
import 'package:kurukshetra/features/profile/models/farmer_profile.dart';

class ProfileCard extends StatelessWidget {
  final FarmerProfile profile;
  final VoidCallback onEdit;

  const ProfileCard({
    super.key,
    required this.profile,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF1B5E20), Color(0xFF138808)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF138808).withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned(
              right: -50,
              top: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white12,
                          child: profile.profilePhoto.isEmpty
                              ? const Icon(Icons.person_rounded, size: 40, color: Colors.white)
                              : ClipOval(child: Image.network(profile.profilePhoto, fit: BoxFit.cover)),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.name,
                              style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 22),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Farmer ID: ${profile.farmerId}',
                              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70, fontSize: 12),
                            ),
                            const SizedBox(height: 10),
                            if (profile.isVerified)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.white24),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.verified_rounded, size: 10, color: Colors.white),
                                    const SizedBox(width: 4),
                                    Text(
                                      'VERIFIED',
                                      style: AppTextStyles.badgeText.copyWith(color: Colors.white, fontSize: 9),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit_note_rounded, color: Colors.white, size: 24),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black.withValues(alpha: 0.1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('Area', '${profile.farmArea.toInt()} Ac'),
                        _buildDivider(),
                        _buildStatItem('Score', '${profile.organicScore.toInt()}%'),
                        _buildDivider(),
                        _buildStatItem('Years', '${DateTime.now().difference(profile.memberSince).inDays ~/ 365}Y'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() => Container(width: 1, height: 24, color: Colors.white12);

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.h3.copyWith(color: Colors.white, fontSize: 18)),
        const SizedBox(height: 4),
        Text(
          label.toUpperCase(),
          style: AppTextStyles.labelCaps.copyWith(color: Colors.white60, fontSize: 9),
        ),
      ],
    );
  }
}
