class ResourceCategory {
  final String id;
  final String name;
  final String icon; // maps to a Material icon name in mock UI
  final String description;

  const ResourceCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
  });
}
