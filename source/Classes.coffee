# Public: a helper for managing Shiny-style variant classes. Handles
#         formatting the class names appropriately, and includes logic for
#         conditionally setting the classes.
#
class Classes
    # Public: create a manager instance.
    #
    # initial... - (optional) zero or more String classes to include in the
    #              class name output. `null`, `undefined`, or empty initial
    #              classes will be ignored.
    #
    constructor: (initial...) ->
        @_initial = initial.filter (c) -> c?.length > 0
        @_groups = {}
        @_switches = {}

    # Public: add the switch-type variant or set the group-type variant's
    #         value. Previously set variants of the same name and type will
    #         be overridden (with warning).
    #
    # name  - a String name of the variant to set.
    # val   - (optional=null) a value to set. If not included, the variant
    #           is treated as a switch.
    #
    # Returns self for chaining.
    set: (name, val=null) ->
        if name[0] is '-'
            console.warn "Variant specified with leading dash ('#{ name }'). The dashes will be added to the class automatically and should not be included in the `VariantList::add` argument."
            name = name.substring(1)
        if val?
            if @_groups[name]? and @_groups[name] isnt val
                console.warn "Variant group '#{ name }' overridden"
            @_groups[name] = val
        else
            if @_switches[name]? and not @_switches[name]
                console.warn "Variant switch '#{ name }' overridden"
            @_switches[name] = true
        return this

    # Public: add a variant if truthy.
    #
    # name  - a String name of the variant to add.
    # val   - (optional=null) a value to set. If not included or `true`, the
    #           variant is treated as a switch. If included and falsey, the
    #           variant is not added.
    #
    # Returns self for chaining.
    add: (name, val=null) ->
        if val or arguments.length is 1
            if val is true
                val = null
            @set(name, val)
        return this

    # Public: generate the class names for use in markup.
    #
    # Returns a String of space-separated classes.
    toString: ->
        classes = []
        classes.push(@_initial...)
        for n,v of @_switches
            classes.push("-#{ n }")
        for n,v of @_groups
            classes.push("-#{ n }--#{ v }")

        return classes.join(' ')

module.exports = Classes