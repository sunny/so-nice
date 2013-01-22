So Nice ♫
=======

> Everynight with my star friends
> We eat caviar and drink champage

A small Web interface to play, pause, change volume or skip the currently
playing song in iTunes, MPD, Rhythmbox, XMMS2 or Amarok.

![Screenshot](https://github.com/sunny/so-nice/raw/gh-pages/screenshot.png)


Setup
-----

With ruby, rubygems, the bundler gem (`gem install bundler`) and git, you can install it this way:

```bash
$ git clone git://github.com/sunny/so-nice.git
$ cd so-nice
$ bundle install
```

Launch it with:

```bash
$ thin start
```

Then visit [http://localhost:3000](http://localhost:3000)


Configuration
-------------

The configuration options are at the top of the `config.ru` file (all settings are enabled by default):

* `ENV['SONICE_CONTROLS']` enables/disables on screen controls
* `ENV['SONICE_VOTING']` enables/disables voting
* `ENV['SONICE_OVERLAY']` enables/disables background overlay


Licence
-------

[WTFPL](http://sam.zoy.org/wtfpl/),
[Contributors](https://github.com/sunny/so-nice/contributors)

