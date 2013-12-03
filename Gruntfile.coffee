module.exports = (grunt) ->
    
    DEBUG = not grunt.cli.options.production
    PACKAGE = grunt.file.readJSON('package.json')

    grunt.initConfig

        markdown:
            all:
                files: [
                    {
                        expand: true
                        src: 'source/*.md'
                        dest: 'build/'
                        ext: '.html'
                    }
                ]
            options:
                template: 'templates/base.jst'
                preCompile: (src, context) ->
                    return src.replace(/{{ VERSION }}/g, PACKAGE.version)
                postCompile: (src, context) ->
                templateContext: {}
                markdownOptions:
                    gfm: true
    grunt.loadNpmTasks('grunt-markdown')

    grunt.registerTask('default', ['markdown'])


