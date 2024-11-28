CREATE TABLE user_watch_providers (
  user_id UUID NOT NULL REFERENCES profiles (id) ON DELETE CASCADE,
  provider_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  PRIMARY KEY (user_id, provider_id)
);

ALTER TABLE user_watch_providers ENABLE ROW LEVEL SECURITY;

CREATE POLICY select_own_watch_providers
ON user_watch_providers
FOR SELECT
TO authenticated
USING  ( (select auth.uid()) = user_id );

CREATE POLICY insert_own_watch_providers
ON user_watch_providers
FOR INSERT
TO authenticated
WITH CHECK ( (select auth.uid()) = user_id );

-- UPDATE Policy
CREATE POLICY update_own_watch_providers
ON user_watch_providers
FOR UPDATE
TO authenticated
using ( (select auth.uid()) = user_id )
WITH CHECK ( (select auth.uid()) = user_id );

-- DELETE Policy
CREATE POLICY delete_own_watch_providers
ON user_watch_providers
FOR DELETE
TO authenticated
using ( (select auth.uid()) = user_id );