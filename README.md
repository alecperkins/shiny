# Shiny

*Shiny* is a method of writing [Sass](http://sass-lang.com), a preprocessor
language for CSS. It categorizes rules into *Modules*,  *Components*, and
*Variants*. A naming scheme provides a way to communicate responsibility using
the selectors. Shiny also provides a specification for structuring Sass files,
though it is less strict since organization is very project- and workflow-
specific. There are also helper mixins for creating and using modules that
conform to the Shiny specification.

## Specification

The selector syntax looks like: `ModuleName`, `ModuleName_ComponentName`,
`-variant`, `-variant_group--val`, `[data-state="val"]`. Project organization
is oriented around separating structural styles from look-and-feel styles,
through the use of appropriately named files.

See the full [specification](http://shinysass.org/specification.html) for
details and examples of both.
