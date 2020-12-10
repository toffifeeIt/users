module Api
    module V1
        class UsersController < ApplicationController

            #GET /users
            def index
                @users = User.all
                render json: {status: 'SUCCESS', message: 'Loaded users', data: @users}, status: :ok
            end

            #GET user/:id
            def show
                @user = User.find(params[:id])
                render json: {status: 'SUCCESS', message: 'Loaded user', data: @user}, status: :ok
            end

            #POST /users
            def create
                user = User.new(user_params)
                if user.save
                    render json: {status: 'SUCCESS', message: 'Saved user', data: user}, status: :ok
                else
                    render json: {status: 'ERROR', message: 'User not saved', data: user.errors}, status: :unprocessable_entry
                end
            end
            
            private
            def user_params
                params.permit(:first_name, :last_name, :email)
            end
        
        end
    end
end
