import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/diagnosis.dart';
import '../widgets/view_image_region.dart';

/// Main screen for plant disease detection
/// Displays the image capture widget and diagnosis results
class DiseaseDetectionScreen extends StatefulWidget {
  const DiseaseDetectionScreen({Key? key}) : super(key: key);

  @override
  State<DiseaseDetectionScreen> createState() => _DiseaseDetectionScreenState();
}

class _DiseaseDetectionScreenState extends State<DiseaseDetectionScreen> {
  late Diagnosis _diagnosis;

  @override
  void initState() {
    super.initState();
    _diagnosis = Diagnosis();
  }

  @override
  void dispose() {
    _diagnosis.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Diagnosis>.value(
      value: _diagnosis,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Plant Disease Detection'),
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Information Card
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  border: Border.all(color: Colors.blue[200]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'How to use:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '1. Capture or upload a clear photo of the plant leaf\n'
                      '2. Crop the image to focus on the affected area\n'
                      '3. The AI model will detect the disease\n'
                      '4. Get instant diagnosis with confidence score',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),

              // Image capture and prediction widget
              ViewImageRegion(
                diagnosis: _diagnosis,
                onPredictionComplete: () {
                  // Optional: Trigger side effects after prediction
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Prediction complete'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Diagnosis Result Card
              Consumer<Diagnosis>(
                builder: (context, diagnosis, _) {
                  if (diagnosis.disease == null) {
                    return const SizedBox.shrink();
                  }

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Diagnosis Results:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Text(
                              'Disease: ',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Expanded(
                              child: Text(
                                diagnosis.disease ?? 'Unknown',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (diagnosis
                                .confidence != null &&
                            diagnosis.confidence!.isNotEmpty)
                          Column(
                            children: [
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Text(
                                    'Confidence: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${diagnosis.confidence}%',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: double.tryParse(
                                          diagnosis.confidence ?? '0') ??
                                      0 /
                                      100,
                                  minHeight: 8,
                                  backgroundColor: Colors.grey[300],
                                  valueColor: AlwaysStoppedAnimation(
                                    (double.tryParse(diagnosis.confidence ?? '0') ??
                                                0) >
                                            50
                                        ? Colors.red[400]
                                        : Colors.green[400],
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
