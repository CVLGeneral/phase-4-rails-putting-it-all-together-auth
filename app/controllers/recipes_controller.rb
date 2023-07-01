class RecipesController < ApplicationController
    wrap_parameters format:[]
    def index
        if session[:user_id]
            recipes = Recipe.all.includes(:user)
            render json: recipes,  only: [:id, :title, :instructions, :minutes_to_complete],include: { user: { only: [:username,:image_url,:bio] } }, status: :created
          
        else 
            render json: { errors:[ "Not authorized" ]}, status: :unauthorized

        end 
    end
    def create
        if session[:user_id]
          recipe = Recipe.new(recipe_params)
          recipe.user_id = session[:user_id]
    
          if recipe.save
            render json: recipe, only: [:id, :title, :instructions, :minutes_to_complete], include: { user: { only: [:username, :image_url, :bio] } }, status: :created
          else
            render json: { errors: recipe.errors.full_messages }, status: :unprocessable_entity
          end
        else
          render json: { errors: ["Not authorized"] }, status: :unauthorized
        end
     end
    private
    def recipe_params 
        params.permit(:title, :instructions, :minutes_to_complete)
    end
end
