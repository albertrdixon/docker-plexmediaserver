FROM ubuntu:utopic
MAINTAINER Albert Dixon <albert@timelinelabs.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq
RUN apt-get install --no-install-recommends -y --force-yes \
    ruby gettext-base git curl wget ca-certificates &&\
    apt-get autoclean -y &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN gem install --minimal-deps --no-document --clear-sources clockwork &&\
    gem cleanup

RUN git clone git://github.com/albertrdixon/plexupdate.git /tmp/plexupdate &&\
    chmod 755 /tmp/plexupdate/plexupdate.sh &&\
    mv -vf /tmp/plexupdate/plexupdate.sh /usr/local/bin/ &&\
    rm -rf /tmp/plexupdate

ADD configs/* /root/
ADD scripts/clock.rb /root/
ADD scripts/docker-start /usr/local/bin/
RUN bash -c "chmod a+rx /usr/local/bin/*" &&\
    mkdir -p /plexupdate

ENTRYPOINT ["docker-start"]
EXPOSE 32400 1900 5353 32410 32412 32413 32414 32469

ENV PP_DOWNLOAD_DIR   /plexupdate
ENV PP_KEEP           no
ENV PP_FORCE          no
ENV PP_PUBLIC         no
ENV PP_AUTOINSTALL    yes
ENV UPDATE_TIME       1:00