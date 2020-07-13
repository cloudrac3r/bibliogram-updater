# Bibliogram updater

A collection of scripts to easily install and update Bibliogram.

## Quick start

`git clone https://git.sr.ht/~cadence/bibliogram-updater`

Run `./run.fish` to run Bibliogram, and to install it and its requirements if they don't already exist. Updates will be installed automatically.

Run `./clean.fish` to clean up the installation.

## After installing

You may want to do some of these things:

- [Learn how to make Bibliogram available on the public internet](https://git.sr.ht/~cadence/bibliogram-docs/tree/master/docs/Installing%20(extended).md#making-bibliogram-accessible-from-outside)
- [Add your public instance to the instance list](https://git.sr.ht/~cadence/bibliogram-docs/tree/master/docs/Instances.md)
- [Look at all of the configuration options](https://github.com/cloudrac3r/bibliogram/wiki/Configuring)
- [Write a privacy policy for your users](https://git.sr.ht/~cadence/bibliogram/tree/master/src/site/pug/privacy.pug.template)
- [Join the discussion room on Matrix: #bibliogram:matrix.org](https://matrix.to/#/#bibliogram:matrix.org)
- [Browse the documentation](https://git.sr.ht/~cadence/bibliogram-docs/tree/master/docs)
- Tell your friends to run Bibliogram too

## It didn't work!

Please open an issue so I can fix it! Please tell me as much information as possible, most importantly the command you ran and the output on the console.

If you don't like GitHub, you can [talk to me privately,](https://cadence.moe/about/contact) or [join the discussion room on Matrix: #bibliogram:matrix.org](https://matrix.to/#/#bibliogram:matrix.org)

## What's a fish?

The scripts are written in fish. You'll need to install fish: https://fishshell.com/

You do not have to set fish as your default shell. The scripts have `#!` lines, which makes them run in fish no matter what shell you are using.

If you want to port this to bash, please go ahead! I would have written it in bash originally for convenience, but I don't know bash.

## What do the scripts do?

`run.fish`

1. It will update itself if an update is available.
1. If Bibliogram isn't already installed, it will run `install.fish`.
1. It will update Bibliogram.
1. It will run Bibliogram.
1. It will attempt to update Bibliogram from Git. If the update is successful, it will restart Bibliogram.

`install.fish`

1. It will check that `git`, `wget` and `nc` are available, and will ask you to install them if they aren't.
1. If `node` isn't installed, it will download a copy to use from then on.
1. It will clone the Bibliogram repo.
1. It will run `npm install`.
1. It will guide you through setting up `website_origin`, `port`, `feeds/enabled`, and `does_not_track`.
1. It will send you back to `run.fish`.

`clean.fish`

1. It will ask you for confirmation, then delete any files and directories that the other scripts created.
