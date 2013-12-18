So Nice ♫
=======

> Everynight with my star friends
>
> We eat caviar and drink champage

A small Web interface to play, pause, change volume or skip the currently
playing song in iTunes Mac, iTunes Windows, Spotify Mac, MPD, Rhythmbox, Amarok and XMMS2.

![Screenshot](https://github.com/sunny/so-nice/raw/gh-pages/screenshot.png)


Setup
-----

With ruby, the bundler gem (`gem install bundler`) and git, you can install it this way:

```bash
$ git clone git://github.com/sunny/so-nice.git
$ cd so-nice
$ bundle install
```

Launch it with:

```bash
$ bundle exec thin start
```

Then visit [http://localhost:3000](http://localhost:3000)


Configuration
-------------

The configuration options are at the top of the `config.ru` file (all settings are enabled by default):

- `SONICE_CONTROLS` to disable on-screen controls
- `SONICE_VOTING` to disable voting


Players
-------

Supports iTunes Mac, iTunes Windows, Spotify Mac, Rdio Mac, MPD, Rhythmbox, Amarok and XMMS2 thanks to [anyplayer](https://github.com/sunny/anyplayer).


Contribute
----------

Feel free to help with the development by submitting issues and pull requests [on github](https://github.com/sunny/so-nice).

Licenced under the [WTFPL](http://sam.zoy.org/wtfpl/), made by [these awesome contributors](https://github.com/sunny/so-nice/contributors).
