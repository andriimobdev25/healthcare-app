import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthcare/models/sympton_model.dart';

class SymtonService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addNewSympton(
      String userId, String categoryId, SymptonModel symptonModel) async {
    try {
      final CollectionReference symptonCollection = userCollection
          .doc(userId)
          .collection("healthCategory")
          .doc(categoryId)
          .collection("symptons");

      final SymptonModel newSympton = SymptonModel(
        id: "",
        name: symptonModel.name,
      );

      final Map<String, dynamic> data = newSympton.toJson();

      final DocumentReference docRef = await symptonCollection.add(data);
      await docRef.update({'id': docRef.id});

      await docRef.collection("images1").add({
        'name':symptonModel.name,
        'medicalReportImage': symptonModel.medicalReportImage,
        'doctorNoteImage': symptonModel.doctorNoteImage,
      });

      await docRef.collection("images2").add({
        'name':symptonModel.name,
        'clinicNoteImage': symptonModel.clinicNoteImage,
        'precriptionsImage': symptonModel.precriptionsImage,
      });
    } catch (error) {
      print("error add symptons on servie: ${error}");
    }
  }

  // todo:---------------------------get All the sympto's with their category name------------------------------------------------------


   Stream<List<SymptonModel>> getSymptoms(String userId, String categoryId) {
    try {
      final CollectionReference symptonCollection = userCollection
          .doc(userId)
          .collection("healthCategory")
          .doc(categoryId)
          .collection("symptons");

      return symptonCollection.snapshots().asyncMap((snapshot) async {

        List<SymptonModel> symptoms = [];
        
        for (var doc in snapshot.docs) {
          // Get base symptom data
          Map<String, dynamic> symptomData = doc.data() as Map<String, dynamic>;
          String symptomId = doc.id;

          // Get images1 data
          var images1Snapshot = await doc.reference.collection('images1').get();
          var images1Data = images1Snapshot.docs.isNotEmpty 
              ? images1Snapshot.docs.first.data() 
              : {};

          // Get images2 data
          var images2Snapshot = await doc.reference.collection('images2').get();
          var images2Data = images2Snapshot.docs.isNotEmpty 
              ? images2Snapshot.docs.first.data() 
              : {};

          // Combine all data
          symptoms.add(SymptonModel(
            id: symptomId,
            name: symptomData['name'] ?? '',
            medicalReportImage: images1Data['medicalReportImage'] ?? '',
            doctorNoteImage: images1Data['doctorNoteImage'] ?? '',
            clinicNoteImage: images2Data['clinicNoteImage'] ?? '',
            precriptionsImage: images2Data['precriptionsImage'] ?? '',
          ));
        }
        return symptoms;
      });
    } catch (error) {
      print("Error getting symptoms: $error");
      return Stream.value([]);
    }
  }

  // Get all symptoms with their category names
  Future<Map<String, List<SymptonModel>>> getSymptomsWithCategoryName(String userId) async {
    try {
      final healthCategoryCollection = userCollection.doc(userId).collection("healthCategory");
      final QuerySnapshot categorySnapshot = await healthCategoryCollection.get();
      
      final Map<String, List<SymptonModel>> symptomMap = {};
      
      for (final doc in categorySnapshot.docs) {
        String categoryId = doc.id;
        String categoryName = doc['name'] ?? 'Unknown Category';
        
        // Get symptoms for this category
        final List<SymptonModel> symptoms = await getSymptoms(userId, categoryId).first;
        symptomMap[categoryName] = symptoms;
      }
      
      return symptomMap;
    } catch (error) {
      print("Error fetching symptoms with categories: $error");
      return {};
    }
  }
}
