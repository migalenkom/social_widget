class WidgetsController < ApplicationController

  before_filter :set_widget, only: [:show, :edit, :update, :destroy]

  def index

    @widgets = current_user.widgets
    @result = []
    @widgets.each do |w|
      @result << self.send("fetch_#{w.authorization.provider}_data",w)
    end

  end

  def new
    @widget = Widget.new
  end

   def create

    @widget = current_user.widgets.new(widget_params)
    current_user.widgets << @widget
    @created_widget = self.send("fetch_#{@widget.authorization.provider}_data",@widget)
    if @widget.save {

      respond_to do |format|
        format.html {redirect_to user_widgets_path(current_user), :notice => "Widget created"}
        format.js {}
      end
    }
    else
      render "new"
    end
   end


  def update
    if  @widget.update_attributes(widget_params)
      respond_to do |format|
        format.js {}
        format.json {render status: 200}
      end
    end
  end

  def destroy

    @widget.destroy
    respond_to do |format|
      format.html { redirect_to  user_widgets_path(current_user)}
      format.js
    end

  end

  private

  def fetch_facebook_data(widget)

    auth = widget.authorization
    fb_api = Koala::Facebook::API.new(auth.token)
    fb_profile = fb_api.get_object("me?fields=name,picture,posts,link")

    {widget:widget, provider: auth.provider, fb_profile:fb_profile}

  end

  def fetch_twitter_data(widget)
    auth = widget.authorization
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TWITTER_KEY"]
      config.consumer_secret     = ENV["TWITTER_SECRET"]
      config.access_token        = auth.token
      config.access_token_secret = auth.secret
    end
    tw_user = client.user(auth.uid.to_i)
    tw_timeline = client.user_timeline(auth.uid.to_i)

    {widget:widget, provider: auth.provider, tw_user: tw_user, tw_timeline: tw_timeline }

  end

  def fetch_google_oauth2_data(widget)
    auth = widget.authorization
    GooglePlus.access_token = auth.fresh_token
       googlePerson = GooglePlus::Person.get(auth.uid)
       googleActivity = GooglePlus::Activity.for_person(auth.uid)

       {widget:widget, provider: auth.provider, google_persone: googlePerson, google_activity: googleActivity }
  end

  def refresh_auth_token(auth)

  end



  def set_widget

    @widget = Widget.find(params[:id])

  end

  def widget_params
    params.require(:widget).permit(:id,:title,:authorization_id,)
  end



end
