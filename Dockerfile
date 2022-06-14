# Dockerfile - alpine

ARG IMAGE_BASE="alpine"
ARG IMAGE_TAG="3.15.4"

FROM ${IMAGE_BASE}:${IMAGE_TAG}

LABEL maintainer="lengyuewusheng<bsxlyws@163.com>"

USER root

WORKDIR /root

RUN apk update \
    && apk add --no-cache --progress ca-certificates tzdata sysstat procps lsof strace tcpdump paris-traceroute-ping vim bash rsync curl iproute2 alpine-base coreutils bind-tools tini shadow logrotate \
    && cp -v /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" >  /etc/timezone \
    && apk del tzdata \
    && rm -rvf /var/cache/apk/* \
    && echo "alias ll='ls -l --color=auto'" >> /etc/profile.d/alias.sh \
    && echo "alias tailf='tail -f'" >> /etc/profile.d/alias.sh \
    && echo "HISTSIZE=3000" >> /etc/profile.d/tty_rc.sh \
    && echo "HISTFILESIZE=3000" >> /etc/profile.d/tty_rc.sh \
    && echo 'HISTTIMEFORMAT="%Y-%m-%d %T  "' >> /etc/profile.d/tty_rc.sh \
    && echo 'PS1="[\u@\H:\w]\$ "' >> /etc/profile.d/tty_rc.sh \
    && echo -e "# .bashrc\nsource /etc/profile" >> ${HOME}/.bashrc \
    && sed -i 's/\/bin\/ash$/\/bin\/bash/g' /etc/passwd \
    && unlink /bin/sh \
    && ln -svf /bin/bash /bin/sh \
    && addgroup -g 10001 -S odin \
    && adduser -u 10001 -S -G odin -h /home/odin odin \
    && mv /etc/periodic/daily/logrotate /etc/periodic/hourly/ \
    && mkdir -pv /var/log/crond \
    && touch /var/log/messages

ENV ENV='/etc/profile'

COPY vimrc /etc/vim/vimrc
COPY logrotate.d/ /etc/logrotate.d/

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/bin/bash"]
