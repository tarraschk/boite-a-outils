class UsersController < ApplicationController
  before_action :set_user, only: [:mails]

  def mails
    @mails = @user.get_emails
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user    = User.find_by(id:  params[:id])
  end

end