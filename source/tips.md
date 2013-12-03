
# Tips

## Abstract Modules

Using placeholder selectors, modules can be defined in an abstract way. That
is, they do not directly generate rules in the CSS output.

This also provides a way to use semantic classes in the markup, while still
having presentational classes in Sass for organizational purposes.

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

%Item_Cover
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
    .Issue_Contents &
        @extend %Item%-size--half
    &.-featured
        @extend %Item%-size--full
.Story_Cover
    @extend %Item_Cover
.Issue
    @extend %Container
    @extend %Container%-full
.Issue_Contents
    @extend %Container
    @extend %Container%-full
    @extend %Container%-spaceless
```

Corresponding to this markup:

```html
<div class="Issue">
    <a class="Issue_Title">Issue Two</a>
    <ul class="Issue_Contents">
        <li class="Story -featured">
            <div class="Story_Cover"></div>
            <a class="Story_Title">Story One</a>
        </li>
        <li class="Story">
            <div class="Story_Cover"></div>
            <a class="Story_Title">Story Two</a>
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
            <div class="Item_Cover"></div>
            <a class="Item_Title">Story One</a>
        </li>
        <li class="Item -size--half">
            <div class="Item_Cover"></div>
            <a class="Item_Title">Story Two</a>
        </li>
    </ul>
</ul>
```

Not terrible, but certainly less semantic. The variants can of course be
extended into a single long selector, if desired for performance reasons.

