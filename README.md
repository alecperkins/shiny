# Shiny

[![version](https://badge.fury.io/gh/alecperkins%2Fshiny.svg)](http://badge.fury.io/gh/alecperkins%2Fshiny) [![Build Status](https://travis-ci.org/alecperkins/shiny.png?branch=master)](https://travis-ci.org/alecperkins/shiny) http://shiny.tools

*Shiny* is a method of organizing CSS rules by purpose. It provides a naming
scheme to communicate selector responsibility, and suggests a convention for
file layout. While made with preprocessors like [Sass](http://sass-lang.com)
in mind, Shiny can be used with plain, handwritten CSS. The specification
addresses selector naming, but the conventions work best when applied to the
HTML and JavaScript aspects of the project, as well.

The specification is centered around the concepts of *Components* and
*Layouts*. Components represent a minimal unit of complete functionality, eg a
button, a card, an input, or a header. Layouts are used to arrange components,
eg a story list, UI panel, or whole page. Both Components and Layouts use
*Variants* and *States* to manage related configurations. Shiny also makes a
distinction between styles for structure and styles for look-and-feel
purposes.



## Specification

The selector syntax looks like: `.LayoutName__`, `._RegionName__`,
`.ComponentName`, `._SubcomponentName`, `.-variant`, `.-variant_group--val`,
`[data-state="val"]`. Project organization is focused on separating
structural styles from look-and-feel styles, through the use of appropriately
named files.

See the full [specification](http://shiny.tools/specification/) for
details and examples of both syntax and organization.

See a [real-world example](view-source:http://marquee.by/).



## Helpers

The `shiny` package provides JavaScript and Sass helpers for working with
Shiny-style classes.

Install the package using [npm](https://www.npmjs.org/), `npm install shiny`,
then require or import as necessary: `var shiny = require('shiny');` or
`@import "shiny"`.

For details on usage, see the [helpers documentation](http://shiny.tools/helpers/).



## Source And Issues

The project source for the spec and the helpers is open source,
[unlicensed](http://unlicense.org), and is available on
[GitHub](https://github.com/alecperkins/shiny). Bugs, problems, features,
comments, joys, and concerns are all welcome in the project
[issues](https://github.com/alecperkins/shiny/issues), as are pull requests.



## Backstory

The Shiny method is similar to, and influenced by, the [SMACSS](http://smacss.com/)
and [BEM](http://csswizardry.com/2013/01/mindbemding-getting-your-head-round-bem-syntax/) 
techniques. It also draws some inspiration from [a talk](http://teamtreehouse.com/library/sass-conf/managing-complex-projects-with-design-components-john-albin-wilkins)
by John Albin Wilkins at Sass Conf 2013. However, it attempts to have a
friendlier syntax than BEM and SMACSS that also works well with client-side
JavaScript frameworks. [Marionette](http://marionettejs.com/) and [React](http://facebook.github.io/react/)
in particular have been influential.



## Authors

* [Alec Perkins](http://alecperkins.net)



## License

Unlicensed aka Public Domain. See [/LICENSE](http://shiny.tools/license/) for more information.
