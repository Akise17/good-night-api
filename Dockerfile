FROM ruby:3.3.6-slim

# Install essential packages for building native extensions and PostgreSQL client
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  build-essential \
  libpq-dev \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
COPY entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["./entrypoint.sh"]
CMD ["bin/rails", "server", "-b", "0.0.0.0"]