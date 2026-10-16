import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/profile.dart';

class ProfileCard extends StatelessWidget {
  final Profile profile;

  const ProfileCard({super.key, required this.profile});

  Future<void> _openGithub() async {
    final uri = Uri.parse(profile.githubUrl);
    if (!await launchUrl(uri, mode: LaunchMode.platformDefault)) {
      throw Exception('Tidak dapat membuka ${profile.githubUrl}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor:
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
              backgroundImage: profile.fotoUrl != null
                  ? NetworkImage(profile.fotoUrl!)
                  : null,
              child: profile.fotoUrl == null
                  ? Icon(
                Icons.person,
                size: 56,
                color: Theme.of(context).colorScheme.primary,
              )
                  : null,
            ),
            const SizedBox(height: 16),
            Text(profile.nama, style: textTheme.titleLarge),
            const SizedBox(height: 4),
            Text('NIM: ${profile.nim}', style: textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text(profile.programStudi, style: textTheme.titleMedium),
            const SizedBox(height: 16),
            Text(
              profile.deskripsi,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _openGithub,
                icon: const Icon(Icons.code),
                label: const Text('Kunjungi GitHub Saya'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}