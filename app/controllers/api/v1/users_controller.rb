module Api
    module V1
        class UsersController < ApplicationController
            include ActionController::Cookies

            before_action :set_current_user, except: %i[sign_in]

            #GET /users
            def index
                @users = User.all
                render json: {status: 'SUCCESS', message: 'Loaded users', data: @users}, status: :ok
            end

            #GET user/:id
            def show
                @user = User.find(params[:id])
                if @user && @user.token == @current_user.token
                    render json: {status: 'SUCCESS', message: 'Loaded user', data: @user}, status: :ok
                else
                    render json: {status: 'ERROR', message: 'Unable to get user', data: @user.errors}, status: 400
                end
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
                if @user && @user.token == @current_user.token
                    @user.update(user_params)
                    render json: {status: 'SUCCESS', message: 'User successfully updated', data: @user}, status: :ok
                else
                    render json: {status: 'ERROR', message: 'Unable to update user, user is not signed in', data: @user.errors}, status: 400
                end
            end

            
            # POST /sign_in
            def sign_in
                @user = User.find_by(email: params[:email])
                if @user && @user.authenticate(params[:password])
                @user.token = generate_token
                @user.save
                cookies[:token] = { value: @user.token, expires: 21.day.from_now }
                puts cookies[:token]
                # render json: @user.as_json(only: [:email, :first_name, :last_name]), status: :created
                render json: @user.attributes.except('password_digest', 'token')
                else
                # head(:unauthorized)
                render json: {status: 'ERROR', message: 'Unable to sign in', data: @user.errors}, status: 401
                end
            end

            #POST /sign_out
            def sign_out        
                if @current_user    
                    @current_user.update(token: nil)
                    cookies.delete :token
                    render json: {status: 'SUCCESS', message: 'User successfully signed out', data: @current_user.email}, status: :ok
                else
                    render json: {status: 'ERROR', message: 'User is not signin', data: @user.errors}, status: 400
                end

            end
    

            def generate_token
                loop do
                token = SecureRandom.hex(10)
                break token unless User.where(token: token).exists?
                end
            end

            def set_current_user
                @current_user =  User.find_by(token: cookies[:token])
            end
            
            private
            def user_params
                params.permit(:first_name, :last_name, :email, :password)
            end
        
        end
    end
end
