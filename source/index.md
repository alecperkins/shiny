# Shiny, v{{ VERSION }}

*Shiny* is a method of writing [Sass](http://sass-lang.com), a preprocessor
language for CSS. It categorizes rules into *Components*,  *Subcomponents*, and
*Variants*. A naming scheme provides a way to communicate responsibility using
the selectors. Shiny also provides a specification for structuring Sass files
into *Modules*, though it is less strict since organization is very project-
and workflow- specific. There are also helper mixins for creating and using
*Components* that conform to the Shiny specification.


## Specification

The selector syntax looks like: `.ComponentName`,
`.ComponentName_SubcomponentName`, `.-variant`, `.-variant_group--val`,
`[data-state="val"]`, `#element_id`. Project organization is oriented around
separating structural styles from look-and-feel styles, through the use of
appropriately named files.

See the full [specification](./specification.html) for details and examples of
both.

Shiny follows [semver](http://semver.org) and is currently at v{{ VERSION }}.


## About

The Shiny method is similar to, and influenced by, the [SMACSS](http://smacss.com/)
and [BEM](http://csswizardry.com/2013/01/mindbemding-getting-your-head-round-bem-syntax/) 
techniques. It also draws some inspiration from [a talk](http://teamtreehouse.com/library/sass-conf/managing-complex-projects-with-design-components-john-albin-wilkins)
by John Albin Wilkins at Sass Conf 2013. However, it attempts to have a
friendlier syntax than BEM and SMACSS. It strives to be simpler, keeping the
number of concepts to a minimum. Also, it is specified with Sass in mind, and
takes direct advantage of the `@extend` directive for defining and using
modules.


## Source And Issues

The project source for the spec and the helpers is open source, [unlicensed](http://unlicense.org),
and is available on [GitHub](https://github.com/alecperkins/sass-shiny). Bugs,
problems, features, comments, joys, and concerns are all welcome in the
project [issues](https://github.com/alecperkins/sass-shiny/issues), as are
pull requests.
