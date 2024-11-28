abstract class SupabaseTable {
  const SupabaseTable();
  String get tableName;
}

class ProfileTable implements SupabaseTable {
  const ProfileTable();

  @override
  String get tableName => "profiles";

  String get idColumn => "id";
  String get fullNameColumn => "full_name";
  String get countryColumn => "country";
}

class WatchProvidersTable implements SupabaseTable {
  const WatchProvidersTable();

  @override
  String get tableName => "user_watch_providers";

  String get userIdColumn => "user_id";
  String get providerIdColumn => "provider_id";
  String get createdAtColumn => "created_at";
}