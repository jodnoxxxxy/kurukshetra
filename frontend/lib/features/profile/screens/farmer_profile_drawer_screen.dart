import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:kurukshetra/features/profile/providers/profile_provider.dart';
import 'package:kurukshetra/l10n/app_localizations.dart';

class FarmerProfileDrawerScreen extends ConsumerWidget {
  const FarmerProfileDrawerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final profileState = ref.watch(profileProvider);
    final profile = profileState.profile;

    if (profile == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF9FBF9),
        appBar: AppBar(
          title: Text(l10n.farmerProfile),
          backgroundColor: AppColors.primaryGreen,
          elevation: 0,
        ),
        body: const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 0,
            floating: true,
            pinned: true,
            title: Text(
              l10n.farmerProfile.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1.5, color: Colors.black87),
            ),
            backgroundColor: const Color(0xFFF9FBF9),
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildProfileHeader(context, profile),
                  const SizedBox(height: 24),
                  _buildStatsSection(context, profile),
                  const SizedBox(height: 24),
                  _buildContactSection(context, profile),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, dynamic profile) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  backgroundImage: profile.profilePhoto.startsWith('http') ? NetworkImage(profile.profilePhoto) : null,
                  child: !profile.profilePhoto.startsWith('http') ? const Icon(Icons.person, size: 60, color: Color(0xFF2E7D32)) : null,
                ),
              ),
              if (profile.isVerified)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.verified, color: Colors.blue, size: 20),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            profile.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            profile.location,
            style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.8), fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildHeaderStat(l10n.farmAreaLabel.split(' ')[0], '${profile.farmArea.toStringAsFixed(0)} Ac'),
              _buildHeaderStat('Organic', '${profile.organicScore.toStringAsFixed(0)}%'),
              _buildHeaderStat('Since', _getMemberSince(profile.memberSince)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label.toUpperCase(), style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context, dynamic profile) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.detailedStatistics.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 1)),
          const SizedBox(height: 20),
          _buildStatRow(Icons.map_outlined, l10n.primaryLocation, profile.location),
          _buildStatRow(Icons.square_foot_outlined, l10n.totalLandArea, '${profile.farmArea} Acres'),
          _buildStatRow(Icons.receipt_long_outlined, l10n.landRecords, '${profile.landRecords.length} Items'),
          _buildStatRow(Icons.history_outlined, l10n.cropHistory, '${profile.cropHistory.length} Crops'),
        ],
      ),
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primaryGreen.withValues(alpha: 0.6)),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context, dynamic profile) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.contactInformation.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 1)),
          const SizedBox(height: 20),
          _buildContactTile(Icons.phone_iphone_rounded, l10n.phoneNumber, profile.phone),
          _buildContactTile(Icons.alternate_email_rounded, l10n.email, profile.email),
          _buildContactTile(Icons.translate_rounded, l10n.preferredLanguage, profile.preferredLanguage),
        ],
      ),
    );
  }

  Widget _buildContactTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 18, color: AppColors.primaryGreen),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600)),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
            ],
          ),
        ],
      ),
    );
  }

  String _getMemberSince(DateTime date) {
    final difference = DateTime.now().difference(date).inDays;
    if (difference >= 365) return '${(difference / 365).floor()}Y';
    if (difference >= 30) return '${(difference / 30).floor()}M';
    return '${difference}D';
  }
}
