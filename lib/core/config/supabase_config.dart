/// Supabase project configuration and credentials container.
class SupabaseConfig {
  SupabaseConfig._();

  /// Default Supabase Project URL (replace with your project URL or pass via --dart-define)
  static const String projectUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://xyzcompany.supabase.co',
  );

  /// Default Supabase Anon Key (replace with your project public anon key)
  static const String anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.dummy_anon_key_for_offline_fallback',
  );

  /// Whether Supabase has been configured with real production credentials.
  static bool get isConfigured =>
      projectUrl.isNotEmpty &&
      !projectUrl.contains('xyzcompany') &&
      anonKey.isNotEmpty &&
      !anonKey.contains('dummy');
}
