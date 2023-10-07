class AuthenticatedController < ApplicationController
  include JwtAuthenticatable
  before_action :authorized
end
