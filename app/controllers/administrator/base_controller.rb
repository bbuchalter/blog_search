class Administrator::BaseController < ApplicationController
  before_action :authenticate, if: -> { Rails.env.production? }

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "blog" && password == "hgf765"
    end
  end
end
