Pageflow.configure do |config|
  # The email address to use as from header in invitation mails to new
  # users.
  config.mailer_sender = 'change-me-at-config-initializers-pageflow@example.com'

  # Entry type plugins
  config.plugin(PageflowPaged.plugin)
  config.plugin(PageflowScrolled.plugin)

  # Plugins that provide page types and widget types.
  config.plugin(Pageflow.built_in_page_types_plugin)
  config.plugin(Pageflow.built_in_widget_types_plugin)
  # config.plugin(Pageflow::Rainbow.plugin)

  config.for_entry_type(PageflowPaged.entry_type) do |entry_type_config|
    # Add custom themes by invoking the pageflow:theme generator and
    # registering the theme here.
    #
    #     $ rails generate pageflow:theme my_custom_theme
    #     => creates app/assets/stylesheets/pageflow/themes/my_custom_theme.css.scss
    #
    entry_type_config.themes.register(:default)
    # config.themes.register(:my_custom_theme)
  end

  config.for_entry_type(PageflowScrolled.entry_type) do |entry_type_config|
    entry_type_config.themes.register(:default,
                                      logo_alt_text: 'Pageflow',
                                      theme_color: '#ffffff')
  end

  # String to interpolate into paths of files generated by paperclip
  # preprocessors. This allows to refresh cdn caches after
  # reprocessing attachments.
  config.paperclip_attachments_version = 'v1'

  # Allow multiple development instances to share one S3 bucket by
  # keeping each instance's files in a separate folder named after the
  # system's hostname. Use a generic `main` folder in all other
  # environments.
  config.paperclip_s3_root =
    if Rails.env.development?
      require 'socket'
      Socket.gethostname
    else
      'main'
    end

  # How to handle https requests for URLs which will have assets in the page.
  # If you wish to serve all assets over http and prevent mixed-content warnings,
  # you can force a redirect to http. The inverse is also true: you can force
  # a redirect to https for all http requests.
  #
  #     config.public_https_mode = :prevent (default) # => redirects https to http
  #     config.public_https_mode = :enforce # => redirects http to https
  #     config.public_https_mode = :ignore # => does nothing
  config.public_https_mode = :ignore

  # Rewrite the below section to use your favorite configuration
  # method: ENV variables, secrets.yml, custom yml files. If you use
  # environment variables consider the dotenv gem to configure your
  # application via a single .env file.
  #
  # Whatever you choose, do NOT hard code values below. That makes it
  # hard to switch environments and risks leaking secrects.

  # Default options for paperclip attachments which are supposed to
  # use s3 storage. All options allowed in paperclip has_attached_file
  # calls are allowed.
  config.paperclip_s3_default_options.merge!(
    s3_credentials: {
      bucket: ENV.fetch('S3_BUCKET', 'com-example-pageflow-development'),
      access_key_id: ENV.fetch('S3_ACCESS_KEY', 'xxx'),
      secret_access_key: ENV.fetch('S3_SECRET_KEY', 'xxx')
    },
    s3_host_name: ENV.fetch('S3_HOST_NAME', 's3-eu-west-1.amazonaws.com'),
    s3_region: ENV.fetch('S3_REGION', 'eu-west-1'),
    s3_host_alias: ENV.fetch('S3_HOST_ALIAS',
                             'com-example-pageflow.s3-website-eu-west-1.amazonaws.com'),
    s3_protocol: ENV.fetch('S3_PROTOCOL', 'http')
  )

  # Default options for paperclip attachments which are supposed to
  # use filesystem storage. All options allowed in paperclip has_attached_file
  # calls are allowed.
  config.zencoder_options.merge!(
    api_key: ENV.fetch('ZENCODER_API_KEY', 'xxx'),
    output_bucket: ENV.fetch('S3_OUTPUT_BUCKET', 'com-example-pageflow-out'),
    s3_host_alias: ENV.fetch('S3_OUTPUT_HOST_ALIAS',
                             'com-example-pageflow-out.s3-website-eu-west-1.amazonaws.com'),
    s3_protocol: ENV.fetch('S3_PROTOCOL', 'http'),
    attachments_version: 'v1',

    # Zencoder can generate SMIL files which can be used to have
    # Akamai generate HLS-playlists. By default, Pageflow makes
    # Zencoder generate HLS-playlists. To prevent hitting Zencoder's
    # 20 outputs limit, we disable smil outputs.
    skip_smil: true
  )

  # Used to encrypt stored access tokens.
  config.encryption_options.merge!(
    key: ENV.fetch('SYMMETRIC_ENC_KEY', '1234567890ABCDEF'),
    iv: ENV.fetch('SYMMETRIC_ENC_IV', '1234567890ABCDEF')
  )

  # Specify default meta tags to use in published stories.
  # These defaults will be included in the page <head> unless overriden by the Entry.
  # If you set these to <tt>nil</tt> or <tt>""</tt> the meta tag won't be included.
  config.default_keywords_meta_tag = 'pageflow, multimedia, reportage'
  config.default_author_meta_tag = 'Pageflow'
  config.default_publisher_meta_tag = 'Pageflow'
end

# Comment out this call if you wish to run rails generators or rake
# tasks while the Pageflow configuration is in an invalid
# state. Otherwise Pageflow configuration errors might prevent you
# from initializing the environment. Required for Pageflow to run.
Pageflow.finalize!
