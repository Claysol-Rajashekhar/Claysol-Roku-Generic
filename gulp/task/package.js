/**
 *  Generate and download a PKG file
 */

module.exports = function(gulp, plugins, config, util) {
    var title = 'GENERATE PACKAGE';
    var exec = require('child_process').exec;
    var fs = require('fs');
    var request = require('request');
    var _end;
    var credentials = {
        user: 'rokudev',
        pass: config.rokuPassword,
        sendImmediately: false
    };

    function generatePkg() {
        var curTime = (new Date()).getTime();
        var url = 'http://' + config.rokuIp + '/plugin_package',
            options = {
                auth: credentials,
                formData: {
                    app_name: config.applicationName,
                    mysubmit: 'Package',
                    pkg_time: curTime,
                    passwd: config.developerIdPassword
                },
            },
            generatePkgCb = function generatePkgCallback(error, response, body) {
                var result,
                    pkgUrl,
                    urls;
                if (error || !body) return util.error('Generate pkg failed: ' + response.statusCode);
                // Get the URL of the pkg
                urls = body.match(/<a href=(.*?)>/g);
                if (!urls || typeof urls !== "object" || body.indexOf("Failed") !== -1) {
                    // console.log(body);
                    util.error("Failed to generate package");
                    return;
                }
                urls.map(function(val){
                    if (val.indexOf('.pkg') !== -1) {
                        result = val.split('"')[1];
                        pkgUrl = 'http://' + config.rokuIp + '/' + result;
                        downloadPkg(pkgUrl);
                        return;
                    }
                });
            };
        request.post(url, options, generatePkgCb);
    }

    function downloadPkg(url) {
        var appPackageName = util.getDistributionName(config) + '.pkg';
        util.debug('Download Package ' + url + ' to ' + config.buildFolder + appPackageName);
        request
            .get(url, {
                auth: credentials
            })
            .on('error', function downloadPkgError(err) {
                util.error(err);
            })
            .on('response', function() {
                endTask(config.buildFolder + appPackageName);
            })
            .pipe(fs.createWriteStream(config.buildFolder + appPackageName));
    }

    var endTask = function(res) {
        util.rainbow('███████████████████████████████████████████████████');
        util.log('Package downloaded');
        util.rainbow('███████████████████████████████████████████████████');
        util.finishMsg(title);
        _end(res); // Returns the path to the package file
    };

    return function(end) {
        if (!config.rokuIp || config.rokuIp === '') {
            util.error('Please provide roku IP as argument. Example "gulp package --ip=192.168.1.2 --password=developer" or set the configuration in custom.gulp.config.json');
            end();
            return;
        }
        _end = end;
        util.startMsg(title);
        generatePkg();
    };
};
