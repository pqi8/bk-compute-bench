#!/usr/bin/env bash
. "$(dirname "$0")/lib.sh"
docker run -d --name pg -e POSTGRES_PASSWORD=test -p 5432:5432 postgres:16
$SUDO apt-get update -qq && $SUDO apt-get install -y -qq libpq-dev libyaml-dev > /dev/null
mise use -g ruby@3.4
gem install --no-document rails -v "~> 8.0"
rails new demo --database=postgresql --skip-git --skip-javascript --skip-docker --quiet && cd demo
bin/rails generate scaffold Post title:string body:text --quiet
until docker exec pg pg_isready -U postgres; do sleep 1; done
export DATABASE_URL=postgres://postgres:test@127.0.0.1:5432/demo_test RAILS_ENV=test
bin/rails db:create db:migrate
bin/rails test
