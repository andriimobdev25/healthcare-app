import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:healthcare/models/sympton_model.dart';
import 'package:healthcare/services/category/image_saver_service.dart';
import 'package:healthcare/widgets/single_category/category_botton_sheet.dart';

class SingleSymptonPage extends StatefulWidget {
  final SymptonModel sympton;

  const SingleSymptonPage({
    Key? key,
    required this.sympton,
  }) : super(key: key);

  @override
  State<SingleSymptonPage> createState() => _SingleSymptonPageState();
}

class _SingleSymptonPageState extends State<SingleSymptonPage> {
  bool _downloading = false;

  Future<void> _downloadBase64Image(
      String base64String, String fileName) async {
    if (base64String.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image available')),
      );
      return;
    }

    setState(() => _downloading = true);
    try {
      final bytes = base64Decode(base64String);
      await ImageService.saveBytes(bytes, fileName);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save image: $e')),
      );
    } finally {
      setState(() => _downloading = false);
    }
  }

  Widget _buildImageCard({
    required String title,
    required String imageUrl,
    required String downloadName,
    required String type,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          if (imageUrl.isNotEmpty)
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Image.memory(
                base64Decode(imageUrl),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.error_outline, size: 40, color: Colors.red),
                ),
              ),
            )
          else
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[200],
              child: const Center(child: Text('No image available')),
            ),
          ButtonBar(
            alignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.remove_red_eye),
                label: const Text('View'),
                onPressed: imageUrl.isNotEmpty
                    ? () => _viewImage(context, title, imageUrl)
                    : null,
              ),
              TextButton.icon(
                icon: const Icon(Icons.download),
                label: const Text('Download'),
                onPressed: imageUrl.isNotEmpty && !_downloading
                    ? () => _downloadBase64Image(imageUrl, downloadName)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _viewImage(BuildContext context, String title, String base64Image) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(title)),
          body: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Center(
              child: Image.memory(base64Decode(base64Image)),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Symptom Details'),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return CategoryBottonSheet(
                    deleteCallback: () {
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Delete"),
                            content:
                                Text("Are you sure you want to delete this"),
                            actions: [
                              TextButton(
                                onPressed: () {},
                                child: Text("Ok"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Cancel"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    editCallback: () {},
                    title1: "Delete Sympton Report's",
                    title2: "Edit Sympton Report's",
                  );
                },
              );
            },
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.sympton.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                ],
              ),
            ),
            if (_downloading)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 8),
                      Text('Downloading image...'),
                    ],
                  ),
                ),
              ),
            _buildImageCard(
              title: 'Medical Report',
              imageUrl: widget.sympton.medicalReportImage ?? '',
              downloadName: 'medical_report_${widget.sympton.name}',
              type: 'medical',
            ),
            _buildImageCard(
              title: 'Doctor\'s Note',
              imageUrl: widget.sympton.doctorNoteImage ?? '',
              downloadName: 'doctor_note_${widget.sympton.name}',
              type: 'doctor',
            ),
            _buildImageCard(
              title: 'Clinic Note',
              imageUrl: widget.sympton.clinicNoteImage ?? '',
              downloadName: 'clinic_note_${widget.sympton.name}',
              type: 'clinic',
            ),
            _buildImageCard(
              title: 'Prescriptions',
              imageUrl: widget.sympton.precriptionsImage ?? '',
              downloadName: 'prescription_${widget.sympton.name}',
              type: 'prescription',
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
