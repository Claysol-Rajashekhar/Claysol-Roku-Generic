/**
 *
 * General Utils
 * @author Francisco Aranda <francisco.aranda@accedo.tv>
 *
 */

var fs = require('fs');
require('colors');

module.exports = {

    __debug: false,

    setDebug: function (debug) {
        __debug = debug;
    },

    CONSTANTS: {
        LOG: "LOG: ",
        DEBUG: "DEBUG: ",
        ERROR: "ERROR: "
    },

    logo: function () {
    },

    rainbow: function (msg) {
        console.log("\n");
        console.log(msg.rainbow);
        console.log("\n");
    },

    startMsg: function (msg) {
        console.log("\n");
        console.log("╔██████════| START  ".green + msg.green + " |════██████╗".green);
        console.log("\n");
    },

    finishMsg: function (msg) {
        console.log("\n");
        console.log("╚██████════| FINISH ".green + msg.green + " |════██████╝".green);
        console.log("\n");
    },


    info: function (msg) {
        console.log(
            msg.green
        );
    },

    log: function (msg) {
        console.log(
            this.CONSTANTS.LOG + msg
        );
    },

    debug: function (msg) {
        if (!__debug) {
            return;
        }
        console.log(
            this.CONSTANTS.DEBUG.grey + msg.grey
        );
    },

    error: function (msg) {
        msg = msg || "";
        console.log(
            this.CONSTANTS.ERROR.red + msg.red
        );
    },

    mkdir: function (path) {
        try {
            fs.mkdirSync(path);
        } catch (e) {
            if (e.code != 'EEXIST') throw e;
        }
    },

    fail: function (err) {
        console.log(
            this.CONSTANTS.ERROR.red + err.red
        );

    },

    progress: function (progress) {
        console.log(
            this.CONSTANTS.DEBUG.blue + progress.blue
        );
    },

    deleteFolderRecursive: function (path) {
        var self = this,
            fs = require("fs");
        if (fs.existsSync(path)) {
            fs.readdirSync(path).forEach(function (file, index) {
                var curPath = path + "/" + file;
                if (fs.lstatSync(curPath).isDirectory()) { // recurse
                    self.deleteFolderRecursive(curPath);
                } else { // delete file
                    fs.unlinkSync(curPath);
                }
            });
            fs.rmdirSync(path);
        }
    },

    deleteFolderContentsRecursive: function (path) {
        var self = this,
            fs = require("fs");
        if (fs.existsSync(path)) {
            fs.readdirSync(path).forEach(function (file, index) {
                var curPath = path + "/" + file;
                if (fs.lstatSync(curPath).isDirectory()) { // recurse
                    self.deleteFolderContentsRecursive(curPath);
                } else { // delete file
                    fs.unlinkSync(curPath);
                }
            });
        }
    },

    clone: function (obj) {
        var self = this;

        if (obj === null || typeof obj !== 'object') {
            return obj;
        }

        var temp = obj.constructor();
        for (var key in obj) {
            temp[key] = self.clone(obj[key]);
        }

        return temp;
    },

    escapeRegExp: function (str) {
        return str.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&");
    },

    getJson: function (file, defaultValue) {
        var fs = require("fs");
        var rs = {};
        try {
            rs = JSON.parse(fs.readFileSync(file, 'utf8'));
        } catch (e) {
            if (defaultValue) {
                return defaultValue;
            }

            this.error("Not able to find " + file);
        }

        return rs;
    },

    extend: function (target, source) {
        var _ = require("underscore");
        // Uncommented section below since strings are not overridden by source
        // for (var prop in source) {
        //     if (prop in target) {
        //         _.extend(target[prop], source[prop]);
        //     } else {
        //         target[prop] = source[prop];
        //     }
        // }
        // return target;
        return _.extend(target, source);
    },

    getTime: function () {
        var curTime = new Date();

        function pad2(n) {
            return (n < 10 ? '0' : '') + n;
        }

        return curTime.getFullYear() +
            pad2(curTime.getMonth() + 1) +
            pad2(curTime.getDate()) +
            "T" +
            pad2(curTime.getHours()) +
            pad2(curTime.getMinutes()) +
            pad2(curTime.getSeconds());
    },

    execSync: function(cmd) {
        var execSync = require('child_process').execSync,
            buf,
            res = "";
        try {
            buf = execSync(cmd);
            res = buf.toString().trim();
        } catch(err) {
            this.error(err.toString());
        }
        return res;
    },

    execPromise: function(command) {
        var defer = require('node-promise/promise').defer,
            exec = require('child_process').exec,
            deferred = defer();
        exec(command, function execCallback(error, stdout, stderr) {
            if (!error) {
                deferred.resolve(stdout);
            } else {
                this.error(error.toString());
                deferred.reject(error);
            }
        }.bind(this));
        return deferred;
    },

    getDistributionName: function(config) {
        var version = this.getVersionName(config),
            time = this.getTime();
        return config.applicationName.replace(" ", "-").toLowerCase() + "_" + version + "_" + global.APP_ENV + "_" + time;
    },

    getBuildNumber: function() {
        var cmd = "git rev-list HEAD --count";
        return this.execSync(cmd);
    },

    getVersionName: function(config) {
        return config.versionMajor + "." + config.versionMinor + "b" + this.getBuildNumber();
    },
};
