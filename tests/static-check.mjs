import fs from 'node:fs';
import vm from 'node:vm';
import assert from 'node:assert/strict';

const html = fs.readFileSync('index.html','utf8');
const scripts = [...html.matchAll(/<script\b([^>]*)>([\s\S]*?)<\/script\s*>/gi)]
  .filter(([,attrs,body]) => !/\bsrc\s*=/.test(attrs) && body.trim())
  .map(([,attrs,body]) => body);
assert(scripts.length > 0, 'Inline game script missing');
scripts.forEach((source,i)=>new vm.Script(source,{filename:'inline-script-'+i+'.js'}));
const sql=fs.readFileSync('supabase_setup.sql','utf8');
assert(sql.includes('players_owner_update'), 'Missing owner-specific UPDATE policy');
assert(sql.includes('auth.uid()'), 'Missing authenticated ownership check');
assert(!/create policy "Anyone can update leaderboard players"/i.test(sql),'Unsafe anonymous update policy');
assert(html.includes('signInWithPassword'), 'Account sign-in missing');
assert(html.includes('user_id:authUser.id'), 'Player ownership binding missing');
assert(!html.includes('onConflict:"nick"'), 'Unsafe nickname upsert remains');
console.log('AIMLAB HTML scripts parse; secure ownership checks found.');
