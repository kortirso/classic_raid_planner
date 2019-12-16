module Api
  module V1
    class GameItemCategoriesController < Api::V1::BaseController
      include Concerns::GameItemCategoryCacher

      before_action :get_game_item_categories_from_cache, only: %i[index]

      resource_description do
        short 'GameItemCategory resources'
        formats ['json']
      end

      api :GET, '/v1/game_item_categories.json', 'Get game item categories'
      error code: 401, desc: 'Unauthorized'
      def index
        render json: @game_item_categories_json, status: 200
      end
    end
  end
end
