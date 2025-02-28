class SessionsController < ApplicationController
    def create
      user = User.find_by(username: params[:username])
      if user&.authenticate(params[:password])
        session[:user_id] = user.id
        render json: user , status: :ok
      else
        render json: { errors: ["Invalid username or password"] }, status: :unauthorized
      end
    end
  
    def destroy
        if session[:user_id].present?
          session[:user_id] = nil
          head :no_content
        else
          render json: { errors: ["No user logged in"] }, status: :unauthorized
        end
    end
      
      
      
end
  