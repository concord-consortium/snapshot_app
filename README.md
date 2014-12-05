## Snapshot Application

### Overview

This is a simple unicorn wrapper around [Shutterbug](https://github.com/concord-consortium/shutterbug), which makes Shutterbug available on Heroku.  This project also includes buildpack references for [multi-build-pack](https://github.com/ddollar/heroku-buildpack-multi.git) and [phantom](https://github.com/stomita/heroku-buildpack-phantomjs) for [PhantomJS](http://phantomjs.org/) dependencies.

### Deploying with Docker locally using Fig ###

1. Install [boot2docker](https://github.com/boot2docker/osx-installer/releases)
2. Install Fig `sudo pip install fig`
3. Run `boot2docker up`
4. Copy the IP address from `boot2docker ip` into `/etc/hosts` as some alias.  The ip address of the boot2docker host isn't likely to change very frequently.
5. Export your AWS S3 credentials. `export S3_KEY=xxx`, `export S3_SECRET=xxx`
6. Run `fig up`
7. Run `open http://<dockerip-or-alias>:8888/index.html` 

### Docker: deploying locally ###

1. install [boot2docker](https://github.com/boot2docker/osx-installer/releases)
2. run `boot2docker up`
2. work around some existing [NTP boot2docker issues](https://github.com/boot2docker/boot2docker/issues/290) using either:
     
        boot2docker ssh "sudo killall -9 ntpd; sudo ntpclient -s -h pool.ntp.org && sudo ntpd -p pool.ntp.org"

     *or*

        wget -q https://gist.githubusercontent.com/fcvarela/2c90b090e1e5f8c91127/raw/1e63833d4ec7edea98298204a0c26f79ead3db8e/com.fcvarela.boot2docker.datesync.plist -O \
        ~/Library/LaunchAgents/com.fcvarela.boot2docker.datesync.plist \
        && launchctl load ~/Library/LaunchAgents/com.fcvarela.boot2docker.datesync.plist \
        && launchctl start com.fcvarela.boot2docker.datesync

3. generate the docker image `docker build -t knowuh/snapshot_app .` (knowuh/snapshot_app is what I have 'tagged' my local image as … TBD)
4. find the local IP address of your docker server: `boot2docker ip`
4. Run the image, forwarding ports, and configuring ENV vars

        docker run \
        -e "S3_KEY=xxxxxxx" \
        -e "S3_SECRET=xxxxxx" \
        -e "S3_BIN=ccshutterbug" \
        -e "SB_SNAP_URI=http://<docker local ip>/" \
        -d -p 80:8888 knowuh/snapshot_app


### Deploying to Amazon Elastic Beanstalk using EB CLI ###

The following summarizes a much more [detailed instructions hosted on AWS](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3-getting-set-up.html)

1. Install the EBS command line client: `sudo pip install awsebcli`
2. Initialize the project `eb init`
3. Create a deployment `eb create development`
4. Change code, commit, and redeploy: `eb deploy`


### Heroku Deploying &etc.

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