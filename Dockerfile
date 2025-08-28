FROM ruby:3.3.6-slim

# Install essential packages for building native extensions and PostgreSQL client
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  build-essential \
  libpq-dev \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

ARG RAILS_ENV=${RAILS_ENV}
ARG DB_HOST=${DB_HOST}
ARG DB_PORT=${DB_PORT}
ARG DB_USER=${DB_USER}
ARG DB_PASS=${DB_PASS}

ENV DB_HOST=$DB_HOST
ENV DB_PORT=$DB_PORT
ENV DB_USER=$DB_USER
ENV DB_PASS=$DB_PASS

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
COPY entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["./entrypoint.sh"]
CMD ["bin/rails", "server", "-b", "0.0.0.0"]