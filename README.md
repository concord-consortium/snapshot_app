## Snapshot Application

### Overview

This is a simple unicorn wrapper around [Shutterbug](https://github.com/concord-consortium/shutterbug), which makes Shutterbug available on Heroku.  This project also includes DEPRECATED buildpack references for [multi-build-pack](https://github.com/ddollar/heroku-buildpack-multi.git) and [phantom](https://github.com/stomita/heroku-buildpack-phantomjs) for [PhantomJS](http://phantomjs.org/) dependencies.

### Testing locally using docker-compose ###

1. Install [boot2docker](https://github.com/boot2docker/osx-installer/releases)
2. Install docker-compose ``curl -L https://github.com/docker/compose/releases/download/1.1.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose``
3. Run `boot2docker up`
4. Copy the IP address from `boot2docker ip` into `/etc/hosts` as some alias.  The ip address of the boot2docker host isn't likely to change very frequently.
5. Export your AWS S3 credentials. `export S3_KEY=xxx`, `export S3_SECRET=xxx` or put your credentials in `./.env` here.
6. Build your image `docker-compose build`
7. Run your container `docker-compose up`
8. Run `open http://<dockerip-or-alias>:80/index.html` 
9. You can run one-of commands in your named containers like this: `docker-compose run web bash`
10. read more [docker-compose documentation](https://docs.docker.com/compose/) for more info.
11. because we mount a volume in the container, changes to this working directory are reflected in the container immediately.


### Deploying to Amazon Elastic Beanstalk using EB CLI ###

The following summarizes a much more [detailed instructions hosted on AWS](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3-getting-set-up.html)

1. Install the EBS command line client: `sudo pip install awsebcli`
2. Initialize the project `eb init`
3. Create a deployment `eb create development`
4. Change code, commit, and redeploy: `eb deploy`


### Heroku Deploying (mostly deprecated)

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

### License: ###

SnapshotApp is released under the [MIT License.](LICENSE.md)