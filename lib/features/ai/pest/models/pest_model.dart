class PestSolution {
  final String methodName;
  final String description;
  final bool isOrganic;

  PestSolution({
    required this.methodName,
    required this.description,
    this.isOrganic = true, // Priority on organic
  });
}

class PestInfo {
  final String id;
  final String name;
  final String category; // Leaf, Stem, Root, Fungal, Viral
  final String imageUrl;
  final String symptoms;
  final String cause;
  final String prevention;
  final List<String> affectedCrops;
  final List<PestSolution> solutions;

  PestInfo({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.symptoms,
    required this.cause,
    required this.prevention,
    required this.affectedCrops,
    required this.solutions,
  });
}

class DetectionResult {
  final PestInfo pest;
  final double confidenceScore;
  final String affectedCrop;
  final String imagePath; // Path of the newly analyzed image

  DetectionResult({
    required this.pest,
    required this.confidenceScore,
    required this.affectedCrop,
    required this.imagePath,
  });
}
