/**
 *  Set Config JSON file
 */

var title = 'SET config.json';

var configEnv = {
    dev: 'dev.config.json',
    qa: 'qa.config.json',
    stage: 'stage.config.json',
    prod: 'prod.config.json',
    configFolder: 'configs',
    destFolder: 'src/main'
};

module.exports = function (gulp, plugins, config, util) {

    return function (end) {
        util.startMsg(title);

        var appEnv = global.APP_ENV;
        var selectedConfigFile = configEnv[appEnv];
        var rename = require('gulp-rename');

        if (!selectedConfigFile) {
            util.error(appEnv + ' does not have a config');
            end();
            return;
        }

        util.debug('Use ' + configEnv.configFolder + '/' + global.APP + '/' + selectedConfigFile + ' to replace config.json');

        gulp.src(configEnv.configFolder + '/' + global.APP + '/' + selectedConfigFile)
            .pipe(rename('config.json'))
            .pipe(gulp.dest(configEnv.destFolder))
            .on('finish', function() {
                util.finishMsg(title);
                end();
            })
            .on('error', function(err) {
                util.error(err);
                end();
            });

    };
};
