mongo_config = Rails.configuration.database_configuration
MongoMapper.setup(mongo_config, Rails.env, :logger => Rails.logger)