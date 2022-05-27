# Generating GraphQL interface

## Prerequistes

* Homebrew
* NodeJS (`brew install node`)
* GraphQL Schema (`npm install -g get-graphql-schema`)

## Generating GraphQL schema

Run:

`get-graphql-schema http://127.0.0.1:4000 --json > schema.json`

Use the production/staging server if not running the server locally.

Build the WhoppahCore project, it will automatically generate a swift file from the schema