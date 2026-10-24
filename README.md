# Loftia Community Wiki Skin Development

Our goal is to create a skin for the Loftia Community Wiki that is visually
appealing, user-friendly, and functional. This document outlines the key
components and considerations for developing the skin, and instructions on how
to setup a development environment for the skin.

## Setup Development Environment

Before getting started with the skin development, you need to set up your
development environment. First, ensure you can install any prerequisites and
have a GitHub account for collaboration.

### Prerequisites

 - An instance of MediaWiki installed and running. See later on recommended
   installation methods.
 - A code editor of your choice (e.g., Visual Studio Code, Sublime Text).
 - Basic knowledge of HTML, CSS, and JavaScript. MediaWiki uses Mustache templates
   for rendering pages; similar to HTML.

### Recommended Installation Methods

There are a few ways to install a MediaWiki instance. See [MediaWiki's
installation guide][1] for detailed instructions. We recommend using Docker
Compose. For a quick setup, use the [MediaWikiInstance][2] repository, which
provides a Docker Compose setup for MediaWiki and necessary data files. The
repository also includes a submodule for the Loftia Community Wiki skin.

### Setup Skin Repository

If you are using the [MediaWikiInstance][2] repository, you can skip this as the
folder `skins/Loftia` is already included and linked to the upstream git
repository. Although you may need to run `git submodule update --init` to
ensure the submodule is cloned.

If you are setting up the skin manually, you will need to clone the
[LoftiaMediaWikiSkin][3] repository into the `skins/Loftia` directory of your
MediaWiki instance. You can do this by running the following command in your
MediaWiki instance directory (typically `/var/www/html` or similar):

```bash
git clone https://github.com/PrestonHager/LoftiaMediaWikiSkin.git skins/Loftia
```

### Quick Preview with Docker

The `dev/` folder has a throwaway MediaWiki 1.45 (SQLite) with this skin
mounted read-only and a sample Main Page. With Docker running, from the repo
root:

```bash
docker compose -f dev/docker-compose.yml up -d
```

Then open <http://localhost:8080>. Edits to the skin show up on reload; if a
style change doesn't appear, hard-refresh (Ctrl+Shift+R) or add `?debug=1` to
the URL. The admin account is `Admin` with the password in
`dev/docker-compose.yml` (local preview only). To reset the wiki, run
`docker compose -f dev/docker-compose.yml down -v`.

[1]: https://www.mediawiki.org/wiki/Manual:Installing_MediaWiki
[2]: https://github.com/PrestonHager/MediaWikiInstance
[3]: https://github.com/PrestonHager/LoftiaMediaWikiSkin


## Skin Overview

Enable the skin in `LocalSettings.php` with `wfLoadSkin( 'Loftia' );`. It needs
MediaWiki 1.43 or newer.

 - **Light and dark themes.** Light ("parchment") is warm cream with plum
   headings and blue links; dark ("chronicle night") is deep plum with
   gold accents. By default the wiki follows the reader's device setting; the
   sun/moon button in the header cycles device, light and dark, and remembers
   the choice in a cookie.
 - **Colours** are CSS custom properties in `resources/tokens.less`. Change a
   colour there once and both themes, core message boxes and forms follow.
 - **Hero art.** Set `--loftia-hero-image` on `:root` (e.g. in
   `MediaWiki:Common.css`) to put artwork behind the header:
   `:root { --loftia-hero-image: url( /path/to/hero.jpg ); }`
 - **No web fonts.** Headings use the system's rounded font where one exists,
   so pages never wait on a font download.

### Classes for Wiki Templates

These classes are styled by the skin so templates stay consistent:

| Class | Use |
| --- | --- |
| `loftia-notice` | Gold-edged notice box. Put an optional icon in `<span class="loftia-notice__icon">`. |
| `loftia-notice loftia-notice--spoiler` | Spoiler warning. Wrap the text in `<div class="loftia-notice__body">`. |
| `loftia-infobox` (or `infobox`) | Right-floated info card for items, NPCs and places. Use a table caption as the title. |
| `loftia-cards` / `loftia-card` | Grid of tiles, e.g. for the main page. |
| `loftia-button` | Wrap a link to make it a terracotta button. |

See `dev/sample-main-page.wiki` for examples of each.

## Naming Branches

If you have setup your Development Enviroment you can make a branch of the main-branch to start working on your tasks.
For naming branches the following rules apply: 


1. We use "-" as separators
2. Start with your name as author.
3. Add the id/number of the task you work on. This is optional. If you don't have an id, write the comand without it.
4. Add the categorie. we have the folloring categories:
    - hotfix ->	for quickly fixing critical issues,
    - usually -> with a temporary solution
    - bugfix ->	for fixing a bug
    - feature	-> for adding, removing or modifying a feature
    - test	-> for experimenting something which is not an issue
    - wip	-> for a work in progress
    - id -> optional, the id/number of the task you work on

5. Add a short descriptive name of the branch. It often describes what your work on.

The rules are described [here][4] as well.

[4]: https://tilburgsciencehub.com/topics/automation/version-control/advanced-git/naming-git-branches/

### Add a new Branch:

Switch the parts of the branchname "author-id-category-descriptiveName" with your information as defined in the rules. 

```bash
git checkout -b author-id-category-descriptiveName
```

Use the following command if you get the error that there is no origin upstream when you try to push the branch to the repository for the first time.

```bash
git push --set-upstream origin branchname
```

### Check out another branch:

Use the following command. Add instead of "branchname" the name of the branch you want to check out. 

```bash
git checkout branchname
```
