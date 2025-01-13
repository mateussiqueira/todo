import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClient {
  static final SupabaseClient _instance = SupabaseClient._internal();

  factory SupabaseClient() {
    return _instance;
  }

  SupabaseClient._internal();

  final client = Supabase.instance.client;

  static SupabaseClient get instance => _instance;
}

const supabaseUrl = 'https://rndvidtcfmgsoxredvtm.supabase.co';
const String supabaseKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJuZHZpZHRjZm1nc294cmVkdnRtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzY2Mzk0NjksImV4cCI6MjA1MjIxNTQ2OX0.mRphnE1jqF_8r4YMpsxssSSo0z4-To9IcJweVIsctMs';

Future<void> initializeSupabase() async {
  final appDocDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocDir.path);
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );
}
