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

-- Anonymous browser clients can submit/update a public nickname score.
-- This simple no-account setup is convenient, but it is NOT cheat-proof.
drop policy if exists "Anyone can add leaderboard players" on public.players;
create policy "Anyone can add leaderboard players"
on public.players for insert to anon, authenticated
with check (true);

drop policy if exists "Anyone can update leaderboard players" on public.players;
create policy "Anyone can update leaderboard players"
on public.players for update to anon, authenticated
using (true) with check (true);

grant select, insert, update on public.players to anon, authenticated;
