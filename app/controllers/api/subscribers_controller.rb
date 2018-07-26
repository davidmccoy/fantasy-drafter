class Api::SubscribersController < ApplicationController
  def create
    request = Gibbon::Request.lists("4f6afd7475").members.create(body: { email_address: subscriber_params[:email], status: "pending" })
    respond_to do |format|
      format.json { render :plain => {success:true}.to_json, status: 200, content_type: 'application/json' }
    end
  end

  private

  def subscriber_params
    params.require(:subscribe).permit(:email)
  end
end
