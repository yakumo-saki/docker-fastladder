FROM ruby:2.7-bullseye

COPY ./build /fastladder
COPY ./database.yml /fastladder/config/database.yml
COPY ./secrets.yml /fastladder/config/secrets.yml

ENV PORT=3001
ENV RAILS_ENV=production

WORKDIR /fastladder

# build
# hadolint ignore=DL3008
RUN apt-get update --no-install-recommends \
    && apt-get install -y tini nodejs \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN bundle -j9 && \
    bundle exec rake assets:precompile

EXPOSE 3001
ENTRYPOINT ["tini", "--"]
