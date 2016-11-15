# Hel Face · [![Build Status](https://travis-ci.org/hel-repo/hel-face.svg?branch=master)](https://travis-ci.org/hel-repo/hel-face)
HEL Repository web interface. Allows one to search, view, create and edit packages.
Easy way to distribute and deploy your OpenComputers application.

## Usage
Just open this link in your favorite browser:

https://hel.fomalhaut.me/  (dev build, may be buggy)

If you are writing a custom Hel client, you can use Hel API by this address:

https://hel-roottree.rhcloud.com/

Please, refer to [wiki](https://github.com/hel-repo/hel/wiki) for details about API interaction.

## Contributing
You will need to install a [create-elm-app](https://github.com/halfzebra/create-elm-app) bundler tool (which will install appropriate [Elm compiler](http://elm-lang.org/) version).

Then you would be able to run and build source code from project directory with following commands:

#### `elm-app start`
Runs the app in the development mode.
Open [http://localhost:3000](http://localhost:3000) to view it in the browser.

The page will reload if you make edits.
You will also see any lint errors in the console.

#### `elm-app build`
Builds the app for production to the `dist` folder.

The build is minified and the filenames include the hashes.