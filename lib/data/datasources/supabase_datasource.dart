import 'dart:async';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDatasource {
  final client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getLists() async {
    try {
      final response = await client
          .from('lists')
          .select()
          .execute()
          .timeout(Duration(seconds: 10));
      if (response.error != null) {
        throw response.error!;
      }
      return (response.data as List).cast<Map<String, dynamic>>();
    } on TimeoutException catch (e) {
      throw HttpException('Request timed out: $e');
    } catch (e) {
      throw HttpException('An error occurred: $e');
    }
  }

  Future<void> addList(String name) async {
    try {
      final response = await client
          .from('lists')
          .insert({
            'name': name,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .execute()
          .timeout(Duration(seconds: 10));
      if (response.error != null) {
        throw response.error!;
      }
    } on TimeoutException catch (e) {
      throw HttpException('Request timed out: $e');
    } catch (e) {
      throw HttpException('An error occurred: $e');
    }
  }

  Future<void> updateList(String id, String name) async {
    try {
      final response = await client
          .from('lists')
          .update({
            'name': name,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id)
          .execute()
          .timeout(Duration(seconds: 10));
      if (response.error != null) {
        throw response.error!;
      }
    } on TimeoutException catch (e) {
      throw HttpException('Request timed out: $e');
    } catch (e) {
      throw HttpException('An error occurred: $e');
    }
  }

  Future<void> deleteList(String id) async {
    try {
      final response = await client
          .from('lists')
          .delete()
          .eq('id', id)
          .execute()
          .timeout(Duration(seconds: 10));
      if (response.error != null) {
        throw response.error!;
      }
    } on TimeoutException catch (e) {
      throw HttpException('Request timed out: $e');
    } catch (e) {
      throw HttpException('An error occurred: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getItems(String listId) async {
    final response = await client
        .from('items')
        .select()
        .eq('list_id', listId)
        .execute()
        .timeout(Duration(seconds: 10));
    if (response.error != null) {
      throw response.error!;
    }
    return (response.data as List).cast<Map<String, dynamic>>();
  }

  Future<void> addItem(String listId, String title, String description) async {
    final response = await client
        .from('items')
        .insert({
          'list_id': listId,
          'title': title,
          'description': description,
          'completed': false,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .execute()
        .timeout(Duration(seconds: 10));
    if (response.error != null) {
      throw response.error!;
    }
  }

  Future<void> updateItem(
      String itemId, String title, String description, bool completed) async {
    final response = await client
        .from('items')
        .update({
          'title': title,
          'description': description,
          'completed': completed,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', itemId)
        .execute()
        .timeout(Duration(seconds: 10));
    if (response.error != null) {
      throw response.error!;
    }
  }

  Future<void> deleteItem(String itemId) async {
    final response = await client
        .from('items')
        .delete()
        .eq('id', itemId)
        .execute()
        .timeout(Duration(seconds: 10));
    if (response.error != null) {
      throw response.error!;
    }
  }
}
