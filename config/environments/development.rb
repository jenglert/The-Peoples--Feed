# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true

# Currently, caching is enabled in the development environment to make development easier. It is necessary to ensure that the site
# still works if you actual reload the cached pages.  You can do this either by removing the cached files or disabling the cache.
config.action_controller.perform_caching             = true
ActionController::Base.cache_store = :file_store, "/path/to/cache/directory" 


# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false