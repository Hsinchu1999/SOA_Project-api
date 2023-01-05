# frozen_string_literal: true

require 'dry/transaction'

module TravellingSuggestions
  module Service
    # A Service object to validate result from db
    class UpdateUserFavorites
      include Dry::Transaction

      step :create_user_entity
      step :update_user_favorites

      private

      def create_user_entity(post_params)
        puts 'in create_user_entity'
        puts "post_params=#{post_params}"
        if (user = Repository::ForUser.klass(Entity::User).find_name(post_params['nickname']))
          post_params.delete('nickname')
          Success(
              Response::ApiResult.new(
                status: :ok,
                message: [user, post_params]
              )
            )
        else
          Failure(
            Response::ApiResult.new(
              status: :not_found,
              message: 'User not found'
            )
          )
        end
      end

      def update_user_favorites(input)
        puts 'in update_user_favorites'
        puts "input=#{input}"
        user = input.message[0]
        puts "user=#{user}"
        post_params = input.message[1]
        puts "post_params=#{post_params}"

        post_params.each do |key, value|
          next unless value == 'like'
          puts key
          puts key.class
          attraction = Repository::ForAttraction.klass(Entity::Attraction).find_id(key.to_i)
          puts "attraction=#{attraction}"
          puts 'BEFORE ADDING'
          puts "user.favorite_attractions.favorites_list=#{user.favorite_attractions.favorites_list}"
          user.favorite_attractions.add_new(attraction)
          puts 'AFTER ADDING'
          puts "user.favorite_attractions.favorites_list=#{user.favorite_attractions.favorites_list}"
          fav_attraction_orms = Repository::UsersFavorites.db_find_or_create(user.favorite_attractions)
          # actually creates
        end

        Success(
          Response::ApiResult.new(
            status: :ok,
            message: 'Success'
          )
        )
      rescue StandardError
        Failure(Response::ApiResult.new(
                  status: :not_found,
                  message: 'Having trouble accessing database'
                ))
      end
    end
  end
end
