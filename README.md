# Contacts Importer

A Ruby on rails application to import CSV files, parse its contents and add contacts.
Database: Postgresql
Background jobs proccesing via Sidekiq
CSV file import and parsing features

## Setup

1. Clone the repository
  `git clone git@github.com:brymopo/contact_importer.git`

2. Install all required dependencies
   `bundle install`

3. (Optional) Customize db/seeds.rb file

4. Set up the database
   `rails db:setup`

5. Start the server in development
   `rails s`

## A note on Encryption

This application implements credit card encryption via Public Key and decryption with a private key.

There is already a public key provided in this repository (The private key is excluded for security reasons)

If you wish to generate an RSA key pair of your one, feel free to do so; however, make sure to include the private key in the config folder as "public.pem".
