# Supabase

Prerequisites:
https://nodejs.org/en/download/prebuilt-installer
https://docs.docker.com/desktop/setup/install/windows-install/ (To run locally)

## Commands must be run from cloud folder. To install supabase
- `npm install supabase --save-dev`

## Create new function
Replace hello-world with the new function name:
- `npx supabase functions new hello-world`
## Setup Local .env variables
Copy variables from .env.placeholder into a new file .env.development and insert the value
Values must not be comitted to git and thats why the file is ignored.
All keys must be added to .env.placerholder so we know which env variables we have,

## Run Locally
Make sure you have docker installed
- `npx supabase start`
- `npx supabase functions serve --env-file ./supabase/.env.development`

## Deploy manuallu
- `npx supabase functions deploy` -Deploys all
- `npx supabase functions deploy hello-world` - Deploys a single function



