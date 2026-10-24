<?php

namespace MediaWiki\Skins\Loftia;

use MediaWiki\MediaWikiServices;
use MediaWiki\Output\OutputPage;
use SkinMustache;

/**
 * Loftia skin. A thin SkinMustache subclass that sets the starting colour
 * theme so the page renders in the reader's chosen theme without a flash.
 */
class SkinLoftia extends SkinMustache {

	/** User option holding a logged-in user's theme: "os", "day" or "night". */
	public const THEME_OPTION = 'userjs-loftia-theme';

	private const THEMES = [ 'os', 'day', 'night' ];

	/**
	 * @param OutputPage $out
	 */
	public function initPage( OutputPage $out ) {
		parent::initPage( $out );
		$out->addHtmlClasses( 'skin-theme-clientpref-' . $this->getThemeMode() );
	}

	/**
	 * Logged-out readers start on "os" and MediaWiki's client preferences
	 * cookie swaps the class before the page draws. Client preferences are
	 * not available to logged-in users, so their choice is a user option.
	 *
	 * @return string
	 */
	private function getThemeMode(): string {
		$user = $this->getUser();
		if ( !$user->isRegistered() ) {
			return 'os';
		}
		$mode = MediaWikiServices::getInstance()->getUserOptionsLookup()
			->getOption( $user, self::THEME_OPTION, 'os' );
		return in_array( $mode, self::THEMES, true ) ? $mode : 'os';
	}
}
