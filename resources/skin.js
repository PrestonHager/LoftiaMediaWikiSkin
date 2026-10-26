/* JavaScript for the Loftia skin */

var THEME_FEATURE = 'skin-theme',
	THEME_OPTION = 'userjs-loftia-theme',
	THEME_CLASS = /(^| )skin-theme-clientpref-(os|day|night)( |$)/;

// The theme the page is set to: "os" (follow the device), "day" or "night".
function getThemeMode() {
	var match = document.documentElement.className.match( THEME_CLASS );
	return match ? match[ 2 ] : 'os';
}

// The theme actually on screen, resolving "os" through the device setting.
function getShownTheme() {
	var mode = getThemeMode();
	if ( mode !== 'os' ) {
		return mode;
	}
	return window.matchMedia && window.matchMedia( '(prefers-color-scheme: dark)' ).matches ?
		'night' : 'day';
}

function setThemeMode( mode ) {
	if ( mw.user.isAnon() ) {
		// Saved in a cookie and applied before the page draws.
		mw.user.clientPrefs.set( THEME_FEATURE, mode );
		return;
	}
	// Client preferences are for logged-out readers only, so logged-in users
	// keep their choice as a user option, which SkinLoftia reads.
	// The following classes are used here:
	// * skin-theme-clientpref-os
	// * skin-theme-clientpref-day
	// * skin-theme-clientpref-night
	document.documentElement.className = document.documentElement.className
		.replace( THEME_CLASS, '$1skin-theme-clientpref-' + mode + '$3' );
	new mw.Api().saveOption( THEME_OPTION, mode );
}

function showTheme( button, theme ) {
	// Messages that can be used here:
	// * loftia-theme-day
	// * loftia-theme-night
	var label = mw.msg( 'loftia-theme-' + theme );
	button.setAttribute( 'data-mode', theme );
	button.setAttribute( 'title', label );
	button.setAttribute( 'aria-label', label );
}

function initThemeToggle() {
	var button = document.getElementById( 'loftia-theme-toggle' );
	if ( !button ) {
		return;
	}
	showTheme( button, getShownTheme() );
	button.hidden = false;
	// Every click flips what is on screen, so it never looks like it did nothing.
	button.addEventListener( 'click', function () {
		var next = getShownTheme() === 'night' ? 'day' : 'night';
		setThemeMode( next );
		showTheme( button, next );
	} );
}

// Close an open dropdown when clicking elsewhere or pressing Escape.
function initDropdowns() {
	function closeAll( except ) {
		Array.prototype.forEach.call(
			document.querySelectorAll( '.loftia-dropdown[open]' ),
			function ( menu ) {
				if ( menu !== except ) {
					menu.removeAttribute( 'open' );
				}
			}
		);
	}
	document.addEventListener( 'click', function ( e ) {
		closeAll( e.target.closest && e.target.closest( '.loftia-dropdown' ) );
	} );
	document.addEventListener( 'keydown', function ( e ) {
		if ( e.key === 'Escape' ) {
			closeAll( null );
			document.getElementById( 'loftia-nav-toggle' ).checked = false;
		}
	} );
}

$( function () {
	initThemeToggle();
	initDropdowns();
} );
