module Api::V1
  class RecipesController < ApplicationController
    def index
      @recipes = Recipe.order('created_at DESC')
      render json: @recipes
    end

    def create
      @recipe = Recipe.create(recipe_params)
      render json: @recipe
    end

    def update
      @recipe = Recipe.find(params[:id])
      @recipe.update_attributes(recipe_params)
      render json: @recipe
    end

    def destroy
      @recipe = Recipe.find(params[:id])
      if @recipe.destroy
        head :no_content, status: :ok
      else
        render json: @recipe.errors, status: :unprocessable_entity
      end
    end

  private

    def recipe_params
      params.require(:recipe).permit(:title, :body)
    end
  end
end
