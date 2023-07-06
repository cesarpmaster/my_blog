FROM ruby:3.2-alpine

RUN apk update; \
    apk add --no-cache --virtual .build-deps \
      build-base \
      linux-headers \
      vim \
      git \
      tzdata \
      postgresql-dev \
      postgresql-client \
      bash \
      yarn \
      less \
      imagemagick \
      gcompat \
      chromium \
      chromium-chromedriver \
      openssh-client

ARG U_NAME=docker
ARG U_UID=1000
ARG U_GID=1000

RUN addgroup \
      --system \
      --gid "${U_GID}" \
      "${U_NAME}"

RUN adduser \
      --disabled-password \
      --system \
      --gecos "" \
      --ingroup "${U_NAME}" \
      --uid "${U_UID}" \
      "${U_NAME}"

USER "${U_UID}:${U_GID}"

ENV EDITOR vim

ENV HOME_PATH "/home/${U_NAME}"

ENV GEM_HOME "${HOME_PATH}/ruby_gems"
ENV GEM_PATH "${GEM_HOME}"
ENV BUNDLE_PATH "${GEM_HOME}"

ENV PATH "${GEM_HOME}/bin:${GEM_HOME}/ruby/3.2.0/bin:${PATH}"

RUN mkdir -p "${HOME_PATH}/.ssh"
RUN mkdir -p "${GEM_HOME}"

ENV APP_PATH "${HOME_PATH}/my_blog"

COPY --chown="${U_UID}:${U_GID}" . "${APP_PATH}"

WORKDIR "${APP_PATH}"

RUN gem install bundler
RUN git config --global http.sslVerify false

RUN bundle install \
      --jobs `expr $(cat /proc/cpuinfo | grep -c "cpu cores") - 1` \
      --retry 3

RUN yarn install --check-files

EXPOSE 3000:3000
EXPOSE 3035:3035

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
