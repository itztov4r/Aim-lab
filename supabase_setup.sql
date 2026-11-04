-- AIMLAB shared leaderboard setup
-- Supabase Dashboard > SQL Editor > New query > paste this file > Run

create table if not exists public.players (
  nick text primary key check (char_length(nick) between 1 and 16),
  nick_lc text not null unique,
  best integer not null default 0 check (best >= 0),
  pic text,
  games integer not null default 0 check (games >= 0),
  hits integer not null default 0 check (hits >= 0),
  clicks integer not null default 0 check (clicks >= 0),
  rt_sum bigint not null default 0 check (rt_sum >= 0),
  updated_at timestamptz not null default now()
);

alter table public.players enable row level security;

-- Allow visitors to read the public leaderboard.
drop policy if exists "Anyone can read leaderboard" on public.players;
create policy "Anyone can read leaderboard"
on public.players for select to anon, authenticated
using (true);

-- Authenticated users own their scores; anonymous visitors can only read.
-- Legacy users have NULL user_id and are preserved as read-only.
alter table public.players
  add column if not exists user_id uuid references auth.users(id) on delete set null;
create unique index if not exists players_user_id_unique on public.players(user_id);

drop policy if exists "Anyone can add leaderboard players" on public.players;
drop policy if exists "Anyone can update leaderboard players" on public.players;
drop policy if exists "Anyone can read leaderboard" on public.players;
drop policy if exists "players_public_read" on public.players;
drop policy if exists "players_owner_insert" on public.players;
drop policy if exists "players_owner_update" on public.players;

create policy "players_public_read" on public.players
  for select to anon, authenticated using (true);
create policy "players_owner_insert" on public.players
  for insert to authenticated
  with check ((select auth.uid()) is not null and (select auth.uid()) = user_id);
create policy "players_owner_update" on public.players
  for update to authenticated
  using ((select auth.uid()) is not null and (select auth.uid()) = user_id)
  with check ((select auth.uid()) is not null and (select auth.uid()) = user_id);

revoke all privileges on public.players from public, anon, authenticated;
grant select on public.players to anon, authenticated;
grant insert, update on public.players to authenticated;

-- Database hardening applied to the live AIMLAB project (2026-11-04).
-- Keep future clean installs consistent with the live schema.
-- Guard against invalid user-submitted metrics, avatars and normalized nicks.
-- Existing rows must pass these checks before the ALTER TABLE runs.
do $$
begin
  if not exists (select 1 from pg_constraint where conrelid='public.players'::regclass and conname='players_nick_normalized_chk') then
    alter table public.players add constraint players_nick_normalized_chk check (nick_lc = lower(nick));
  end if;
  if not exists (select 1 from pg_constraint where conrelid='public.players'::regclass and conname='players_hits_not_above_clicks_chk') then
    alter table public.players add constraint players_hits_not_above_clicks_chk check (hits <= clicks);
  end if;
  if not exists (select 1 from pg_constraint where conrelid='public.players'::regclass and conname='players_avatar_safe_chk') then
    alter table public.players add constraint players_avatar_safe_chk check (
      pic is null or (
        char_length(pic) <= 250000
        and pic ~ '^data:image/jpeg;base64,[A-Za-z0-9+/=]+$'
      )
    );
  end if;
end $$;

create index if not exists players_ranking_best_idx
  on public.players (best desc, updated_at desc);

-- Owner-specific RLS protects rows; the browser still calculates scores locally.
-- Use server-side verification if you need authoritative anti-cheat rankings.

