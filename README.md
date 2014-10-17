## Snapshot Application

### Overview

This is a simple unicorn wrapper around [Shutterbug](https://github.com/concord-consortium/shutterbug), which makes Shutterbug available on Heroku.  This project also includes buildpack references for [multi-build-pack](https://github.com/ddollar/heroku-buildpack-multi.git) and [phantom](https://github.com/stomita/heroku-buildpack-phantomjs) for [PhantomJS](http://phantomjs.org/) dependencies.

### Deploying &etc.

Deployment to heroku is done using git push.  We configure 3 remotes in git:

1. Github -- hosted scm.
1. Heroku Staging  -- staging server deployments.
1. Heroku Production -- production server deployments.

You should have a `.git/config` file which looks sort of like this, so that you can push to all those places:

    [remote "origin"]
            url = git@github.com:concord-consortium/snapshot_app.git
            fetch = +refs/heads/*:refs/remotes/origin/*
    [remote "heroku"]
            url = git@heroku.com:shutterbug.git
            fetch = +refs/heads/*:refs/remotes/heroku/*
    [remote "heroku-dev"]
            url = git@heroku.com:shutterbug-dev.git
            fetch = +refs/heads/*:refs/remotes/heroku/*
    [branch "master"]
            remote = origin
            merge = refs/heads/master

When you want to push changes from master to github `git push` should do the right thing.

When you want to deploy to staging: `push heroku-dev <branch>:master` will do the job 
or just `push heroku-dev master` if you are just deploying the master branch.

When you are ready for the bigtime: `push heroku master`.

----
[MIT License](LICENSE.md)