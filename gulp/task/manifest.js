/**
 *  Generate manifest file
 */

module.exports = function(gulp, plugins, config, util) {
    var title = 'GENERATE MANIFEST',
        fs = require('fs');

    var assembleManifest = function() {
        var build = util.getBuildNumber(),
            manifest = '';
        manifest += 'title=' + config.applicationName + '\n';
        manifest += 'major_version=' + config.versionMajor + '\n';
        manifest += 'minor_version=' + config.versionMinor + '\n';
        manifest += 'build_version=' + build + '\n';

        for (var i in config.manifest) {
            if (config.manifest.hasOwnProperty(i)) {
                manifest += i + '=' + config.manifest[i] + '\n';
            }
        }
        createManifest(manifest);
    };


    var createManifest = function(manifest) {
        fs.writeFileSync('src/main/manifest', manifest);
        endTask();
    };

    var endTask = function () {
        util.finishMsg(title);
        _end();
    };


    return function(end) {
        _end = end;
        util.startMsg(title);
        assembleManifest();
    };
};
