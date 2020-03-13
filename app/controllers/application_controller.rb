class AuthorityError < StandardError #例外クラスを継承
end
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
end
