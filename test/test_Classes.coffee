should = require 'should'

describe 'Classes', ->

    Classes = require '../source/Classes'
    shiny = require '../source'

    describe 'constructor', ->
        it 'should output the initial class on .toString()', ->
            c = new Classes('InitialClass')
            c.toString().should.equal('InitialClass')

        it 'should handle multiple initial classes', ->
            c = new Classes('InitialClass', 'OtherClass', 'ThirdClass')
            c.toString().should.equal('InitialClass OtherClass ThirdClass')

        it 'should ignore falsey initial classes', ->
            c = new Classes('InitialClass', null, 'ThirdClass')
            c.toString().should.equal('InitialClass ThirdClass')

        it 'should be empty if no initial', ->
            c = new Classes()
            c.toString().should.equal('')

    describe 'set', ->
        it 'should set a switch-type variant', ->
            c = new Classes('InitialClass')
            c.set('switch')
            c.toString().should.equal('InitialClass -switch')

        it 'should set multiple switch-type variants', ->
            c = new Classes('InitialClass')
            c.set('switch')
            c.set('flag')
            c.toString().should.equal('InitialClass -switch -flag')

        it 'should set group-type variants', ->
            c = new Classes('InitialClass')
            c.set('group', 'value')
            c.toString().should.equal('InitialClass -group--value')

        it 'should set multiple, mixed-type group-type variants', ->
            c = new Classes('InitialClass')
            c.set('group', 'value')
            c.set('group2', 'value')
            c.set('group3', true)
            c.set('group4', false)
            c.set('group5', 4)
            c.toString().should.equal('InitialClass -group--value -group2--value -group3--true -group4--false -group5--4')

        it 'should take an object for setting multiple variants at once', ->
            c = new Classes('InitialClass')
            c.set
                group: 'value'
                group2: 'value'
                group3: true
                group4: false
                group5: 4
            c.toString().should.equal('InitialClass -group--value -group2--value -group3--true -group4--false -group5--4')

        it 'should override group-type variants', ->
            c = new Classes('InitialClass')
            c.set('group', 'value1')
            c.set('group', 'value2')
            c.toString().should.equal('InitialClass -group--value2')

        it 'should set group- and switch-type variants', ->
            c = new Classes('InitialClass')
            c.set('group', 'value')
            c.set('switch')
            c.toString().should.equal('InitialClass -switch -group--value')

    describe 'add', ->
        it 'should add a switch-type variant', ->
            c = new Classes('InitialClass')
            c.add('switch')
            c.toString().should.equal('InitialClass -switch')

        it 'should add a switch-type variant if true', ->
            c = new Classes('InitialClass')
            c.add('switch', true)
            c.toString().should.equal('InitialClass -switch')

        it 'should not add a switch-type variant if false', ->
            c = new Classes('InitialClass')
            c.add('switch', false)
            c.toString().should.equal('InitialClass')

        it 'should add a group-type variant if truthy', ->
            c = new Classes('InitialClass')
            c.add('group', 'value')
            c.toString().should.equal('InitialClass -group--value')

        it 'should take an object for adding multiple variants at once', ->
            c = new Classes('InitialClass')
            c.add
                group: 'value'
                switch: true
                group2: ''
                switch2: false
            c.toString().should.equal('InitialClass -switch -group--value')

        it 'should not add a group-type variant if falsey', ->
            c = new Classes('InitialClass')
            c.add('group', null)
            c.add('group', '')
            c.add('group', 0)
            c.toString().should.equal('InitialClass')

    describe 'shorthand', ->
        it 'should output the initial class on .toString()', ->
            c = shiny('InitialClass')
            c.toString().should.equal('InitialClass')

        it 'should handle multiple initial classes', ->
            c = shiny('InitialClass', 'OtherClass', 'ThirdClass')
            c.toString().should.equal('InitialClass OtherClass ThirdClass')

        it 'should ignore falsey initial classes', ->
            c = shiny('InitialClass', null, 'ThirdClass')
            c.toString().should.equal('InitialClass ThirdClass')

        it 'should be empty if no initial', ->
            c = shiny()
            c.toString().should.equal('')