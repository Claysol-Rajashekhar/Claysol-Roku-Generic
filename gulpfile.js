// Dependencies
var gulp = require('gulp');
var gulpLoadPlugins = require('gulp-load-plugins');
var plugins = gulpLoadPlugins({
    config: process.cwd() + '/package.json'
});
var util = require("./gulp/utils");
var config = require('./gulp/default.gulp.config.json');
var argv = require('yargs').argv;

//Global Varibles
global.APP_ENV = argv.env || 'dev'; // e.g. dev, stage and prod
global.APP = argv.app || 'Claysol-Roku-Generic'; // for multitenancy apps

// Local variables
var zipFilePath;
var packageFilePath;

//Generic Error Handling
gulp.on('err', function (e) {
    util.error(e.err.stack);
});

// Import brand specific gulp config
var appGulpConfig = require('./configs/custom.gulp.config.json') || {};

//Config Settings
config.rootPath = process.cwd() + "/";
config.basePath = config.rootPath + config.basePath;
config = util.extend(config, appGulpConfig);
util.setDebug(config.debug);

// Override IP and rokuPassword if it is passed as parameter.
if (argv.ip !== undefined) {
    config.rokuIp = argv.ip;
}
if (argv.password !== undefined) {
    config.rokuPassword = argv.password;
}


//////////////////
////Gulp Tasks////
//////////////////

//Rekey the Roku device
gulp.task('rekey', require('./gulp/task/rekey')(gulp, plugins, config, util));

// Create a manifest file
gulp.task('manifest', require('./gulp/task/manifest')(gulp, plugins, config, util));

//Replace the src/main/config.json with the current environment config
gulp.task('set-config', require('./gulp/task/set-config')(gulp, plugins, config, util));

// Generate a zip
gulp.task('zip', [ 'set-config', 'manifest' ], function(cb) {
    var zip = require('./gulp/task/zip')(gulp, plugins, config, util);
    return zip(function(res) {
        zipFilePath = res;
        cb();
    });
});

// Create a pkg file and download it.
gulp.task('build', [ 'run' ], function(cb) {
    var build = require('./gulp/task/package')(gulp, plugins, config, util);
    return build(function(res) {
        packageFilePath = res;
        cb();
    });
});

// Run the app
gulp.task('run', [ 'zip' ], function(cb) {
    var uploadzip = require('./gulp/task/uploadzip')(gulp, plugins, config, util);
    return uploadzip(zipFilePath, function() {
        cb();
    });
});
gulp.task('default', [ 'run' ]);
