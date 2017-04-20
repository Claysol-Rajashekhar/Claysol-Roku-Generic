/**
 *  Generate a zip package
 */

module.exports = function (gulp, plugins, config, util) {

    var title = 'GENERATE ZIP',
        appPackageName,
        tempFolder = config.gulpTempFolder,
        distributionPath = config.buildFolder,
        _end,
        del = require('del'),
        mkdirp = require('mkdirp'),
        zip = require('gulp-zip');


    var prepareDirectories = function () {
        util.mkdir(tempFolder);
        util.mkdir(distributionPath);
    };

    var generateBuild = function () {
        gulp.src(config.distIncludes)
            .pipe(gulp.dest(tempFolder))
            .on('end', generateDistribution);
    };

    var generateDistribution = function () {
        appPackageName = util.getDistributionName(config) + '.zip';
        gulp.src(tempFolder + '**/*')
            .pipe(zip(appPackageName))
            .pipe(gulp.dest(distributionPath))
            .on('end', function() {
                util.deleteFolderRecursive(tempFolder);
                endTask();
            });

    };

    var endTask = function () {
        util.log('Distribution created: ' + distributionPath + appPackageName);
        util.finishMsg(title);
        _end(distributionPath + appPackageName);
    };

    return function (end) {
        _end = end;
        util.startMsg(title);
        //Start the build process from prepareDirectories
        prepareDirectories();
        generateBuild();
    };
};
