module.exports = function (grunt) {
    grunt.initConfig({
        sass: {
            dev: {
                files: [
                    {
                        cwd: 'scss/',
                        src: ['**.scss', '**.css'],
                        dest: 'css/',
                        expand: true,
                        ext: '.css'
                    },
                    {
                        src: 'components/**/*.scss',
                        expand: true,
                        ext: '.css'
                    }
                ]
            }
        },
        browserify: {
            options:  {
                transform: ['coffeeify']
            },
            dev: {
                files: [
                    {
                        src: ['components/**/*.coffee', '!**/_*'],
                        expand: true,
                        ext: '.js'
                    },
                    {
                        cwd: 'coffee',
                        src: ['**.js', '**.coffee', '!**/_*', '!_**'],
                        dest: 'js/bundle.js'
                    }
                ]
            }
        },
        watch: {
            files: ['index.html', 'components/**/*.scss', 'components/**/*.html', 'components/**/*.coffee', 'js/**', 'scss/**', 'css/**', 'coffee/**', 'Gruntfile.js'],
            tasks: ['browserify', 'sass'],
            options: {
                livereload: true
            }
        }
    });

    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-contrib-sass');
    grunt.loadNpmTasks('grunt-browserify');
    grunt.registerTask('build' , ['browserify', 'sass']) ;
    grunt.registerTask('default' , ['build', 'watch']) ;
};
