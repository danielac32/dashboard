
class Sections {
  final List<String> sections;

  Sections({required this.sections});

  factory Sections.fromJson(Map<String, dynamic> json) {
    return Sections(
      sections: List<String>.from(json['sections'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sections': sections,
    };
  }
}