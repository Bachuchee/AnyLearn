class Topic {
  Topic(this.name, this.description, this.id, [this.isValid = false]);

  final String name;
  final String description;
  final String id;
  bool isValid;
}
