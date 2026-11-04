const {test}=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),vm=require('node:vm');
const html=fs.readFileSync('index.html','utf8');
const owned=html.slice(html.indexOf('async function loadOwnedPlayer(){'),html.indexOf('async function signInPlayer('));
test('cloud ranked metrics survive local cosmetic restoration',async()=>{
 const remote={nick:'demo',best:12,games:2,hits:3,clicks:4,rt_sum:123};
 const context={authUser:{id:'a'},me:{},db:{from(){return{select(){return this},eq(){return this},maybeSingle:async()=>({data:remote,error:null})}}},restoreLocalProgress(){context.me.best=99999;context.me.games=99999;context.me.coins=50;},saveLocalNick(){},profile(){},renderChallenges(){},login(){},toast(){}};
 vm.createContext(context);vm.runInContext(owned,context);await context.loadOwnedPlayer();
 assert.equal(context.me.best,12);assert.equal(context.me.games,2);assert.equal(context.me.rtSum,123);assert.equal(context.me.coins,50);
});
test('a delayed profile from a former account is ignored',async()=>{
 let release;const context={authUser:{id:'a'},me:{nick:'new-account'},db:{from(){return{select(){return this},eq(){return this},maybeSingle:()=>new Promise(r=>release=r)}}},toast(){}};
 vm.createContext(context);vm.runInContext(owned,context);const pending=context.loadOwnedPlayer();context.authUser={id:'b'};release({data:{nick:'old-account'},error:null});await pending;assert.equal(context.me.nick,'new-account');
});
test('SQL removes table-wide privileges before granting only required operations',()=>{
 const sql=fs.readFileSync('supabase_setup.sql','utf8');
 assert.match(sql,/revoke all privileges on public\.players from public, anon, authenticated;/i);
 assert.doesNotMatch(sql,/grant\s+(?:all|truncate|trigger|delete)\b/i);
});
