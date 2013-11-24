#### Helpers

Using the placeholders does get a bit repetitive. Shiny includes helpers. The
`+extend` mixin takes a module name and any variants. For subvariants,
separate the variant group and the variant value with a space.

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
    +extend(Item, size half)
```

The `+extend-variants` mixin allows for remapping variants without reextending
the rest of the module.




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

Now, these classes can be used directly. A useful development pattern is to auto-extend the module and variants, use the raw classes and identify the combinations, then replace them with semantic classes that use the `+extend` helper.



variants

fontstack
icon
auto-extend

http://sassmeister.com/gist/7430531