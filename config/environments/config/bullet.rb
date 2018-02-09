class BulletConfig
  def initialize(config:)
    @config = config
  end

  def call
    config.after_initialize do
      Bullet.enable = true
      Bullet.rails_logger = true
      Bullet.raise = true if Rails.env.test?
    end
  end

  private

  attr_reader :config
end

