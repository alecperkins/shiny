# Specification

The Shiny specification follows [*semver*](http://semver.org) and is currently
at version [![GitHub version](https://badge.fury.io/gh/alecperkins%2Fshiny.svg)](http://badge.fury.io/gh/alecperkins%2Fshiny).

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be
interpreted as described in [RFC 2119](http://tools.ietf.org/html/rfc2119).


## Summary

Selectors are named to communicate the role and responsibility of the element:

Role            | Selector
----------------|--------------------------------------------------------
*Layout*        | `.LayoutName__`
*Region*        | `._RegionName__` 
*Component*     | `.ComponentName`
*Subcomponent*  | `._SubcomponentName`
*Variant*       | `.-variant` or `.-variant_group--value`
*State*         | `[data-state="value"]` or `:disabled` (built-in)
*LAF*           | `._SubcomponentName-LAF`
Element `id`    | `#element_id`
*Free Modifier* | `name` or `group--value`

Project structure convention to communicate the responsibility of the files:

    components/
    LAF/
    layouts/
    pages/
    utilities/



## Layouts and Components

A *Layout* is an arrangement of *Components* or other *Layouts* that controls
size and position. It MAY contain one or more *Regions* used for grouping.
*Layouts* MAY contain other *Layouts*.

A *Component* is a reusable block of functionality and/or appearance. It MAY
contain a number of *Subcomponents*. *Components* MAY contain other
*Components*.

All of the above use *Variants* and *States* to manage different
configuration.

A *Free Modifier* is a reusable ruleset that does not belong to a *Layout* or
*Component*.


### Requirements

1.  *Layouts*, *Regions*, *Components*, & *Subcomponents* MUST be in
    camelcase: `LayoutName__`, `_RegionName__`, `ComponentName`,
    `_SubcomponentName`.

2.  *Layouts* MUST be suffixed with double underscores: `LayoutName__`.

3.  *Regions* MUST be prefixed with an underscore, and suffixed with double
    underscores: `_RegionName__`.

4.  *Regions* MUST be nested under their parent *Layout*:
    `.LayoutName__ ._RegionName__`.

5.  *Subcomponents* MUST be prefixed with an underscore: `_SubcomponentName`.

6.  *Subcomponents* MUST be nested under their parent *Component*:
    `.Component ._SubcomponentName`.

7.  *Variants* MUST be prefixed with a hyphen: `-variant`.

8.  *Variants* MUST be attached to their *Layout*, *Region*, *Component*,
    or *Subcomponent*: `.Component.-variant`.

9.  *Variants* SHOULD be lowercase, with underscores separating words:
    `-variant_name`.

10. *Variants* MAY have subvariants (or be “grouped”), with a value that MUST
    be separated using a double hyphen: `-variant--value`.

11. Group-type *Variants* SHOULD be exclusive, ie `-align--left` and
    `-align--right` SHOULD apply contradictory rules.

12. *States* MUST be described using `data-` attributes, unless there is a
    built-in version: `data-progress="50"` or `disabled`.

13. The *State* selector MUST include the value `"true"` if it is based
    on presence (does not have its own value): `data-loading="true"`.

14. The *State* value MUST be a string.

15. *LAF*, classes that have no semantic purpose, SHOULD be suffixed with
    an `-LAF`: `_SubcomponentWrapper-LAF`.

16. Elements SHOULD only have one *Layout*, *Region*, *Component*, or
    *Subcomponent* class name, but MAY have as many *Variants* or *States*
    as necessary.

17. *Layouts* MAY have any number of *Regions*, or none.

18. *Components* MAY have any number of *Subcomponents*, or none.

19. Element ID attributes SHOULD be snake_case, (ie lowercase, with
    underscores to delimit words): `element_id`.

20. *Free Modifiers* MUST be lowercase and MUST NOT start with a hyphen or
    underscore: `modifier`, `other_modifier`.

21. *Free Modifiers* MAY be a singular class name or a group, using the double-
    hyphen syntax: `label_laf`, `column--main`.

22. *Free Modifiers* MUST NOT use hyphens to separate words except as used in
    the group syntax.



## Structure

Rules are organized into files by *Component*, Those that are structural or
behavioral are kept separate from rules responsible for “Look-and-Feel” (LAF).
Everything is pulled together using a single manifest-type file, that is
responsible for load order.

### Requirements

1.  Files that are not linked in the page MUST be prefixed with an underscore.

2.  Common functions and mixins SHOULD go into a `_global.sass` file or a
    `_global/` folder. They MAY be organized into different files and folders
    within the `_global` folder as necessary to maintain logical organization.

3.  Configuration settings, like fontstacks, colors, icon sets, and grid sizes
    SHOULD be placed in a `_config.sass` or a `_config/` folder. They MAY be
    organized into different files and folders within the `_config` folder as
    necessary to maintain logical organization.

4.  Structural and behavioral rules for a *Component* and its *Subcomponents*
    SHOULD be placed together in one file, and SHOULD be within a folder that
    contains only that *Component* or conceptually related *Components*.

5.  The file for a *Component* SHOULD be named the same as the *Component*.

6.  Files and folders that contain only abstract *Components* (defined with
    placeholder selectors) SHOULD be prefixed with a percent sign `%`:
    `_%AbstractComponent.sass`, `_%AbstractComponentsModule/`.

7.  Look-and-Feel rules SHOULD be in a separate file, within the same folder
    as the primary *Component* rules. If present, this file MUST be suffixed
    with `LAF`: `ComponentName-LAF.sass`.

8.  Rules for specific views (pages) SHOULD be treated as a *Component*, with
    their own folder and files named as such.

9.  *Components* for specific views MAY be aggregated into a `Views` folder if
    there is a small number of rules for each of those Views.

10. Rules for site-wide styles, such as general LAF and base structure, SHOULD
    be in a *Component* named `Site`.

11. There SHOULD be one file — the *manifest* — that is not prefixed with an
    underscore, and SHOULD be named `app.sass`.

12. There MAY be other *manifests*, for more selective loading of styles.



### Discussion

* There is an appeal to having each file import the parts it needs. However,
  the global nature of Sass/CSS and the behavior of placeholder selectors
  means keeping this managable is often more trouble than it’s worth. Hacks
  like the `+exports` trick introduce their own share of complexity.

* The distinction between LAF and structural is fuzzy, and varies depending on
  circumstance. In one usage, `margin` may simply increase the whitespace
  around and element, and has no bearing on the raw functionality. In other,
  `margin` may be the primary factor in establishing a certain layout. If a
  declaration can be omitted without sacrificing functionality, it should be
  considered LAF. These commonly are colors, fonts, and often padding and
  text alignment. Even `display` could be considered LAF, but is more commonly
  a structural style. Any declaration that significantly changes the position
  of an element, its sizing, or its relationship to surrounding elements,
  should be considered structural. It’s very usecase specific and requires
  sound judgement.

* Many of the items in this section are “SHOULD” instead of “MUST”.
  Organization is very project- and workflow-specific, so it doesn’t make
  sense to have strict requirements.

