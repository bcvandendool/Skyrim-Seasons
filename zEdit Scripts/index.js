/* global ngapp, xelib, registerPatcher, patcherUrl */

// this patcher doesn't do anything useful, it's just a heavily commented
// example of how to create a UPF patcher.
registerPatcher({
    info: info,
    // array of the game modes your patcher works with
    // see docs://Development/APIs/xelib/Setup for a list of game modes
    gameModes: [xelib.gmSSE, xelib.gmTES5],
    settings: {
        // The label is what gets displayed as the settings tab's label
        label: 'Skyrim-Seasons',
        // if you set hide to true the settings tab will not be displayed
        //hide: true,
        templateUrl: `${patcherUrl}/partials/settings.html`,
        // controller function for your patcher's settings tab.
        // this is where you put any extra data binding/functions that you
        // need to access through angular on the settings tab.
        controller: function($scope) {
            let patcherSettings = $scope.settings.matorsExamplePatcher;

            // function defined on the scope, gets called when the user
            // clicks the Show Message button via ng-click="showMessage()"
            $scope.showMessage = function() {
                alert(patcherSettings.exampleSetting);
            };
        },
        // default settings for your patcher.  use the patchFileName setting if
        // you want to use a unique patch file for your patcher instead of the
        // default zPatch.esp plugin file.  (using zPatch.esp is recommended)
        defaultSettings: {
            modDirectory: 'default',
            //patchFileName: 'examplePatch.esp'
        }
    },
    // optional array of required filenames.  can omit if empty.
    requiredFiles: [],
    getFilesToPatch: function(filenames) {
        // Optional.  You can program strict exclusions here.  These exclusions
        // cannot be overridden by the user.  This function can be removed if you 
        // don't want to hard-exclude any files.
        //let gameName = xelib.GetGlobal('GameName');
        return filenames.subtract([`Dragonborn.esm`]);
    },
    execute: (patchFile, helpers, settings, locals) => ({
        initialize: function() {

            settings.modDirectory = fh.selectDirectory('Please select the install location of Skyrim-Seasons', settings.modDirectory)

            locals.obj = {
                string: {
                    lodchange: 'False',
                    moddirectory: settings.modDirectory
                },
                stringList: {
                    lodlist: [],
                    texturesetlist: [],
                    worldmodellist: []
                }
            };

        },
        // required: array of process blocks. each process block should have both
        // a load and a patch function.
        process: [{
            load: {
                signature: 'GRAS'
            },
            patch: function(record) {
                //helpers.logMessage(`Looking at ${xelib.LongName(record)}`);
                locals.obj.stringList.worldmodellist.push(xelib.GetFileName(xelib.GetElementFile(xelib.GetMasterRecord(record))) + ';' + xelib.GetFormID(xelib.GetMasterRecord(record)) + ';' + xelib.GetValue(xelib.GetWinningOverride(record), 'Model\\MODL - Model Filename'));
            }
        }, {
            load: {
                signature: 'LTEX'
            },
            patch: function(record) {
                //helpers.logMessage(`Looking at ${xelib.LongName(record)}`);
                if(xelib.GetUIntValue(xelib.GetWinningOverride(record), 'TNAM - Texture Set') != 0)
                {
                    var textureSet = xelib.GetRecord(xelib.GetElementFile(xelib.GetWinningOverride(record)), xelib.GetUIntValue(xelib.GetWinningOverride(record), 'TNAM - Texture Set'));
                    locals.obj.stringList.texturesetlist.push(xelib.GetFileName(xelib.GetElementFile(xelib.GetMasterRecord(record))) + ';' + xelib.GetFormID(xelib.GetMasterRecord(record)) + ';' + xelib.GetValue(xelib.GetWinningOverride(textureSet), 'Textures (RGB/A)\\TX00 - Difuse') + '|' + xelib.GetValue(xelib.GetWinningOverride(textureSet), 'Textures (RGB/A)\\TX01 - Normal/Gloss'));
                }
            }
        }, {
            load: {
                signature: 'TREE'
            },
            patch: function(record) {
                //helpers.logMessage(`Looking at ${xelib.LongName(record)}`);
                locals.obj.stringList.worldmodellist.push(xelib.GetFileName(xelib.GetElementFile(xelib.GetMasterRecord(record))) + ';' + xelib.GetFormID(xelib.GetMasterRecord(record)) + ';' + xelib.GetValue(xelib.GetWinningOverride(record), 'Model\\MODL - Model Filename'));
            }
        }],
        finalize: function() {
            
            var json = JSON.stringify(locals.obj);
            var fs = require('fs');
            fs.writeFile('test.json', json, 'utf8', function(error) {
                if(error) throw error;
            });

        }
    })
});