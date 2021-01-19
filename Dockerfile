ARG ARCH=
FROM ${ARCH}erseco/alpine-php7-webserver

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Moodle on Alpine Linux with Nginx and PHP7" \
      org.label-schema.description="Moodle 3.x on Alpine Linux with Nginx 1.16 and PHP7 fpm" \
      org.label-schema.url="https://www.snat.tech" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/pkostelnik/alpine-moodle" \
      org.label-schema.vendor="SNaT - Services Networking and Technology" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0" \
      maintainer="Pawel Kostelnik <pkostelnik@snat.tech>"

USER root
COPY --chown=nobody rootfs/ /

# crond needs root, so install dcron and cap package and set the capabilities
# on dcron binary https://github.com/inter169/systs/blob/master/alpine/crond/README.md
RUN apk add --no-cache dcron libcap && \
    chown nobody:nobody /usr/sbin/crond && \
    setcap cap_setgid=ep /usr/sbin/crond

USER nobody

# Change v3.10.1.tar.gz for new versions
ENV MOODLE_URL=https://github.com/moodle/moodle/archive/v3.10.1.tar.gz \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    SITE_URL=http://localhost \
    DB_TYPE=pgsql \
    DB_HOST=postgres \
    DB_PORT=5432 \
    DB_NAME=moodle \
    DB_USER=moodle \
    DB_PASS=moodle \
    DB_PREFIX=mdl_ \
    SSLPROXY=false \
    MOODLE_EMAIL=user@example.com \
    MOODLE_LANGUAGE=en \
    MOODLE_SITENAME=New-Site \
    MOODLE_USERNAME=moodleuser \
    MOODLE_PASSWORD=PLEASE_CHANGEME \
    SMTP_HOST=smtp.gmail.com \
    SMTP_PORT=587 \
    SMTP_USER=your_email@gmail.com \
    SMTP_PASSWORD=your_password \
    SMTP_PROTOCOL=tls \
    MOODLE_MAIL_NOREPLY_ADDRESS=noreply@localhost \
    MOODLE_MAIL_PREFIX=[moodle] \
    client_max_body_size=50M \
    post_max_size=50M \
    upload_max_filesize=50M \
    max_input_vars=1000

RUN curl --location $MOODLE_URL | tar xz --strip-components=1 -C /var/www/html/

