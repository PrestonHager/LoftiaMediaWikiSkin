#!/bin/sh
# Installs a SQLite MediaWiki on first start, enables the Loftia skin and
# loads a sample page, then runs Apache. Settings live in the mw-data volume.
set -e
cd /var/www/html

if [ ! -f /var/www/data/LocalSettings.php ]; then
	php maintenance/run.php install \
		--dbtype=sqlite --dbpath=/var/www/data \
		--server=http://localhost:8080 --scriptpath="" \
		--lang=en --pass="$MW_ADMIN_PASS" \
		"Loftia Community Wiki" Admin
	cat >> LocalSettings.php <<'EOF'

# --- Loftia skin preview ---
wfLoadSkin( 'Loftia' );
$wgDefaultSkin = 'loftia';
$wgLogos = [
	'1x' => "$wgResourceBasePath/resources/assets/change-your-logo.svg",
	'icon' => "$wgResourceBasePath/resources/assets/change-your-logo.svg",
];
$wgSitename = 'Loftia Community Wiki';
$wgShowExceptionDetails = true;
$wgEnableUploads = true;
// Bundled extensions that pages copied from the live wiki use.
wfLoadExtensions( [ 'Cite', 'CategoryTree', 'Echo', 'ImageMap', 'InputBox', 'ParserFunctions', 'Poem', 'TemplateData' ] );
EOF
	php maintenance/run.php update --quick --conf LocalSettings.php > /dev/null
	mv LocalSettings.php /var/www/data/LocalSettings.php
	chown -R www-data:www-data /var/www/data
fi

cp /var/www/data/LocalSettings.php LocalSettings.php
if [ ! -f /var/www/data/.sample-loaded ]; then
	# Also kept as "Skin sample", since importing live pages replaces Main Page.
	php maintenance/run.php edit --summary 'Loftia skin sample' 'Main Page' < /opt/loftia/sample-main-page.wiki
	php maintenance/run.php edit --summary 'Loftia skin sample' 'Skin sample' < /opt/loftia/sample-main-page.wiki
	chown -R www-data:www-data /var/www/data
	touch /var/www/data/.sample-loaded
fi
exec apache2-foreground
