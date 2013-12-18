So Nice ♫
=======

[![Gem Version](https://badge.fury.io/rb/sonice.png)](http://badge.fury.io/rb/sonice)

> “Everynight with my star friends, we eat caviar and drink champage”

A small Web interface to play, pause, change volume or skip the currently
playing song in iTunes Mac, iTunes Windows, Spotify Mac, MPD, Rhythmbox, Amarok and XMMS2.

![Screenshot](https://github.com/sunny/so-nice/raw/gh-pages/screenshot.png)


Install
-------

Make sure you have Ruby and Rubygems installed. You can then type in a terminal:

```bash
$ gem install sonice
```

Launch it with:

```bash
$ sonice
```

Then visit [http://localhost:3000](http://localhost:3000)


Configuration
-------------

You can launch `sonice` with these environment options:

- `SONICE_CONTROLS=0` to disable on-screen controls
- `SONICE_VOTING=0` to disable voting
- `SONICE_PORT=12345` to change port (default 3000)

Example:

```bash
$ SONICE_CONTROLS=0 SONICE_VOTING=0 sonice
```

If you don't want to type them all the time, add them to your `.bashrc`:

```bash
export SONICE_CONTROLS=0
export SONICE_VOTING=0
```


Players
-------

Supports iTunes Mac, iTunes Windows, Spotify Mac, Rdio Mac, MPD, Rhythmbox, Amarok and XMMS2 thanks to [anyplayer](https://github.com/sunny/anyplayer).


Development Setup
------------------

With bundler (`gem install bundler`) and git, get the code and get started:

```bash
$ git clone https://github.com/sunny/so-nice
$ cd so-nice
$ bundle install
```

Launch the binary with:

```bash
$ ruby -Ilib bin/sonice
```

Contribute
----------

Feel free to help with the development by submitting issues and pull requests [on github](https://github.com/sunny/so-nice).

Licenced under the [WTFPL](http://sam.zoy.org/wtfpl/), made by [these awesome contributors](https://github.com/sunny/so-nice/contributors).
