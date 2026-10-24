/* JavaScript for the Loftia skin */

var THEME_FEATURE = 'skin-theme',
	THEME_MODES = [ 'os', 'day', 'night' ];

function getThemeMode() {
	var mode = mw.user.clientPrefs.get( THEME_FEATURE );
	return THEME_MODES.indexOf( mode ) === -1 ? 'os' : mode;
}

function showThemeMode( button, mode ) {
	// Messages that can be used here:
	// * loftia-theme-os
	// * loftia-theme-day
	// * loftia-theme-night
	var label = mw.msg( 'loftia-theme-' + mode );
	button.setAttribute( 'data-mode', mode );
	button.setAttribute( 'title', label );
	button.setAttribute( 'aria-label', label );
}

function initThemeToggle() {
	var button = document.getElementById( 'loftia-theme-toggle' );
	if ( !button || !mw.user.clientPrefs ) {
		return;
	}
	showThemeMode( button, getThemeMode() );
	button.hidden = false;
	button.addEventListener( 'click', function () {
		var current = THEME_MODES.indexOf( getThemeMode() ),
			next = THEME_MODES[ ( current + 1 ) % THEME_MODES.length ];
		mw.user.clientPrefs.set( THEME_FEATURE, next );
		showThemeMode( button, next );
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
