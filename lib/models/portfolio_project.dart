class PortfolioProject {
  const PortfolioProject({
    required this.id,
    required this.name,
    required this.technologies,
    required this.description,
    required this.category,
    this.status,
    this.repository,
  });

  final String id;
  final String name;
  final String technologies;
  final String description;
  final String category;
  final String? status;
  final String? repository;

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'technologies': technologies,
    'description': description,
    'category': category,
    'status': status,
    'repository': repository,
  };

  factory PortfolioProject.fromJson(Map<String, dynamic> json) {
    return PortfolioProject(
      id: _requiredString(json, 'id'),
      name: _requiredString(json, 'name'),
      technologies: _requiredString(json, 'technologies'),
      description: _requiredString(json, 'description'),
      category: _requiredString(json, 'category'),
      status: json['status'] as String?,
      repository: json['repository'] as String?,
    );
  }

  static const initialProjects = [
    PortfolioProject(
      id: 'skillup',
      name: 'SkillUp',
      technologies: 'React · JavaScript',
      description: 'A React web app to organise learning resources and study tasks, built for my Frameworks Web course.',
      category: 'Course project · 2026',
      repository: 'https://github.com/maramzz/SkillUp',
    ),
    PortfolioProject(
      id: 'campusfind',
      name: 'CampusFind',
      technologies: 'React · Spring Boot · PostgreSQL · Docker Compose',
      description: 'A campus lost-and-found platform built with Spring Boot microservices.',
      category: 'Personal project',
      status: 'Work in progress',
      repository: 'https://github.com/maramzz/CampusFind',
    ),
    PortfolioProject(
      id: 'telnet-project-management',
      name: 'Project management app',
      technologies: 'Angular · TypeScript · Spring Boot · PostgreSQL',
      description: 'A project management application developed during my internship at Telnet.',
      category: 'Internship · Telnet',
    ),
  ];
}

String _requiredString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! String || value.trim().isEmpty) {
    throw FormatException('Portfolio project field "$key" is missing.');
  }
  return value;
}
