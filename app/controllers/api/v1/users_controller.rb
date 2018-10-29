module Api::V1
  class UsersController < ApplicationController
    before_action :set_user, only: [:show, :update, :get_following, :get_followers, :get_user_recipes,
                                    :is_following, :follow_user, :unfollow_user]

    def new
      user = User.new
      render json: user
    end

    def create
      user = User.new(user_params)
      if user.valid? && user.save
        # UserMailer.welcome_email(user).deliver
        user.confirmation_token_valid?
        user.mark_as_confirmed!
        render json: user
      else
        render json: { errors: user.errors.full_messages }, status: :bad_request
      end
    end

    def confirm
      token = params[:token].to_s
      user = User.find_by(confirmation_token: token)
      if user.present? && user.confirmation_token_valid?
        user.mark_as_confirmed!
        render json: {status: 'User confirmed successfully'}, status: :ok
      else
        render json: {status: 'Invalid token'}, status: :not_found
      end
    end

    def login
      user = User.find_by(email: params[:user][:email].to_s.downcase)
      if user && user.authenticate(params[:user][:password])
        auth_token = JsonWebToken.encode({user_id: user.id})
        render json: {user_id: user.id, auth_token: auth_token}, status: :ok
      else
        render json: {error: 'Email not verified'}, status: :unauthorized
      end
    end

    def index
      users = User.all
      render json: users
    end

    def show
      render json: @user
    end

    def find_user
      @user = User.find_by(email: params[:user][:email])
      if @user
       render json: @user
      else
       @errors = @user.errors.full_messages
       render json: @errors
      end
    end

    def get_following
      following_profiles = @user.following.count
      following = @user.following
      render json: {following_profiles: following_profiles, following: following }
    end

    def get_followers
      follower_profiles = @user.followers.count
      followers = @user.followers
      render json: {follower_profiles: follower_profiles, followers: followers }
    end

    def follow_user
      other_user = User.find_by(id: params[:other_user])
      @user.follow(other_user)
      render json: other_user
    end

    def unfollow_user
      other_user = User.find_by(id: params[:other_user])
      @user.unfollow(other_user)
      render json: other_user
    end

    def get_user_recipes
      user_recipes_count = @user.recipes.count
      user_recipes = @user.recipes
      render json: {user_recipes_count: user_recipes_count, user_recipes: user_recipes}
    end

    def is_following
      other_user = User.find_by(id: params[:other_user])
      user_is_following = @user.following.include?(other_user)
      render json: user_is_following
    end

  private
    def set_user
      @user = User.find_by(id: params[:id])
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password,
                                   :password_confirmation)
    end
  end
end
