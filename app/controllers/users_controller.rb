class UsersController < ApplicationController
  before_action :require_login, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to root_path, notice: "ユーザー登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    unless @user.valid_password?(params[:current_password].to_s)
      @user.errors.add(:base, "現在のパスワードが正しくありません")
      return render :edit, status: :unprocessable_entity
    end

    attributes = user_params.to_h

    if attributes["password"].blank?
      attributes.delete("password")
      attributes.delete("password_confirmation")
    end

    if @user.update(attributes)
      redirect_to mypage_path, notice: "アカウント情報を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end
end
