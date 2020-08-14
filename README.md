# Photogram Signin

[Here is your target.](http://photogram-signin.matchthetarget.com)

## Steps

 1. We have removed the old model `User`. Use the `draft:account` generator to replace it:

    ```
    rails generate draft:account user username:string private:boolean likes_count:integer comments_count:integer
    ```

    Read about the `draft:account` generator:

    [https://chapters.firstdraft.com/chapters/773#a-special-sort-of-table-user-accounts](https://chapters.firstdraft.com/chapters/773#a-special-sort-of-table-user-accounts)

 1. The `draft:account` generator does the standard work of building sign-in/sign-out infrastructure that nearly every application needs.
 2. You can now visit `/user_sign_in`, `/user_sign_up`, etc. You might want to make links your nav bar to make it easy to do so.
 3. Now that the user table exists and the sign-in/sign-out RCAVs exist, authentication is being done, and a cookie is being stored — your job, then, is to use the `@current_user` variable that is now available in all actions and all view templates to make your application work like [the target](http://photogram-signin.matchthetarget.com).

    This usually involves:

    - Directly assigning `@current_user.id` as a foreign key value instead of expecting the user to supply it via form inputs.
    - Narrowing down what data is sent to view templates from controller actions based on who is signed in and what they should and shouldn't.
    - Using `if` statements in view templates to hide and show things based on who the signed in user is, and what actions they have previously taken.
 4. The old `User` model had a lot of handy instance methods. You might want to redefine them, to make your job easier; although using the more robust `has_many`/`belongs_to` technique might be a good idea. You may not need all of them for this project. You can use the Association Accessors wizard to help you:

    [https://association-accessors.firstdraft.com/](https://association-accessors.firstdraft.com/)

    The methods that were in the old `User` model:

    ```ruby
    def comments
      my_id = self.id

      matching_comments = Comment.where({ :author_id => my_id })

      return matching_comments
    end

    def own_photos
      my_id = self.id

      matching_photos = Photo.where({ :owner_id => my_id })

      return matching_photos
    end

    def likes
      my_id = self.id

      matching_likes = Like.where({ :fan_id => my_id })

      return matching_likes
    end

    def liked_photos
      my_likes = self.likes
      
      array_of_photo_ids = Array.new

      my_likes.each do |a_like|
        array_of_photo_ids.push(a_like.photo_id)
      end

      matching_photos = Photo.where({ :id => array_of_photo_ids })

      return matching_photos
    end

    def commented_photos
      my_comments = self.comments
      
      array_of_photo_ids = Array.new

      my_comments.each do |a_comment|
        array_of_photo_ids.push(a_comment.photo_id)
      end

      matching_photos = Photo.where({ :id => array_of_photo_ids })

      unique_matching_photos = matching_photos.distinct

      return unique_matching_photos
    end

    def sent_follow_requests
      my_id = self.id

      matching_follow_requests = FollowRequest.where({ :sender_id => my_id })

      return matching_follow_requests
    end

    def received_follow_requests
      my_id = self.id

      matching_follow_requests = FollowRequest.where({ :recipient_id => my_id })

      return matching_follow_requests
    end

    def accepted_sent_follow_requests
      my_sent_follow_requests = self.sent_follow_requests

      matching_follow_requests = my_sent_follow_requests.where({ :status => "accepted" })

      return matching_follow_requests
    end

    def accepted_received_follow_requests
      my_received_follow_requests = self.received_follow_requests

      matching_follow_requests = my_received_follow_requests.where({ :status => "accepted" })

      return matching_follow_requests
    end

    def followers
      my_accepted_received_follow_requests = self.accepted_received_follow_requests
      
      array_of_user_ids = Array.new

      my_accepted_received_follow_requests.each do |a_follow_request|
        array_of_user_ids.push(a_follow_request.sender_id)
      end

      matching_users = User.where({ :id => array_of_user_ids })

      return matching_users
    end

    def leaders
      my_accepted_sent_follow_requests = self.accepted_sent_follow_requests
      
      array_of_user_ids = Array.new

      my_accepted_sent_follow_requests.each do |a_follow_request|
        array_of_user_ids.push(a_follow_request.recipient_id)
      end

      matching_users = User.where({ :id => array_of_user_ids })

      return matching_users
    end

    def feed
      array_of_photo_ids = Array.new

      my_leaders = self.leaders
      
      my_leaders.each do |a_user|
        leader_own_photos = a_user.own_photos

        leader_own_photos.each do |a_photo|
          array_of_photo_ids.push(a_photo.id)
        end
      end

      matching_photos = Photo.where({ :id => array_of_photo_ids })

      return matching_photos
    end

    def discover
      array_of_photo_ids = Array.new

      my_leaders = self.leaders
      
      my_leaders.each do |a_user|
        leader_liked_photos = a_user.liked_photos

        leader_liked_photos.each do |a_photo|
          array_of_photo_ids.push(a_photo.id)
        end
      end

      matching_photos = Photo.where({ :id => array_of_photo_ids })

      return matching_photos
    end
    ```
 
## Specs

<details>
  <summary>Click here to see names of each test</summary>

/users/[USERNAME] - Update user form does not display Update user form when logged in user is on another user's page

/users/[USERNAME] - Update user form does display Update user form when logged in user is on their own page

/photos - Create photo form automatically populates owner_id of new photo with id of the signed in user

/photos/[ID] - Update photo form does not display Update photo form when photo does not belong to current user

/photos/[ID] - Update photo form displays Update photo form when photo belongs to current user

/photos/[ID] - Delete this photo button displays Delete this photo button when photo belongs to current user

/photos/[ID] — Add comment form automatically associates comment with signed in user and current photo

/photos/[ID] - Like Form automatically populates photo_id and fan_id with current photo and signed in user

/photos/[ID] - Delete Like link displays 'Delete Like' link if current user has already liked the Photo

/photos/[ID] - Delete Like link removes the Like record between the current user and current photo when clicked

</details>
