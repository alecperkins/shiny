module.exports = (grunt) ->
    
    DEBUG = not grunt.cli.options.production

    grunt.initConfig
        pkg: grunt.file.read('package.json')

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
                    return src.replace(/{{ VERSION }}/g, 'X.Y.Z')
                postCompile: (src, context) ->
                templateContext: {}
                markdownOptions:
                    gfm: true
    grunt.loadNpmTasks('grunt-markdown')

    # grunt.registerTask('default', ['browserify','uglify','compass'])
    grunt.registerTask('build:pages', ['markdown'])


