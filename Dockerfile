# ./Dockerfile

# Extend from the official Elixir image
FROM elixir:latest

RUN apt-get update -y -qq
RUN apt-get install postgresql-client-11 -y -qq
RUN apt-get install inotify-tools -y -qq

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs

# Create app directory and copy the Elixir projects into it
RUN mkdir /app
COPY . /app
WORKDIR /app

# Install hex package manager
# By using --force, we don’t need to type “Y” to confirm the installation
RUN mix local.rebar --force
RUN mix local.hex --force

# Compile the project
RUN mix deps.get
RUN mix do compile

WORKDIR /app/apps/cronitex_web/assets
RUN npm install 

WORKDIR /app

CMD ["/app/entrypoint.sh"]