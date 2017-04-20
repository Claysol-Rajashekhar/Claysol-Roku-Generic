/**
 *  Upload a zip file to the Roku
 */

module.exports = function(gulp, plugins, config, util) {
    var title = 'UPLOAD ZIP';
    var fs = require('fs');
    var request = require('request');
    var _end;

    function goHome() {
        var url = 'http://' + config.rokuIp + ':8060/keypress/home';
        request.post(url);
    }

    function uploadZip(buildPath) {
        var url = 'http://' + config.rokuIp + '/plugin_install',
            options = {
                auth: {
                    user: 'rokudev',
                    pass: config.rokuPassword,
                    sendImmediately: false
                },
                formData: {
                    mysubmit: 'Replace',
                    archive: fs.createReadStream(buildPath)
                }
            },
            callback = function uploadZipCallback(err, httpResponse, body) {
                if (err || body === '') {
                    return util.error('upload failed: ' + err);
                }
                endTask();
            };
        request.post(url, options, callback);
    }

    var endTask = function () {
        util.log('Build uploaded to ' + config.rokuIp);
        util.finishMsg(title);
        _end();
    };

    return function(buildPath, end) {
        if (!config.rokuIp || config.rokuIp === '') {
            util.error('Please provide roku IP as argument. Example "gulp run --ip=192.168.1.2 --password=developer" or set the configuration in custom.gulp.config.json');
            end();
            return;
        }
        if (!config.rokuPassword || config.rokuPassword === '') {
            util.error('Please provide roku IP as argument. Example "gulp run --ip=192.168.1.2 --password=developer" or set the configuration in custom.gulp.config.json');
            end();
            return;
        }
        _end = end;
        util.startMsg(title);
        // Close the running app to avoid that the roku reboots
        goHome();
        // Wait a couple of seconds
        setTimeout(function() {
            //Start the upload process
            uploadZip(buildPath);
        }, 2000);
    };
};
