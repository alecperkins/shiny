# Shiny

*(Some early thoughts, still rough, suggestions for improvement very welcome!)*

*Shiny* is a style of writing [Sass](http://sass-lang.com), a preprocessor language for CSS. It looks at styles like [BEM](http://csswizardry.com/2013/01/mindbemding-getting-your-head-round-bem-syntax/) and [SMACSS](http://smacss.com) and appreciates the concepts, but says “No thanks, there must be a smoother way”. (Takes some inspiration from [SUCKS](https://github.com/Team-Sass/SUCKS/blob/sam/thoughts.md).)

Shiny categorizes selectors, similar to SMACCS, and differentiates them with syntax, simliar to BEM. Unlike SMACSS and BEM, it takes more direct advantage of the `@extend` directive of Sass. This allows for avoiding chaining selectors as much as possible, or needing to combine the selectors into one long selector. Instead, presentational placeholders can be brought together under semantic classes. The `sass-shiny` package includes some helpers to do just that.

## Spec

    module              : Module
    module component    : ModuleComponent
    private module      : _Module
    variant             : -variant
    subvariant          : -variant_group--value
    state               : [data-state="value"]
    built-in state      : :disabled
    helper              : H-Helper

For example, the `Item` module contains components like `ItemCover` and `ItemTitle`. The `Item` module has variants like `-intrinsic_ratio` and `-size--half`. The `ItemCover` has variants like `-height--half` and `-height--twothirds`, among others. Variants MUST start with a `-`, and any class name that starts with a `-` MUST NOT be at root level. This guards against leaking variants, while avoiding the cumbersome, extra-long selectors of the BEM style. The modules, components, and variants are defined using placeholder classes. This way, they can be extended by semantic classes in the desired combinations. 

Another way to think about it is all “things” are camelcase, presentational tweaks are hyphens and underscores, and states are `data-` attributes.

### Module

The Module is the primary object. It SHOULD represent a reusable portion of an interface that serves as a single concept. It likely corresponds to a significant portion of the backend, or of front-end scripting as well.

Module classes MUST be written using camelcase: `ModuleName`
Internal modules and components, that are not intended to be extended by others, SHOULD be prefixed with an `_`, eg `%_ItemComponent`. 

### Component

Components are internal elements specific to a particular module. They MAY have subcomponents.

Component classes MUST be written using camelcase: `ModuleNameComponent`. These classes SHOULD be written prefixed with the name of the module they belong to. They SHOULD NOT be nested under the Module class unnecessarily.

### Variant

Variants are classes that adjust the presentation of the module. They MAY be exclusive to each other, or MAY be combined, depending on the rules they contain. Some variants are singular, like switching the variant on. Other variants are part of a group, and each “subvariant” is conceptually like setting a value to a property. Subvariants SHOULD be exclusive within their group.

Variant class names

* MUST begin with a hypen (`-`): `-variant`
* MUST be nested under their corresponding Module: `&%-variant`
* MAY use an underscore (`_`) to delimit words within the name: `-variant_group`

Subvariants MUST use a double hypen (`--`) to separate the variant group name and the variant “value”: `-variant_group--value`.

### State

State selectors are used to specify presentation based on state. Some states, like `:hover` and `:disabled` are built-in, so those of course should be used. Other states, like `loading`, do not have a built-in pseudo selector. These states MUST be represented using `data-` attributes: `[data-loading="true"]`. These attributes are easier to manipulate in script than `is-loading`, and this method allows for more specific information, like `[data-progress="40"]`. Most importantly, using `data-` attributes clearly differentiates the state styles from the structural and other presentational styles.

### Helper

Sometimes you just need a non-semantic class in the markup, like a wrapper for centering something. When this is the case, the class name SHOULD be prefixed with an `H-`. This indicates that the class is deliberately non-semantic.


## On the naming

The names “module” and “component” are chosen over “block” and “element”, since those have other meanings in this context (display: block, content block, HTML element). “Module” and “component” also correlate with the same JavaScript concepts. “Variant” was chosen over “modifier” since that’s a little too close to “module”. Why CamelCase? It helps to differentiate, and establish that this thing is a *thing*. Also, it stands out in normal text without additional formatting, making the modules and components easier to write about—important for documentation. An added bonus, the modules can easily correspond to related JavaScript/CoffeeScript class names. There is not a distinction between module and component names, aside from the [Smurf prefixing](http://www.codinghorror.com/blog/2012/07/new-programming-jargon.html), because the differences are potentially fuzzy. Having all “things” be named in that style keeps it simpler.

## Example

Given the module definitions:

```sass
%Item
    width: 100%
    &%-size--fourth
        width: 25%
    &%-size--third
        width: 33.33333%
    &%-size--half
        width: 50%

%ItemCover
    background-size: cover

%Container
    max-width: 1280px
    margin: 0 auto
    &%-full
        max-width: none
    &%-spaceless
        font-size: 0
        > *
            font-size: 1rem
```

The presentational variants can be combined into nice, clean semantic classes:

```sass
.Story
    @extend %Item
    @extend %Item%-size--small
    .IssueContents &
        @extend %Item%-size--half
    &.-featured
        @extend %Item%-size--full
.StoryCover
    @extend %ItemCover
.Issue
    @extend %Container
    @extend %Container%-full
.IssueContents
    @extend %Container
    @extend %Container%-full
    @extend %Container%-spaceless
```

Corresponding to this markup:

```html
<div class="Issue">
    <a class="IssueTitle">Issue Two</a>
    <ul class="IssueContents">
        <li class="Story -featured">
            <div class="StoryCover"></div>
            <a class="StoryTitle">Story One</a>
        </li>
        <li class="Story">
            <div class="StoryCover"></div>
            <a class="StoryTitle">Story Two</a>
        </li>
    </ul>
</ul>
```

The markup using the direct presentational selectors would look like:

```html
<div class="Container -full">
    <a>Issue Two</a>
    <ul class="Container -spaceless -full">
        <li class="Item -size--full">
            <div class="ItemCover"></div>
            <a class="ItemTitle">Story One</a>
        </li>
        <li class="Item -size--half">
            <div class="ItemCover"></div>
            <a class="ItemTitle">Story Two</a>
        </li>
    </ul>
</ul>
```

Not terrible, but certainly less semantic. The variants can of course be extended into a single long selector, if desired for performance reasons.


## Module spec helpers
Using the placeholders does get a bit repetitive. Shiny includes helpers. The `+extends` mixin takes a module name and any variants. For subvariants, separate the variant group and the variant value with a space.

So these extends:
```sass
.IssueContents
    @extend %Container
    @extend %Container%-full
    @extend %Container%-spaceless
```

become:
```sass
.IssueContents
    +extends(Container, full, spaceless)
```

Subvariants work like this:
```sass
.Story
    +extends(Item, size half)
```



Shiny.


