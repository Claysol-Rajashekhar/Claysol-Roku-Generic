Claysol SDK Roku
=====================================

- - - -

# Build Tools

Required tools are node.js and gulp

```
$ npm install -g gulp-cli
$ npm install
```

## App Configuration
Will be set in the file `configs/[app name]/[environment].config.json`
```
"ENVIRONMENT"               {String} environment variable
```

## Build Configuration
Will be set in the file `configs/[app name]/custom.gulp.config.json`. Overrides to `gulp/default.gulp.config.json`.
```
{
    "applicationName": "Claysol-Roku-Generic",  // the name of the application. will be used in manifest and build name.
    "versionMajor": "0",
    "versionMinor": "1",
    "rokuIp": "",               // the ip of the roku device on your network that you want to upload the builds to.
    "rokuPassword": "",         // the development password for "rokudev" on your roku box
    "developerIdPackage": "package/build.pkg",  // the path to a previous build that can be used for rekeying your roku
    "developerIdPassword": "",  // the developer id password for the build defined in developerIdPackage
    "distIncludes": [           // list of paths that will be included in the zip package
        "./src/main/**"
    ],
    "manifest": {               // variables that will be included in the manifest
        "mm_icon_focus_hd": "pkg:/images/logo/logoHD.png",
        "mm_icon_side_hd": "pkg:/images/logo/logoHD.png",
        "mm_icon_focus_sd": "pkg:/images/logo/logoSD.png",
        "mm_icon_side_sd": "pkg:/images/logo/logoSD.png",
        "splash_screen_sd": "pkg:/images/splashScreen/splashSD.jpg",
        "splash_screen_hd": "pkg:/images/splashScreen/splashHD.jpg",
        "splash_screen_fhd": "pkg:/images/splashScreen/splashFHD.jpg"
    }
}
```


## Tasks
Run app foo in environment bar on Roku with IP 192.168.1.2 and password dev
```
gulp run --app=foo --env=bar --ip=192.168.1.2 --password=dev
```
(Default configs for IP and password can be set in custom.gulp.config.json)

Package app foo in environment bar on Roku with IP 192.168.1.2 and password dev
```
gulp build --app=foo --env=bar --ip=192.168.1.2 --password=dev
```


