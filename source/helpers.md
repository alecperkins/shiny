# Helpers

Shiny includes some helpers for following its *Module* pattern. They work best
in the whitespace-sensitive, `.sass` syntax.

See the helpers in action on [Sassmeister](http://sassmeister.com/gist/7430531).



## `+extend`

Using the placeholders can get a bit repetitive. The `+extend` mixin takes a
*Module* or *Component* name and any variants. For subvariants, separate the
variant group and the variant value with a space.

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
    +extend(Container, full, spaceless)
```

Subvariants work like this:

```sass
.Story
    +extend(Item, size half, align center)
```



## `+extend-variants`

The `+extend-variants` mixin allows for remapping variants without reextending
the rest of the module. For example, the more semantic `-featured` variant can
extend a presentational `-size--large` variant.


Instead of using `+extend` twice:

```sass
.Story
    +extend(Item, size small)
    &.-featured
        +extend(Item, size large)
```

```css
.Story, .Story.-featured { /* ... */ }
.Story { /* ... */ }
.Story.-featured { /* ... */ }
```

Using `+extend-variants` eliminates the redundant selectors.

```sass
.Story
    +extend(Item, size small)
    &.-featured
        +extend-variants(Item, size large)
```

```css
.Story { /* ... */ }
.Story { /* ... */ }
.Story.-featured { /* ... */ }
```

(The duplicated `.Story` rules are from extending the `%Item`, and then the
`%Item%-size--small`.)



## `+auto-extend`

Sometimes, the placeholders simply need to be directly converted to regular
classes. The `+auto-extend` mixin does this.

```sass
+auto-extend(Container, full, spaceless, height half, height third)
```

```css
.Container { /*...*/ }
.Container.-full { /*...*/ }
.Container.-spaceless { /*...*/ }
.Container.-height--half { /*...*/ }
.Container.-height--third { /*...*/ }
```

Now, these classes can be used directly. A useful development pattern is to
auto-extend the module and variants, use the raw classes and identify the
combinations, then replace them with semantic classes that use the `+extend`
helper.



## `+state`

A helper for specifying declarations for a given state. The mixin can take
either a name, `+state(loading)`, or a name and value, `+state(progress, 50)`.
If a value is not specified, it will default to `true`.

```sass
.Gallery
    +state(loading)
        border-color: green
    +state(progress, 50)
        opacity: 0.5
```

```css
.Gallery[data-loading="true"] {
    border-color: green;
}
.Gallery[data-progress="50"] {
    opacity: 0.5;
}
```
