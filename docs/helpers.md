# Helpers

The `shiny` package includes helpers for working with Shiny-style variants: a
JavaScript module for server- or client-side class manipulation, and Sass
mixins for cleaner extending of variant placeholder selectors.



## JavaScript

The `shiny` package is CommonJS compatible, and works well on the server for
initial rendering and on the client, using [Browserify](http://browserify.org/),
for dynamic interfaces.

### In action

<iframe width="100%" height="300" src="http://jsfiddle.net/alecperkins/tkzqbd23/2/embedded/" allowfullscreen="allowfullscreen" frameborder="0"></iframe>

### `Classes::set`

```javascript
var Classes = require('shiny').Classes;

var variants = new Classes('TextBlock');
variants.set('align', 'right');
variants.set('lede')

var markup = '<p class="' + variants + '">...</p>'
```

`markup` is then

```html
<p class="TextBlock -lede -align--right">...</p>
```

### `Classes::add`

The `Classes` instance also has an `add` method for convenience that behaves
the same as set, but only if the value is truthy.

```javascript
variants.add('effect', block.effect);
```

will only add the variant `-effect--dropcaps` if `effect` is defined on the
`block`. If the value is `true`, it is treated like a switch:

```javascript
variants.add('first', i===0);
```

adds the variant `-first`.

(State helpers are not included since assignment to the element dataset can
be used more directly, eg `el.dataset.loaded = state.loaded;`,
`data-loaded="{{ loaded }}"`.)



## Sass

These mixins work in Ruby Sass v3.3+, and partially work in
[libSass](http://sass-lang.com/libsass). By design they only extend
placeholder classes.

### In action

<p class="sassmeister" data-gist-id="b6b2990a3fdb93246bc2" data-height="480"><a href="http://sassmeister.com/gist/b6b2990a3fdb93246bc2">Play with this gist on SassMeister.</a></p><script src="http://cdn.sassmeister.com/js/embed.js" async></script>

### `@include extend`

Using `@extend` with multiple variants can get repetitive:

```scss
.Story {
    @extend %Item;
    @extend %Item%-size--half;
    @extend %Item%-align--center;
    @extend %Item%-dark;
}
```

The `@include extend` mixin provides a cleaner approach that also enforces the
syntax. It takes a Component, Subcomponent, Layout, or Region name, and an
optional list of variants to apply.

```scss
.Story {
    @include extend(Item, size half, align center, dark);
}
```


### `@include extend-variants`

Similar to `@include extend`, but does not extend the given Component, only
the variants. This is useful for remapping certain abstract variants to more
semantic names.

```scss
.Story {
    @include extend(Item, size small);
    &.-featured {
        @include extend-variants(Item, size large);
    }
}
```

```css
.Story { ... }
.Story.-featured { ... }
```

Using the regular `@include extend` would result in redundant selectors:

```css
.Story, .Story.-featured { ... }
.Story.-featured { ... }
```


### `@include state`

A helper for specifying declarations for a given state. The mixin can take
either a name, `@include state(loading)`, or a name and value,
`@include state(progress, 50)`. If a value is not specified, it will default
to `true`.

```scss
.Gallery {
    @include state(loading) {
        border-color: green;
    }
    @include state(progress, 50) {
        opacity: 0.5;
    }
}
```

```css
.Gallery[data-loading="true"] {
    border-color: green;
}
.Gallery[data-progress="50"] {
    opacity: 0.5;
}
```


### `@include auto-extend`

Sometimes, the placeholders need to be directly converted to regular classes.
The `@include auto-extend` mixin does this.

```scss
@include auto-extend(Container, full, spaceless, height half, height third)
```

```css
.Container { ... }
.Container.-full { ... }
.Container.-spaceless { ... }
.Container.-height--half { ... }
.Container.-height--third { ... }
```

Now, these classes can be used directly. A useful development pattern is to
auto-extend the component and variants, use the presentational classes in
markup and identify the desired combinations and patterns, then replace them
with more semantic classes that use the `@include extend` helper.
