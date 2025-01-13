// import 'package:cloud_firestore/cloud_firestore.dart';

// class FirestoreDatasource {
//   final FirebaseFirestore firestore;

//   FirestoreDatasource(this.firestore);

//   Future<List<Map<String, dynamic>>> getLists() async {
//     final snapshot = await firestore.collection('lists').get();
//     return snapshot.docs.map((doc) {
//       return {
//         'id': doc.id,
//         ...doc.data(),
//       };
//     }).toList();
//   }

//   Future<void> addList(String name) async {
//     await firestore.collection('lists').add({
//       'name': name,
//       'created_at': FieldValue.serverTimestamp(),
//       'updated_at': FieldValue.serverTimestamp(),
//     });
//   }

//   Future<void> updateList(String id, String name) async {
//     await firestore.collection('lists').doc(id).update({
//       'name': name,
//       'updated_at': FieldValue.serverTimestamp(),
//     });
//   }

//   Future<void> deleteList(String id) async {
//     await firestore.collection('lists').doc(id).delete();
//   }

//   Future<List<Map<String, dynamic>>> getItems(String listId) async {
//     final snapshot = await firestore
//         .collection('lists')
//         .doc(listId)
//         .collection('items')
//         .get();
//     return snapshot.docs.map((doc) {
//       return {
//         'id': doc.id,
//         ...doc.data(),
//       };
//     }).toList();
//   }

//   Future<void> addItem(String listId, String title, String description) async {
//     await firestore.collection('lists').doc(listId).collection('items').add({
//       'title': title,
//       'description': description,
//       'completed': false,
//       'created_at': FieldValue.serverTimestamp(),
//       'updated_at': FieldValue.serverTimestamp(),
//     });
//   }

//   Future<void> updateItem(String listId, String itemId, bool completed) async {
//     await firestore
//         .collection('lists')
//         .doc(listId)
//         .collection('items')
//         .doc(itemId)
//         .update({
//       'completed': completed,
//       'updated_at': FieldValue.serverTimestamp(),
//     });
//   }

//   Future<void> deleteItem(String listId, String itemId) async {
//     await firestore
//         .collection('lists')
//         .doc(listId)
//         .collection('items')
//         .doc(itemId)
//         .delete();
//   }
// }
