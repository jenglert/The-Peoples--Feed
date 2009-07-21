# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_peoplesfeed_session',
  :secret      => '1aad814798f963fa65d986b5cf898ff4c4a9a0c49e4806b0080278c23ec0d4c3c1b5c73d1a21d4a770b6c44bc6f78ab98f31a2fccfe67581174b00cf211ae144'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store
