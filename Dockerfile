FROM ruby

# add dumb-init
ENV INIT_VER="1.2.2"
ENV INIT_SUM="37f2c1f0372a45554f1b89924fbb134fc24c3756efaedf11e07f599494e0eff9"
ADD https://github.com/Yelp/dumb-init/releases/download/v${INIT_VER}/dumb-init_${INIT_VER}_amd64 /du
mb-init
RUN echo "$INIT_SUM  dumb-init" | sha256sum -c -
RUN chmod +x /dumb-init

COPY ./build /fastladder
COPY ./database.yml /fastladder/config/database.yml
COPY ./secrets.yml /fastladder/config/secrets.yml

ENV PORT=3001
ENV RAILS_ENV=production

WORKDIR /fastladder

# build
RUN apt update && apt install -y nodejs
RUN bundle -j9 && \
    bundle exec rake assets:precompile

EXPOSE 3001
ENTRYPOINT ["/dumb-init", "--"]
