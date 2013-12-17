# Documentation

Docs are an important part of code. They explain the why, and when passed
through a processor provide a good place to put example usage. This allows for
automatic generation of tools like a style guide or component guide. To that
end, Shiny has a preferred style of writing docs, and includes a component
guide generator.

(This is not part of the core specification, since there are many different
documentation styles for different usecases and preferences, and the core spec
is not dependent on any particular style.)


    # <ComponentName or SubcomponentName>

    <description and usage>

    ```html
    <example markup>
    ```

    ## Variants

    ### <variant_1>

    <variant description>

    ```html
    <example markup with variant>
    ```


1. The primary definition of each module and component MUST be introduced with
   a comment section that describes what the module is, how it is used, and
   includes example markup.

2. The comment block SHOULD include the variants for that module or component.

3. The comments MUST be the inline style, even as a block, with each line
   beginning with `//`. (This is a limitation of the parsing more than
   anything. Hopefully this will be updated to allow for block comments of
   both styles.)

4. [Markdown](http://daringfireball.net/projects/markdown/) syntax MUST be
   used for the comments.

5. Each primary comment section MUST start with a heading and the module or
   component name: `# Component` or `# Component_Subcomponent`.

6. Example markup MUST be added using backticks, and SHOULD indicate that it
   is HTML, using the [GitHub Flavored Markdown](https://help.github.com/articles/github-flavored-markdown)
   method: ````html`


### Example

For example, a primary comment for a component that includes variants and
example markup:

    // # Item_Cover
    //
    // An optional component of the Item module that displays a cover image. It
    // uses the `style=""` attribute and the `background-image: url()` rule
    // instead of an `img` in order to control the aspect ratio.
    //
    // The cover MAY contain other components, like Item_Supertitle and Item_Title,
    // grouped in an Item_Info component. The Item_Info allows for positioning the
    // interior components as a group.
    //
    // ```html
    // <div class="Item">
    //     <div class="Item_Cover -height--half" style="background-image: url(http://placepuppy.it/800/600/)">
    //         <div class="Item_Info">
    //             <div class="Item_Supertitle">Supertitle</div>
    //             <h2 class="Item_Title">Title</h2>
    //         </div>
    //     </div>
    // </div>
    // ```
    //
    // ## Variants
    //
    // ### `-height--*`
    //
    // The actual height of the cover is dependent on the size of the Item it is
    // inside. It can be controlled with the `-height--half` and
    // `-height--twothirds` variants, which set the cover to half or twothirds of
    // its usual height.
    //
    // The parent Item MAY have a variant like `-intrinsic_ratio`, which causes
    // the Item_Cover to instead scale with a consistent aspect ratio. This variant
    // is on the item since it requires an additional wrapper around the cover,
    // the Item_CoverWrapper component. If this is active, then the `-height--*`
    // variants don’t make much sense and SHOULD NOT be used.
    //
    // #### `-height--half`
    //
    // ```html
    // <div class="Item -size--small">
    //     <div class="Item_Cover -height--half" style="background-image: url(http://placepuppy.it/800/600/)">
    //         <div class="Item_Info">
    //             <div class="Item_Supertitle">Supertitle</div>
    //             <h2 class="Item_Title">Title</h2>
    //         </div>
    //     </div>
    // </div>
    // ```
    %Item_Cover
        <the actual component code>


The example markup will be turned into live examples, as well as viewable
source. The actual source of the module or component will also be included in
an expandable section. All headings will be given deep links using anchors
based on their content.

The generator makes some assumptions about the structure of the docs. If the
styleguide output seems weird, the code probably is, too. The code itself
SHOULD also have inline comments as appropriate. These will be passed through
and included in the styleguide.
