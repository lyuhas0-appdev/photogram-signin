class LikesController < ApplicationController
  
  def create
    the_like = Like.new

    the_like.fan_id = params.fetch("user_id")
    the_like.photo_id = params.fetch("photo_id")

    the_like.save

    redirect_to("/photos/#{the_like.photo_id}")
  end

  def destroy
    id = params.fetch("the_like_id")
    the_like = Like.where({ :id => id }).at(0)
    the_like.destroy

    redirect_to("/photos/#{the_like.photo_id}")
  end

end
