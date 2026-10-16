import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../widgets/profile_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const profile = Profile(
      nama: 'Muhammad Naufal Fadhilah',
      nim: '20240801200',
      programStudi: 'Teknik Informatika',
      deskripsi: 'Suka main game.',
      githubUrl: 'https://github.com/naufalfadilah50',
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Personal Profile Card')),
      body: const Center(
        child: SingleChildScrollView(
          child: ProfileCard(profile: profile),
        ),
      ),
    );
  }
}