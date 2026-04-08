class CropCategory {
  final String name;
  final List<CropInfo> crops;

  CropCategory({required this.name, required this.crops});
}

class CropInfo {
  final String id;
  final String name;
  final String imageUrl;

  CropInfo({required this.id, required this.name, required this.imageUrl});
}

class CropStage {
  final String title;
  final int startDay;
  final int endDay;
  final List<AdvisoryDetail> advisories;

  CropStage({
    required this.title,
    required this.startDay,
    required this.endDay,
    required this.advisories,
  });
}

class AdvisoryDetail {
  final String type; // e.g., 'Pest', 'Disease', 'Fertilizer', 'Irrigation'
  final String title;
  final String shortDescription;
  final String detailedContent;

  AdvisoryDetail({
    required this.type,
    required this.title,
    required this.shortDescription,
    required this.detailedContent,
  });
}
