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
                @user = User.new(user_params)
                if @user.save
                    render json: {status: 'SUCCESS', message: 'User created', data: @user}, status: :ok
                else
                    render json: {status: 'ERROR', message: 'Unable to create user', data: user.errors}, status: 400
                end
            end

            #PUT /users/:id
            def update
                @user = User.find(params[:id])
                if @user
                    @user.update(user_params)
                    render json: {status: 'SUCCESS', message: 'User successfully updated', data: @user}, status: :ok
                else
                    render json: {status: 'ERROR', message: 'Unable to update user', data: user.errors}, status: 400
                end
            end
            
            private
            def user_params
                params.permit(:first_name, :last_name, :email, :password)
            end
        
        end
    end
end
