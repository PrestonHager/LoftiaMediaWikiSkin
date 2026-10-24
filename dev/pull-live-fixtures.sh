#!/bin/sh
# Copies pages and uploaded files from the live Loftia wiki into dev/fixtures/
# and imports them into the local preview wiki, so the skin can be tested on
# real content.
#
# The live wiki is private and this repo is public: dev/fixtures/ is
# gitignored and must never be committed.
#
# Usage (from the repo root, with the preview running):
#   sh dev/pull-live-fixtures.sh
# Settings (environment variables):
#   SSH        ssh client to use (default: ssh)
#   WIKI_HOST  host running the live wiki container (default: ace)
#   EXCLUDE    main-namespace pages to skip (default: Alpha_NDA Admin_Discords)
#
# Everything on the live server is read-only: page text is read and files are
# dumped, nothing is written there.
set -e
cd "$( dirname "$0" )"
SSH=${SSH:-ssh}
WIKI_HOST=${WIKI_HOST:-ace}
EXCLUDE=${EXCLUDE:-Alpha_NDA Admin_Discords}
OUT=fixtures
mkdir -p "$OUT"

live() {
	"$SSH" -o BatchMode=yes "$WIKI_HOST" "sudo podman exec -i -u www-data mediawiki php /var/www/html/maintenance/run.php $*"
}

echo "Reading pages from the live wiki..."
# Main-namespace articles, plus the MediaWiki:, Template: and Help: pages they
# rely on. Pages that build tables with Lua and Wikibase are expanded on the
# live wiki first, since the preview has no Wikibase data.
EXCLUDE_PHP=$( printf "'%s'," $EXCLUDE )
# eval.php evaluates each input line on its own and reads at most 1024 bytes
# per line, so every statement below is one complete line.
{
printf '$exclude = [ %s ]\n' "$EXCLUDE_PHP"
cat <<'EOF'
$services = MediaWiki\MediaWikiServices::getInstance()
$rows = $services->getConnectionProvider()->getReplicaDatabase()->newSelectQueryBuilder()->select( [ 'page_namespace', 'page_title' ] )->from( 'page' )->where( [ 'page_namespace' => [ 0, 8, 10, 12 ], 'page_is_redirect' => 0 ] )->caller( 'pull-live-fixtures' )->fetchResultSet()
$parser = $services->getParserFactory()->create()
$options = \MediaWiki\Parser\ParserOptions::newFromAnon()
$pages = []
foreach ( $rows as $row ) { if ( $row->page_namespace == 0 && in_array( $row->page_title, $exclude, true ) ) { continue; } $title = \MediaWiki\Title\Title::makeTitle( $row->page_namespace, $row->page_title ); $rev = $services->getRevisionLookup()->getRevisionByTitle( $title ); $content = $rev ? $rev->getContent( 'main' ) : null; if ( !$content instanceof \MediaWiki\Content\TextContent ) { continue; } $text = $content->getText(); if ( $row->page_namespace == 0 && strpos( $text, '#invoke' ) !== false ) { $text = $parser->preprocess( $text, $title, $options ); } $pages[ $title->getPrefixedText() ] = $text; }
echo json_encode( $pages )
EOF
} | live eval > "$OUT/pages.json"

echo "Dumping uploaded files from the live wiki..."
live dumpBackup --current --uploads --include-files --filter=namespace:6 --quiet > "$OUT/files.xml"

echo "Importing into the local preview..."
docker compose -f docker-compose.yml exec -T -u www-data mediawiki sh /var/www/html/skins/Loftia/dev/import-fixtures.sh
echo "Done. Open http://localhost:8080"
