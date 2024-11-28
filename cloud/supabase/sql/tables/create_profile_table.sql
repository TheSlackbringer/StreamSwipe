create table public.profiles (
  id uuid not null references auth.users on delete cascade,
  full_name text,
  country text,
  created_at created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
  primary key (id)
);

alter table public.profiles enable row level security;

CREATE POLICY select_own_profile
ON profiles
FOR SELECT
TO authenticated
USING ( (SELECT auth.uid()) = id );

CREATE POLICY insert_own_profile
ON profiles
FOR INSERT
TO authenticated
WITH CHECK ( (SELECT auth.uid()) = id );

CREATE POLICY update_own_profile
ON profiles
FOR UPDATE
TO authenticated
USING ( (SELECT auth.uid()) = id )
WITH CHECK ( (SELECT auth.uid()) = id );

CREATE POLICY delete_own_profile
ON profiles
FOR DELETE
TO authenticated
USING ( (SELECT auth.uid()) = id );



