/**
 *  Rekey a Roku device
 */

module.exports = function(gulp, plugins, config, util) {
    var title = 'REKEY';
    var request = require('request');
    var fs = require('fs');
    var _end;

    function rekey() {
        util.debug('Rekey device');
        var url = 'http://' + config.rokuIp + '/plugin_inspect',
            options = {
                auth: {
                    user: 'rokudev',
                    pass: config.rokuPassword,
                    sendImmediately: false
                },
                formData: {
                    mysubmit: 'Rekey',
                    passwd: config.developerIdPassword,
                    archive: fs.createReadStream(config.developerIdPackage)
                }
            },
            callback = function rekeyCallback(err, httpResponse, body) {
                if (err || body === '') {
                    return util.error('rekey upload failed: ' + err);
                }
                // Get all a href tags
                var res = body.match(/<font color=\"red\">(.*?)<\/font>/g);
                if (res && res[0] && res[0].indexOf('Success') !== -1) {
                    util.debug('Device rekey successful');
                } else {
                    util.error(body);
                    err = 'Failed to rekey';
                }
                endTask(err);
            };
        request.post(url, options, callback);
    }

    var endTask = function (err) {
        util.log('Device rekeyed');
        util.finishMsg(title);
        _end(err);
    };

    return function(end) {
        if (!config.rokuIp) {
            util.error('Please provide roku IP as argument. Example "gulp rekey --ip=192.168.1.2 --password=developer" or set the configuration in custom.gulp.config.json');
            end();
            return;
        }
        _end = end;
        util.startMsg(title);
        rekey();
    };
};
