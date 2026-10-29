class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  private

  def not_authenticated
    redirect_to login_path, alert: "ログインしてください"
  end
end
