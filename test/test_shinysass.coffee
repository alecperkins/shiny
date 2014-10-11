should = require 'should'
sass = require 'node-sass'

# Skipping until libsass catches up to Ruby Sass.
describe.skip 'components', ->

    describe 'extend', ->
        it 'should extend placeholder classes', ->
            css = sass.renderSync
                includePaths: ['./stylesheets/']
                outputStyle: 'compressed'
                data: """
                    @import "shiny";
                    %Block {
                        color: red;
                    }
                    .TextBlock {
                        @include extend(Block);
                    }
                    .ImageBlock {
                        @include extend(Block);
                        border: 1px solid black;
                    }
                """
            css.should.equal """.TextBlock,.ImageBlock{color:red;}.ImageBlock{border:1px solid black;}"""

        it 'should extend switch variants', ->
            css = sass.renderSync
                includePaths: ['./stylesheets/']
                outputStyle: 'compressed'
                data: """
                    @import "shiny";
                    %Block {
                        color: red;
                        &%-switch {
                            color: blue;
                        }
                        &%-switch_b {
                            font-size: 14px;
                        }
                    }
                    .TextBlock {
                        @include extend(Block);
                    }
                    .ImageBlock {
                        @include extend(Block, switch);
                    }
                    .EmbedBlock {
                        @include extend(Block, switch, switch_b)
                    }
                """
            css.should.equal """.TextBlock,.ImageBlock,.EmbedBlock{color:red;}.ImageBlock,.EmbedBlock{color:blue;}.EmbedBlock{font-size:14px}"""

        it 'should extend group variants', ->
            css = sass.renderSync
                includePaths: ['./stylesheets/']
                outputStyle: 'compressed'
                data: """
                    @import "shiny";
                    %Block {
                        color: red;
                        &%-group--value {
                            color: blue;
                        }
                        &%-group--value2 {
                            color: green;
                        }
                        &%-group2--value1 {
                            color: orange;
                        }
                        &%-group2--value2 {
                            color: yellow;
                        }
                    }
                    .TextBlock {
                        @include extend(Block);
                    }
                    .ImageBlock {
                        @include extend(Block, group value);
                    }
                    .EmbedBlock {
                        @include extend(Block, group value2, group2 value1);
                    }
                """
            css.should.equal """.TextBlock,.ImageBlock,.EmbedBlock{color:red;}.ImageBlock{color:blue;}.EmbedBlock{color:green;}.EmbedBlock{color:orange;}"""

        it 'should extend both kinds of variants', ->
            css = sass.renderSync
                includePaths: ['./stylesheets/']
                outputStyle: 'compressed'
                data: """
                    @import "shiny";
                    %Block {
                        color: red;
                        &%-group--value {
                            color: blue;
                        }
                        &%-group--value2 {
                            color: green;
                        }
                        &%-switch1 {
                            color: orange;
                        }
                        &%-switch2 {
                            color: yellow;
                        }
                    }
                    .TextBlock {
                        @include extend(Block, switch1);
                    }
                    .ImageBlock {
                        @include extend(Block, group value, switch1);
                    }
                    .EmbedBlock {
                        @include extend(Block, switch1, group value);
                    }
                """
            css.should.equal """.TextBlock,.ImageBlock,.EmbedBlock{color:red;}.ImageBlock{color:blue;}.ImageBlock{color:orange;}.EmbedBlock{color:orange;}.EmbedBlock{color:blue;}"""
