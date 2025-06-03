${{ content_synopsis }} Run Home Assistant rootless and without s6.

${{ content_uvp }} Good question! All the other images on the market that do exactly the same don’t do or offer these options:

${{ github:> [!IMPORTANT] }}
${{ github:> }}* This image runs as 1000:1000 by default, most other images run everything as root
${{ github:> }}* This image does not ship with any critical rated CVE and is automatically maintained via CI/CD, most other images mostly have no CVE scanning or code quality tools in place
${{ github:> }}* This image is created via a secure, pinned CI/CD process and immune to upstream attacks, most other images have upstream dependencies that can be exploited
${{ github:> }}* This image contains a patch to run rootless (Linux caps needed), most other images require higher caps
${{ github:> }}* This image contains a proper health check that verifies the app is actually working, most other images have either no health check or only check if a port is open or ping works
${{ github:> }}* This image works as read-only, most other images need to write files to the image filesystem

If you value security, simplicity and the ability to interact with the maintainer and developer of an image. Using my images is a great start in that direction.

${{ title_volumes }}
* **${{ json_root }}/etc** - Directory of all config and custom files

${{ content_compose }}

${{ content_defaults }}

${{ content_environment }}

${{ content_source }}

${{ content_parent }}

${{ content_built }}

${{ content_tips }}

${{ title_caution }}
${{ github:> [!CAUTION] }}
${{ github:> }}* This image comes with a default configuration with some default settings and examples. Please provide your own configuration if used in production.