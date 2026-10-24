#!/bin/sh
# Runs inside the preview container: imports dev/fixtures/ (see
# pull-live-fixtures.sh) into the local wiki.
set -e
cd /var/www/html
FIXTURES=/var/www/html/skins/Loftia/dev/fixtures
WORK=$( mktemp -d )

php maintenance/run.php importDump --uploads --no-updates "$FIXTURES/files.xml"

# Split pages.json into one file per page, then save each as a new revision so
# it replaces the preview's own copy (e.g. Main Page).
php -r '
$pages = json_decode( file_get_contents( $argv[1] ), true );
$i = 0;
foreach ( $pages as $title => $text ) {
	file_put_contents( "$argv[2]/$i.title", $title );
	file_put_contents( "$argv[2]/$i.text", $text );
	$i++;
}' "$FIXTURES/pages.json" "$WORK"
for f in "$WORK"/*.title; do
	php maintenance/run.php edit --summary 'Imported from the live wiki' \
		"$( cat "$f" )" < "${f%.title}.text" > /dev/null
done
rm -rf "$WORK"

php maintenance/run.php rebuildrecentchanges > /dev/null
php maintenance/run.php runJobs --quiet > /dev/null
echo "Import finished."
