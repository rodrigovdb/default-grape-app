FROM ruby:3.2.0

MAINTAINER Rodrigo VDB "rodrigovdb@gmail.com"

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

RUN gem install bundler

ENV INSTALL_PATH /var/app
RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

COPY .env Gemfile* $INSTALL_PATH/
RUN bundle install --jobs 20

EXPOSE 3000

# CMD ["bundle", "exec", "rackup", "-o", "0.0.0.0", "-p", "3000"]
CMD ["bundle", "exec", "puma", "-p", "3000", "-C", "config/puma.rb"]
