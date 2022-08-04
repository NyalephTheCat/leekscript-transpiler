nearleyc src/grammar/ls.ne > src/grammar/ls.js;
nearley-railroad src/grammar/ls.ne -o viz.html

node src/index.js