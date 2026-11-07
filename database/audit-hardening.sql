-- Review and apply to an existing deployment separately from the source PR.
-- No rows are changed. RLS does not govern TRUNCATE privileges.
begin;
revoke all privileges on public.players from public, anon, authenticated;
grant select on public.players to anon, authenticated;
grant insert, update on public.players to authenticated;
commit;

-- Both client roles must report false for these table-wide operations.
select rolname,
  has_table_privilege(rolname, 'public.players', 'TRUNCATE') as can_truncate,
  has_table_privilege(rolname, 'public.players', 'TRIGGER') as can_create_trigger
from pg_roles where rolname in ('anon', 'authenticated');
