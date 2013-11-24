# Styleguide Generator Prototype

# TODO: Element states, file specification, base template, manifest for explicit control of the styleguide structure
###
index.yaml
- Item:
    - ItemCover
    - ItemTitle
    - ItemSubtitle
- Container

- Button:
    - :disabled
    - [data-active="true"]
###
# Instead, for state, look for a heading with "State", then the headings of each subsequent one is a state class, and use extends to generate selectors to force the state in documentation.
# But how does it know what markup to use? Require an ```html block for that section? Or does it use the first, "default" example?

# Temporary hardcoding of operands.
TARGET_FILE = 'source/_Item.sass'
OUTPUT_STYLE_FILE = './dist/index.css'



fs = require 'fs'
{ markdown } = require 'markdown'



text = fs.readFileSync(TARGET_FILE).toString()
lines = text.split('\n')

console.log lines.length, 'Lines'



# Gather the lines of the target source file, grouping them by block.
blocks = []
in_comment = false
new_block = null
lines.forEach (line, line_no) ->
    # Lines in files start at 1 instead of 0
    line_no += 1
    # Comments indicate the start of a block
    if line.substring(0,2) is '//'
        if not in_comment
            # If there is already a block, push it and start a new one.
            if new_block?
                new_block.end = line_no - 1
                blocks.push(new_block)
            new_block =
                comment: []
                code: []
            in_comment = true
        # Push the comment line without the leading `// ` (may be empty)
        new_block.comment.push(line.substring(3))
    else
        in_comment = false
        if new_block?
            unless new_block.code_start?
                # Set the line number of the start of the code, for use in
                # displaying the code in the style guide.
                new_block.code_start = line_no
            new_block.code.push(line)

    # Don’t forget to push the last block, which doesn’t have a following
    # comment to cause it to be pushed.
    if line_no is lines.length - 1
        new_block.code_end = line_no
        blocks.push(new_block)

console.log blocks.length, 'Blocks'



escapeHTML = (source) ->
    TO_ESCAPE = [
        [/&/g, '&amp;']
        [/"/g, '&quot;']
        [/\</g, '&lt;']
        [/\>/g, '&gt;']
    ]
    TO_ESCAPE.forEach (pair) ->
        [pattern, replacement] = pair
        source = source.replace(pattern, replacement)
    return source

processBlock = (block) ->

    output = ''
    header_stack = []

    # Parse the comment string as Markdown, converting any included HTML
    # blocks to rendered examples.
    do ->
        # .parse produces JSONML
        tree = markdown.parse(block.comment.join('\n'))
        # The first item is 'markdown', which is unnecessary for this purpose.
        tree.shift()

        # Iterate over all the nodes in the JSONML tree, processing them as
        # necessary.
        tree.forEach (node) ->
            switch node[0]
                when 'header'
                    content = node[2]
                    text_content = content
                    if content[0] is 'inlinecode'
                        text_content = content[1]
                        content = "<code>#{ text_content }</code>"

                    # Keep track of the header level, so everything stays in
                    # the correct nesting level. The header stack is also used
                    # to create deep links to each header.
                    while node[1].level <= header_stack.length
                        console.log 'popping', node[1].level, header_stack.length
                        header_stack.pop()
                    header_stack.push(text_content.replace(/\ /g, '-'))
                    header_slug = header_stack.join('/')

                    output += """
                            <h#{node[1].level}>
                                <a href="##{ header_slug }" name="#{ header_slug }" class="ExampleDeepLink">#</a>
                                #{ content }
                            </h#{node[1].level}>
                        """
                when 'para'
                    if node[1][0] is 'inlinecode'
                        content = node[1][1]
                        # The initial bit of code may be a GitHub Flavored
                        # Markdown-style language indicator.
                        if content.substring(0,5) is 'html\n'
                            content = content.substring(5)
                        header_slug = header_stack.join('/')
                        output += """
                                <div class="Example">
                                    <h#{ header_stack.length + 1}>
                                        <a href="##{ header_slug }/Example" name="#{ header_slug }/Example" class="ExampleDeepLink">#</a>
                                        Example
                                    </h#{ header_stack.length + 1}>
                                    <div class="ExampleRendered">#{ content }</div>
                                    <h#{ header_stack.length + 2 }>
                                        <a href="##{ header_slug }/Example/Example-Source" name="#{ header_slug }/Example/Example-Source" class="ExampleDeepLink">#</a>
                                        Example Source
                                    </h#{ header_stack.length + 2}>
                                    <pre class="ExampleSource language-markup"><code>#{ escapeHTML(content) }</code></pre>
                                </div>
                            """
                    else
                        output += """
                                <p class="DocSnippet">
                                    #{ markdown.renderJsonML(markdown.toHTMLTree(node)) }
                                </p>
                            """

    # Include the actual block source, with a line number offset so that the
    # displayed line numbers in the docs match the line numbers in the source.
    do ->
        code_str = block.code.join('\n')
        line_no = block.code_start
        header_slug = header_stack.join('/')
        output += """
                <h#{ header_stack.length + 1}>
                    <a href="##{ header_slug }/Source" name="#{ header_slug }/Source" class="ExampleDeepLink">#</a>
                    Source
                </h#{ header_stack.length + 1 }>
                <pre class='BlockSource language-markup line-numbers' data-start='#{ line_no }'><code>#{ code_str }</code></pre>
            """
    return output




block_markup = blocks.map (block, i) ->
    example_markup = processBlock(block)
    return """
            <div class="DocItem">
                #{ example_markup }
            </div>
        """

doc_markup = """
        <meta charset="utf-8">
        <link rel="stylesheet" href="#{ OUTPUT_STYLE_FILE }">
        <link rel="stylesheet" href="./prism.css">
        <link rel="stylesheet" href="./docs.css">

        #{ block_markup.join('') }

        <script src="./prism.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/zepto/1.0/zepto.min.js"></script>
        <script src="./docs.js"></script>
    """

fs.writeFileSync('output.html', doc_markup)
