class Profile {
  final String nama;
  final String nim;
  final String programStudi;
  final String deskripsi;
  final String githubUrl;
  final String? fotoUrl;

  const Profile({
    required this.nama,
    required this.nim,
    required this.programStudi,
    required this.deskripsi,
    required this.githubUrl,
    this.fotoUrl,
  });
}