# Discussion

* If a *Subcomponent* is reusable across different *Components*, or outside of
  the *Component*, then it is probably itself a *Component*. The underscore
  before the `SubcomponentName` is intended to suggest that the *Subcomponent*
  is private to the *Component*.

* *Subcomponents* do not have hard prefixing, to avoid the need for messy
  `@extend` situations in cases where the *Variants* need to modify the
  *Subcomponents*, and nested extends would result in redundant selectors.

* CamelCase is chosen to help differentiate the *Components* and
  *Subcomponents* from classes for variants. Also, it stands out in normal
  text without additional formatting, helpful for documentation. An added
  bonus is it follows conventions used in frontend or backend logic, such as a
  Backbone or Django View, which makes it easy to associate the markup, style,
  and script that are responsible for that module.

* The names “component” and “subcomponent” are chosen over “block”, “element”,
  or “class”, since those have other meanings in this context (`display: block`,
  content block, HTML element, CSS class).

* Keeping *Variants* separate from the full *Component* or *Subcomponent* name
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
  `class="StoryList -grid--four -selected"`.

* *State* versus *Variant* is potentially fuzzy. A good differentiator is if
  it is being modified by JavaScript, like “disabled”, “loading”, or
  “progress”, it’s a *State*. If it is not going to change once the page
  loads, it is a *Variant*. It’s also a good idea to keep the *State* values
  JSON-compatible, since some JavaScript libraries parse `data-` attributes as
  JSON when accessing them. (This is also why the `"true"` is required.)

* The *LAF* distinction makes it clear that the element with that class has
  no semantic role, and can be modified or removed as the look-and-feel
  dictate. With sound markup construction, *LAF* elements are unnecessary.
  
* More sophisticated selector prefixes, with characters like `^` and `+` are
  possible, but are easy to confuse with things like regex and sibling
  selectors, or are just awkward to type.

* Using underscore delimited IDs instead of hyphenated allows them to more
  easily correspond to script variables, and also clearly distinguishes them
  from the other kinds of selectors.

