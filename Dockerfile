FROM ruby
RUN apt update && apt install -y nodejs
COPY ./build /fastladder
WORKDIR /fastladder
RUN bundle -j9
RUN gem install foreman
ENV PORT=3001 RAILS_ENV=production
RUN ./bin/rake assets:precompile
COPY ./database.yml /fastladder/config/database.yml
COPY ./secrets.yml /fastladder/config/secrets.yml
EXPOSE 3001
CMD foreman start -p $PORT

