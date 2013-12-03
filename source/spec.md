# Specification

The Shiny specification follows [semver](http://semver.org) and is currently
at version v{{ VERSION }}.

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be
interpreted as described in [RFC 2119](http://tools.ietf.org/html/rfc2119).


## Summary

Selectors are named to communicate the role and responsibility of the element:

* *Module*              : `ModuleName`
* *Component*           : `ModuleName_ComponentName`
* Private *Module*      : `_ModuleName`
* *Variant*             : `-variant` or `-variant_group--value`
* *State*               : `[data-state="value"]` or `:disabled` (built-in)
* *Helper*              : `H_ModuleName_ComponentName`

Project structure convention to communicate the responsibility of the files:

    styles/
        _global/
            _color.sass
            _grid.sass
            _icon.sass
            _typography.sass
        %AbstractModule/
            _%AbstractModule.sass
        Module/
            _Module.sass
            _Module-LAF.sass
            _RelatedModule.sass
            _RelatedModule-LAF.sass
        OtherModule/
            _OtherModule.sass
            _OtherModule-LAF.sass
        Site/
            _Site.sass
            _Site-LAF.sass
        Views/
            _AView.sass
            _AView-LAF.sass
            _ViewName.sass
            _ViewName-LAF.sass
        _config/
          _config.sass
          _theme.sass
        app.sass



## Modules

A *Module* is a reusable block of appearance and/or functionality. It MAY
contain a number of *Components*. It MAY have a number of *Variants* and
*States*, which are used to modify the *Module* or *Components*. *Modules* MAY
contain other *Modules*.


### Specification

1.  *Modules* MUST be in camelcase: `ModuleName`.

2.  *Components* MUST be prefixed with the *Module* they belong to, separated
    with an underscore: `ModuleName_ComponentName`.

3.  *Components* SHOULD NOT be nested under their parent *Module*, unless a
    *Module* *Variant* needs to modify the *Component*.

4.  Private *Modules* SHOULD be prefixed with an underscore: `_ModuleName`.

5.  *Components* of private *Modules* SHOULD match the module underscore
    prefix: `_ModuleName_ComponentName`.

6.  *Variants* MUST be prefixed with a hyphen: `-variant`.

7.  *Variants* MUST be nested under their *Module* or *Component*:
    `&.-variant`.

8.  *Variants* SHOULD be lowercase, with underscores separating words:
    `-variant_name`.

9.  *Variants* MAY have subvariants (or be “grouped”), with a value that MUST
    be separated using a double hyphen: `-variant--value`.

10. Properties under *Variants* with subvariants SHOULD be exclusive.

11. *States* MUST be described using `data-` attributes, unless there is a
    built-in version: `data-progress="50"` or `disabled`.

12. The *State* selector MUST include the value `"true"` if it is based
    on presence (does not have its own value): `data-loading="true"`.

13. *Helpers*, classes that have no semantic purpose, SHOULD be prefixed with
    an `H_`: `H_ModuleName_ComponentWrapper`.

14. Elements SHOULD only have one *Module* or *Component* class name, but MAY
    have as many *Variants* or *States* as necessary.

15. *Component* presence in an instance of a *Module* in markup is *OPTIONAL*,
    though dependent on the specific usecase.

16. *Modules* and *Components* SHOULD be documented using the Shiny
    [documentation style](./documentation.html).

### Discussion

* If a *Component* is reusable across different *Modules*, or outside of the
  *Module*, then it is probably itself a *Module*. The underscore between the
  `ModuleName` and `ComponentName` is intended to suggest that the *Component*
  is private to the *Module*.

* Camelcase is chosen to help differentiate the *Modules* and *Components*
  from classes for variants, or standalone classes. Also, it stands out in
  normal text without additional formatting, helpful for documentation. An
  added bonus is it follows conventions used in frontend or backend logic,
  such as a Backbone or Django View, which makes it easy to associate the
  markup, style, and script that are responsible for that module.

* *Modules* can contain other *Modules*, instead of having a separate “layout”
  concept. A list-type *Module* could be a layout as it contains *Modules* for
  the list items. But, the list itself also may have some additional
  functionality, like sorting or searching, that is provided by its own
  *Components* or other *Modules*. Variants could be used to control the
  layout of the list, like `-list` or `-grid--three` or `-grid--four`.

* The names “module” and “component” are chosen over “block” and “element”,
  since those have other meanings in this context (display: block, content
  block, HTML element). “Module” and “Component” also correlate with the same
  JavaScript concepts. “Variant” was chosen over “modifier” for no particular
  reason other than it didn’t start with an `m` as “Module” does.

* Keeping *Variants* separate from the full *Module* or *Component* name
  (compared to schemes like BEM), makes it easier to recombine them, and is
  generally less verbose. The nesting requirement and hyphen prefixing allows
  for avoiding the problem of overly generic *Variant* names, like `.active`.
  Not using the full module prefixing still allows for global adjustments to
  variants for debugging purposes, eg `.-active { border: 1px solid red }`.
  (This may be necessary in non-debugging situations, but is a bad idea so is
  considered a violation of the Shiny spec.) Also, it’s possible to detect a
  non-nested class prefixed with a hyphen using a linter, to enforce this rule.

* Singular *Variants* are considered “flags” or “switches”, and generally
  should be useful in different combinations, like
  `class="Story -featured -selected"`. *Variants* with subvariants are
  considered a property and a value, and are best used exclusively from each
  other, like `class="StoryList -grid--three"` or
  `class="StoryList -grid-four -selected"`.

* *States* versus *Variants* is potentially fuzzy. A good differentiator is if
  it is being modified by JavaScript, like “disabled”, “loading”, or
  “progress”, it’s a *State*. If it is not going to change once the page
  loads, it is a *Variant*. It’s also a good idea to keep the *State* values
  JSON-compatible, since some JavaScript libraries parse `data-` attributes as
  JSON when accessing them. (This is also why the `"true"` is required.)

* The *Helper* distinction makes it clear that the element with that class has
  no semantic role, and can be modified or removed as the look-and-feel
  dictate.
  
* More sophisticated selector prefixes, with characters like `^` and `+` are
  possible, but are easy to confuse with things like regex and sibling
  selectors.


### Example

The following example describes a `Container` *Module*, and an `Item` *Module*
with `Item_Cover`, `Item_Title`, and `Item_ContentPreview` components.

```sass
.Container
    max-width   : 1280px
    margin      : 0 auto
    &.-full
        max-width: none
    &.-spaceless
        font-size: 0
        > *
            font-size: 1rem

.Item_Cover
    background-size : cover
    height          : 200px

.Item_Title
    text-align: center

.Item_ContentPreview
    padding: 1em
    &.-truncated
        &:after
            content: '…'

.H_Item_TagWrapper
    position: relative

.Item_Tag
    position    : absolute
    bottom      : 100%
    left        : 0

.Item
    width: 100%

    &.-size--fourth
        width: 25%
        .Item_Cover
            height: 50px

    &.-size--third
        width: 33.33333%
        .Item_Cover
            height: 75px

    &.-size--half
        width: 50%
        .Item_Cover
            height: 100px

    &[data-loading="true"]
        border: 1px solid green

```

At a specific moment in time, accounting for the state being controlled by JS,
the corresponding HTML structure would look something like:

```html
<div class="Container -spaceless">
    <div class="Item">
        <div class="H_Item_TagWrapper">
            <div class="Item_Tag">Featured</div>
        </div>
        <div class="Item_Cover" style="background-image: url()"></div>
        <h2 class="Item_Title">The title of the story</h2>
        <p class="Item_ContentPreview -truncated">
            Some limited preview of the story with some of the
        </p>
    </div>
    <div class="Item -size--half" data-loading="true">
        <div class="Item_Cover" style="background-image: url()"></div>
        <h2 class="Item_Title">Another story in the list</h2>
        <p class="Item_ContentPreview">
            Photo-based story so little text preview.
        </p>
    </div>
    <div class="Item -size--half">
        <div class="Item_Cover" style="background-image: url()"></div>
        <h2 class="Item_Title">A third story</h2>
        <p class="Item_ContentPreview -truncated">
            Some limited preview of the story with some of the
        </p>
    </div>
    <!--
        ...more story Items...
    -->
</div>
```

The first story is “featured”, so it is full width, while the rest of the
stories present themselves as half-size. The first story also gets a tag
indicating its featured status, which needs a helper wrapper for positioning.
(Note that the featured story has additional *Components* that the other 
instances of the `Item` *Module* do not have.) The second story is currently
being loaded using a method such as [Pjax](https://github.com/defunkt/jquery-pjax),
so it’s in a `loading` state.




## Structure

Rules are organized into files by *Module*, Those that are structural or
behavioral are kept separate from rules responsible for “Look-and-Feel” (LAF).
Everything is pulled together using a single manifest-type file, that is
responsible for load order.

### Specification

1.  Files that are not linked in the page MUST be prefixed with an underscore.

2.  Common functions and mixins SHOULD go into a `_global.sass` file or a
    `_global/` folder. They MAY be organized into different files and folders
    within the `_global` folder as necessary to maintain logical organization.

3.  Configuration settings, like fontstacks, colors, icon sets, and grid sizes
    SHOULD be placed in a `_config.sass` or a `_config/` folder. They MAY be
    organized into different files and folders within the `_config` folder as
    necessary to maintain logical organization.

4.  Structural and behavioral rules for a *Module* and its *Components* SHOULD
    be placed together in one file, and SHOULD be within a folder that
    contains only that *Module* or conceptually related *Modules*.

5.  The file for a *Module* SHOULD be named the same as the *Module*.

6.  Files and folders that contain only abstract *Modules* (defined with
    placeholder selectors) SHOULD be prefixed with a percent sign `%`:
    `_%AbstractModule.sass`.

7.  Look-and-Feel rules SHOULD be in a separate file, within the same folder
    as the primary *Module* rules. If present, this file MUST be suffixed with
    `LAF`: `ModuleName-LAF.sass`.

8.  Rules for specific views (pages) SHOULD be treated as a *Module*, with
    their own folder and files named as such.

9.  *Modules* for specific views MAY be aggregated into a `Views` folder if
    there is a small number of rules for each of those Views.

10. Rules for site-wide styles, such as general LAF and base structure, SHOULD
    be in a *Module* named `Site`.

11. There SHOULD be one file — the *manifest* — that is not prefixed with an
    underscore, and SHOULD be named `app.sass`.

12. There MAY be other *manifests*, for more selective loading of styles.



### Discussion

* There is an appeal to having each file import the parts it needs. However,
  the global nature of Sass/CSS and the behavior of placeholder selectors
  means this keeping this managable is often more trouble than it’s worth.
  Hacks like the `+exports` trick introduce their own share of complexity.

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
  sense to have strict 

