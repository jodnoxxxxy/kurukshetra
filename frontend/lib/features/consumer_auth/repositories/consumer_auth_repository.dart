import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/consumer_model.dart';

abstract class ConsumerAuthRepository {
  Future<ConsumerModel> registerConsumer(ConsumerModel consumer, String password);
  Future<ConsumerModel> loginWithPhone(String emailOrPhone, String password);
}

class ConsumerAuthRepositoryImpl implements ConsumerAuthRepository {
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<ConsumerModel> registerConsumer(ConsumerModel consumer, String password) async {
    final phoneQuery = await _firestore.collection('consumers').where('phone', isEqualTo: consumer.phone).get();
    if (phoneQuery.docs.isNotEmpty) {
      throw Exception('Phone number already registered.');
    }
    final emailQuery = await _firestore.collection('consumers').where('email', isEqualTo: consumer.email).get();
    if (emailQuery.docs.isNotEmpty) {
      throw Exception('Email already registered.');
    }

    final docRef = _firestore.collection('consumers').doc();
    final newConsumer = ConsumerModel(
      id: docRef.id,
      fullName: consumer.fullName,
      phone: consumer.phone,
      email: consumer.email,
      address: consumer.address,
      city: consumer.city,
      pincode: consumer.pincode,
    );

    final data = newConsumer.toJson();
    data['password'] = password; // manual auth storing

    await docRef.set(data);
    return newConsumer;
  }

  @override
  Future<ConsumerModel> loginWithPhone(String emailOrPhone, String password) async {
    if (emailOrPhone == 'demo' && password == 'demo') {
      return ConsumerModel(
        id: 'cons_demo',
        fullName: 'Demo Consumer',
        phone: '0000000000',
        email: 'demo@demo.com',
        address: 'Demo Address',
        city: 'Demo City',
        pincode: '000000',
      );
    }

    var query = await _firestore.collection('consumers')
        .where('email', isEqualTo: emailOrPhone)
        .where('password', isEqualTo: password)
        .get();

    if (query.docs.isEmpty) {
      query = await _firestore.collection('consumers')
          .where('phone', isEqualTo: emailOrPhone)
          .where('password', isEqualTo: password)
          .get();
    }

    if (query.docs.isEmpty) {
      throw Exception('Invalid credentials. Please check your inputs.');
    }

    return ConsumerModel.fromJson(query.docs.first.data());
  }
}
