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

[1]: https://www.mediawiki.org/wiki/Manual:Installing_MediaWiki
[2]: https://github.com/PrestonHager/MediaWikiInstance
[3]: https://github.com/PrestonHager/LoftiaMediaWikiSkin

