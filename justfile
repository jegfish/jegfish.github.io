default:
  just --list

copy-coderpie:
  cp -r ~/jgf/coderpie/Algorithms/public/* _site/coderpie/.

copy-personal:
  mkdir -p _site/featherwiki-plugins
  cp ~/jgf/featherwiki/featherwiki-plugins/* _site/featherwiki-plugins/.
  cp -r ~/jgf/featherwiki/index.html _site/index.html
