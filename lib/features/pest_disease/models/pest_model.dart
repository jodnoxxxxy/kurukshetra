class PestCrop {
  final String id;
  final String name;
  final String category; // Cereals, Pulses, Oilseeds
  final String imageUrl;

  PestCrop({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
  });
}

class OrganicUpay {
  final String title;
  final String description;

  OrganicUpay({
    required this.title,
    required this.description,
  });
}

class PestDisease {
  final String id;
  final String name;
  final String imageUrl;
  final String shortDescription;
  final String symptoms;
  final String cause;
  final String affectedStage;
  final List<OrganicUpay> solutions;
  final List<String> preventionTips;

  PestDisease({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.shortDescription,
    required this.symptoms,
    required this.cause,
    required this.affectedStage,
    required this.solutions,
    required this.preventionTips,
  });
}
