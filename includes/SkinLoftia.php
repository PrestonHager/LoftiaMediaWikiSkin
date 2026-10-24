<?php

namespace MediaWiki\Skins\Loftia;

use MediaWiki\Output\OutputPage;
use SkinMustache;

/**
 * Loftia skin. A thin SkinMustache subclass whose only job is to opt the page
 * into MediaWiki's client preferences, so readers can switch between the light
 * and dark themes without logging in.
 */
class SkinLoftia extends SkinMustache {

	/**
	 * @param OutputPage $out
	 */
	public function initPage( OutputPage $out ) {
		parent::initPage( $out );
		// mw.user.clientPrefs only updates classes that already exist on <html>,
		// so start every page on "follow the device" and let skin.js change it.
		$out->addHtmlClasses( 'skin-theme-clientpref-os' );
	}
}
