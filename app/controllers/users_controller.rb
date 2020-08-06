class UsersController < ApplicationController
  def index
    @list_of_all_users = User.all.order({ :username => :asc })

    render({ :template => "user_templates/index.html" })
  end

  def show
    the_username = params.fetch("the_username")
    matching_users = User.where({ :username => the_username })
    @the_user = matching_users.at(0)

    render({ :template => "user_templates/show.html.erb" })
  end

  def create
    the_user = User.new

    the_user.username = params.fetch("query_username")

    the_user.save

    redirect_to("/users/#{the_user.username}")
  end

  def update
    the_id = params.fetch("the_user_id")
    matching_users = User.where({ :id => the_id })
    the_user = matching_users.at(0)

    the_user.username = params.fetch("query_username")

    the_user.save
    
    redirect_to("/users/#{the_user.username}")
  end

  def destroy
    username = params.fetch("the_username")
    matching_users = User.where({ :username => username })
    the_user = matching_users.at(0)

    the_user.destroy

    redirect_to("/users")
  end

end
