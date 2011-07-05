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

    $ git clone git://github.com/sunny/so-nice.git
    $ cd so-nice
    $ bundle install

The configuration options are at the top of the `config.ru` file (all settings are enabled by default):

* `ENV['SONICE_CONTROLS']` enables/disables on screen controls
* `ENV['SONICE_VOTING']` enables/disables voting

Launch it with:

    $ thin start -p 4567 -R config.ru

Then visit [http://localhost:4567](http://localhost:4567)


Licence
-------

[WTFPL](http://sam.zoy.org/wtfpl/),
[Contributors](https://github.com/sunny/so-nice/contributors)
