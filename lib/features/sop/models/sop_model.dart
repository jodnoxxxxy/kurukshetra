class SopCategory {
  final String name;
  final List<SopCrop> crops;

  SopCategory({required this.name, required this.crops});
}

class SopCrop {
  final String id;
  final String name;
  final String imageUrl;

  SopCrop({required this.id, required this.name, required this.imageUrl});
}

class SopData {
  final String cropName;
  final List<SopStep> steps;

  SopData({required this.cropName, required this.steps});
}

class SopStep {
  final String title;
  final String description;
  final String detailedContent;
  final String imageUrl;
  final String tips;

  SopStep({
    required this.title,
    required this.description,
    required this.detailedContent,
    required this.imageUrl,
    required this.tips,
  });
}
