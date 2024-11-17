# Supabase

Prerequisites:
https://nodejs.org/en/download/prebuilt-installer
https://docs.docker.com/desktop/setup/install/windows-install/ (To run locally)

## Commands must be run from cloud folder. To install supabase
npm install supabase --save-dev

## Create new function
Replace hello-world with the new function name:
npx supabase functions new hello-world

## Setup Local .env variables
use .env.placeholder and 

## Run Locally
Make sure you have docker installed
npx supabase start
npx supabase functions serve --env-file ./supabase/.env



