# frozen_string_literal: true

require_relative '../../../infrastructure/hccg/hccg_api'
require_relative '../../../infrastructure/ntpc/ntpc_api'

module TravellingSuggestions
  module Mapper
    # Mapper for attrsction
    class AttractionNTPCMapper
      def initialize(gateway_class, region)
        @gateway_class = gateway_class
        @gateway = gateway_class.new
        @region = region
      end

      def find(page, size)
        data = @gateway.attractions(page, size)
        build_entitys(data)
      end

      private

      def build_entitys(data)
        data.map do |attraction|
          Entity::Attraction.new(
            name: attraction['Name'],
            in_region: @region,
            type: classes_type(attraction['Class1'], attraction['Class2'], attraction['Class3']),
            notes: attraction['Description'],
            contact: attraction['Tel'],
            id: nil,
            added_time: nil,
            indoor_or_outdoor: nil,
            main_activity: nil,
            staying_time: nil,
            attendants: nil,
            best_time_to_visit: nil
          )
        end
      end

      def classes_type(class1, _class2, _class3)
        type_str = class_name(class1) unless class1.nil?
        # type_str = type_str + ', ' + class_name(class2) unless class2.nil?
        # type_str = type_str + ', ' + class_name(class3) unless class3.nil?
      end

      def class_name(class_id)
        case class_id.to_i
        when 1
          '文化'
        when 2
          '生態'
        when 3
          '古蹟'
        when 4
          '廟宇'
        when 5
          '藝術'
        when 6
          '小吃/特產'
        when 7
          '國家公園'
        when 8
          '國家風景區'
        when 9
          '休閒農業'
        when 10
          '溫泉'
        when 11
          '自然風景'
        when 12
          '遊憩'
        when 13
          '體育健身'
        when 14
          '觀光工廠'
        when 15
          '都會公園'
        when 16
          '森林遊樂區'
        when 17
          '林場'
        else
          '其他'
        end
      end
    end
  end
end
