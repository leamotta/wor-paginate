# frozen_string_literal: true
require 'spec_helper'
RSpec.describe DummyModelsController, type: :controller do
  describe '#index' do
    context 'when paginating an ActiveRecord with no previous pagination but kaminari installed' do
      let!(:dummy_models) { create_list(:dummy_model, 28) }
      let(:expected_list) do
        dummy_models.first(25).map do |dummy|
          { 'id' => dummy.id, 'name' => dummy.name, 'something' => dummy.something }
        end
      end
      before do
        get :index
      end

      it 'responds with page' do
        expect(response_body(response)['page'].length).to(
          be Wor::Paginate::Config.default_per_page
        )
      end

      it 'responds with valid page' do
        expect(response_body(response)['page']).to eq expected_list
      end

      it 'responds with count' do
        expect(response_body(response)['count']).to be Wor::Paginate::Config.default_per_page
      end

      it 'responds with total_count' do
        expect(response_body(response)['total_count']).to be dummy_models.count
      end

      it 'responds with total_pages' do
        total_pages = (dummy_models.count / Wor::Paginate::Config.default_per_page.to_f).ceil
        expect(response_body(response)['total_pages']).to be total_pages
      end

      it 'responds with page' do
        expect(response_body(response)['current_page']).to be Wor::Paginate::Config.default_page
      end

      it 'responds with next_page' do
        expect(response_body(response)['next_page']).to be 2
      end
    end

    context 'when paginating with page and limit params' do
      context 'with a particular limit passed by option' do
        let(:expected_list) do
          dummy = dummy_models.third
          [{ 'id' => dummy.id, 'name' => dummy.name, 'something' => dummy.something }]
        end

        before do
          get :index_with_params
        end

        it 'responds with page' do
          expect(response_body(response)['page'].length).to be 1
        end

        it 'responds with valid page' do
          expect(response_body(response)['page']).to eq expected_list
        end

        it 'responds with count' do
          expect(response_body(response)['count']).to be 1
        end

        it 'responds with total_count' do
          expect(response_body(response)['total_count']).to be 28
        end

        it 'responds with total_pages' do
          expect(response_body(response)['total_pages']).to be dummy_models.count
        end

        it 'responds with page' do
          expect(response_body(response)['current_page']).to be 3
        end

        it 'responds with next_page' do
          expect(response_body(response)['next_page']).to be 4
        end
      end
    end

    context 'when paginating an ActiveRecord with a scope' do
      before do
        # Requiring both kaminari and will_paginate breaks scope pagination
        get :index_scoped
      end

      it 'responds with page' do
        expect(response_body(response)['page'].length).to(
          be Wor::Paginate::Config.default_per_page
        )
      end

      it 'responds with valid page' do
        expect(response_body(response)['page']).to eq expected_list
      end

      it 'responds with count' do
        expect(response_body(response)['count']).to be Wor::Paginate::Config.default_per_page
      end

      it 'responds with total_count' do
        expect(response_body(response)['total_count']).to be 28
      end

      it 'responds with total_pages' do
        total_pages = (dummy_models.count / Wor::Paginate::Config.default_per_page.to_f).ceil
        expect(response_body(response)['total_pages']).to be total_pages
      end

      it 'responds with page' do
        expect(response_body(response)['current_page']).to(
          be Wor::Paginate::Config.default_page
        )
      end

      it 'responds with next_page' do
        expect(response_body(response)['next_page']).to be 2
      end
    end

    context 'when paginating an ActiveRecord paginated with kaminari' do
      before do
        get :index_kaminari
      end

      it 'responds with page' do
        expect(response_body(response)['page'].length).to(
          be(Wor::Paginate::Config.default_per_page)
        )
      end

      it 'responds with valid page' do
        expect(response_body(response)['page']).to eq expected_list
      end

      it 'responds with count' do
        expect(response_body(response)['count']).to(
          be Wor::Paginate::Config.default_per_page
        )
      end

      it 'responds with total_count' do
        expect(response_body(response)['total_count']).to be dummy_models.count
      end

      it 'responds with total_pages' do
        total_pages = (dummy_models.count / Wor::Paginate::Config.default_per_page.to_f).ceil
        expect(response_body(response)['total_pages']).to be total_pages
      end

      it 'responds with page' do
        expect(response_body(response)['current_page']).to(
          be Wor::Paginate::Config.default_page
        )
      end

      it 'responds with next_page' do
        expect(response_body(response)['next_page']).to be 2
      end
    end

    context 'when paginating an ActiveRecord paginated with kaminari' do
      before do
        get :index_will_paginate
      end

      it 'responds with page' do
        expect(response_body(response)['page'].length).to(
          be(Wor::Paginate::Config.default_per_page)
        )
      end

      it 'responds with valid page' do
        expect(response_body(response)['page']).to eq expected_list
      end

      it 'responds with count' do
        expect(response_body(response)['count']).to(
          be Wor::Paginate::Config.default_per_page
        )
      end

      it 'responds with total_count' do
        expect(response_body(response)['total_count']).to be dummy_models.count
      end

      it 'responds with total_pages' do
        total_pages = (dummy_models.count / Wor::Paginate::Config.default_per_page.to_f).ceil
        expect(response_body(response)['total_pages']).to be total_pages
      end

      it 'responds with page' do
        expect(response_body(response)['current_page']).to(
          be Wor::Paginate::Config.default_page
        )
      end

      it 'responds with next_page' do
        expect(response_body(response)['next_page']).to be 2
      end
    end

    context 'when paginating an array' do
      before do
        get :index_array
      end

      it 'responds with page' do
        expect(response_body(response)['page'].length).to be
      end

      it 'responds with valid page' do
        expect(response_body(response)['page']).to eq((1..25).to_a)
      end

      it 'responds with count' do
        expect(response_body(response)['count']).to be Wor::Paginate::Config.default_per_page
      end

      it 'responds with total_count' do
        expect(response_body(response)['total_count']).to be 28
      end

      it 'responds with total_pages' do
        total_pages = (dummy_models.count / Wor::Paginate::Config.default_per_page.to_f).ceil
        expect(response_body(response)['total_pages']).to be total_pages
      end

      it 'responds with page' do
        expect(response_body(response)['current_page']).to(
          be Wor::Paginate::Config.default_page
        )
      end

      it 'responds with next_page' do
        expect(response_body(response)['next_page']).to be 2
      end
    end

    context 'when paginating something that can\'t be paginated' do
      it 'throws an exception' do
        expect { get :index_exception }
          .to raise_error(Wor::Paginate::Exceptions::NoPaginationAdapter)
      end
    end

    context 'when paginating an ActiveRecord with a custom serializer' do
      let(:expected_list) do
        dummy_models.first(25).map do |dummy|
          { 'something' => dummy.something }
        end
      end

      before do
        get :index_each_serializer
      end

      it 'responds with page' do
        expect(response_body(response)['page'].length).to be 25
      end

      it 'responds with valid page' do
        expect(response_body(response)['page']).to eq expected_list
      end

      it 'responds with count' do
        expect(response_body(response)['count']).to be 25
      end

      it 'responds with total_count' do
        expect(response_body(response)['total_count']).to be 28
      end

      it 'responds with total_pages' do
        total_pages = (dummy_models.count / Wor::Paginate::Config.default_per_page.to_f).ceil
        expect(response_body(response)['total_pages']).to be total_pages
      end

      it 'responds with page' do
        expect(response_body(response)['current_page']).to be 1
      end

      it 'responds with next_page' do
        expect(response_body(response)['next_page']).to be 2
      end
    end

    def response_body(response)
      JSON.parse(response.body)
    end

    context 'when paginating an ActiveRecord with a custom formatter' do
      let(:expected_list) do
        dummy_models.first(25).map do |dummy|
          { 'something' => dummy.something,
            'id' => dummy.id,
            'name' => dummy.name }
        end
      end

      before do
        get :index_custom_formatter
      end

      it 'doesn\'t respond with page in the default key' do
        expect(response_body(response)['page']).to be_nil
      end

      it 'responds with valid page' do
        expect(response_body(response)['items']).to eq expected_list
      end
    end
  end
end
