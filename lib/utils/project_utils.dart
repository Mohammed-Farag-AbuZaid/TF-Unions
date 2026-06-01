class ProjectUtils {
  final String imageUrl;
  final String title;
  final String description;
  final String? androidLink;
  final String? iosLink;
  final String? webLink;
  final String? desktopLink;
  ProjectUtils({
    required this.imageUrl,
    required this.title,
    required this.description,
    this.androidLink,
    this.iosLink,
    this.webLink,
    this.desktopLink,
  });
}

List<ProjectUtils> upcomingProjectUtils = [
  ProjectUtils(
    imageUrl: 'assets/projects/stem.png',
    title: 'STEM Union',
    description:
        'This is a sub organization project that focuses on STEM education .',
    webLink: 'https://www.example.com/project1',
  ),

  ProjectUtils(
    imageUrl: 'assets/projects/shop.png',
    title: 'STEM Shop',
    description: 'this will be a shop for stem students',
    webLink: 'https://www.example.com/project2',
  ),
  ProjectUtils(
    imageUrl: 'assets/projects/journal.png',
    title: 'UV Journal',
    description:
        'this will be writing platform to help ace thier academic writing',
    webLink: 'https://www.example.com/project2',
  ),
  ProjectUtils(
    imageUrl: 'assets/projects/cap.png',
    title: 'UNI Cap',
    description: 'This will guide STEM students to make thier capstone',
    webLink: 'https://www.example.com/project2',
  ),
  ProjectUtils(
    imageUrl: 'assets/projects/apc.png',
    title: 'APC English',
    description:
        'This will be a cross patform app to help students ace thier english',
    webLink: 'https://www.example.com/project2',
  ),
];
