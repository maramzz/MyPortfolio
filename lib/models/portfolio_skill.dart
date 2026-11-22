class PortfolioSkill {
  const PortfolioSkill({
    required this.id,
    required this.name,
    required this.technologies,
  });

  final String id;
  final String name;
  final String technologies;

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'technologies': technologies,
  };

  factory PortfolioSkill.fromJson(Map<String, dynamic> json) {
    return PortfolioSkill(
      id: _requiredString(json, 'id'),
      name: _requiredString(json, 'name'),
      technologies: _requiredString(json, 'technologies'),
    );
  }

  static const initialSkills = [
    PortfolioSkill(
      id: 'programming',
      name: 'Programming',
      technologies: 'Java · C · JavaScript · TypeScript · PHP',
    ),
    PortfolioSkill(
      id: 'backend',
      name: 'Backend Development',
      technologies: 'Spring Boot · REST APIs · JPA / Hibernate',
    ),
    PortfolioSkill(
      id: 'frontend',
      name: 'Frontend Development',
      technologies: 'Angular · React · HTML · CSS',
    ),
    PortfolioSkill(
      id: 'databases',
      name: 'Databases',
      technologies: 'PostgreSQL · MySQL · Oracle · SQL',
    ),
    PortfolioSkill(
      id: 'devops',
      name: 'Tools & DevOps',
      technologies: 'Git · GitHub · Docker · Postman',
    ),
    PortfolioSkill(
      id: 'other-technologies',
      name: 'Other Technologies',
      technologies: 'Flutter · Microservices · OOP',
    ),
  ];
}

String _requiredString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! String || value.trim().isEmpty) {
    throw FormatException('Portfolio skill field "$key" is missing.');
  }
  return value;
}
