require 'swagger_helper'

describe 'Games API' do

  path '/games' do

    post 'Creates a game' do
      tags 'Games'
      consumes 'application/json'
      parameter name: :game, in: :body, schema: {
        type: :object,
        properties: {
          columns_size: { type: :integer },
          rows_size: { type: :integer },
          mines_amount: { type: :integer }
        },
        required: [ 'name' ]
      }

      response '201', 'user created' do
        let(:game) { { columns_size: 10, rows_size: 20, mines_amount: 5 } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:blog) { { columns_size: 1, rows_size: 2, mines_amount: 10 } }
        run_test!
      end
    end
  end

  path '/games/{id}' do

    get 'Retrieves an game' do
      tags 'Games'
      produces 'application/json', 'application/xml'
      parameter name: :id, in: :path, type: :integer

      response '200', 'game found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            cells: { type: 'array', items: { type: 'integer' } },
            flagged_cells: { type: 'array', items: { type: 'integer' } },
            opened_cells: { type: 'array', items: { type: 'integer' } },
            status: { type: :integer },
            rows_size: { type: :integer },
            columns_size: { type: :integer },
            mines_amount: { type: :integer },
            user_id: { type: :string },
            start_time: { type: :string },
            end_time: { type: :string }
          },
          required: [ 'uuid', 'name' ]

        let(:uuid) { User.create(name: 'Test user').uuid }
        run_test!
      end

      response '404', 'game not found' do
        let(:uuid) { 'invalid' }
        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:'Accept') { 'application/foo' }
        run_test!
      end
    end

    put 'Update a game' do
      tags 'Games'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          opened_cell: { type: :integer },
          flagged_cells: { type: 'array', items: { type: 'integer' } },
        },
        required: [ 'opened_cell', 'flagged_cells' ]
      }
  
      response '201', 'game updated' do
        let(:game) { { opened_cell: 1, flagged_cells: [1, 2] } }
        run_test!
      end
  
      response '422', 'invalid request' do
        let(:blog) { { opened_cell: nil } }
        run_test!
      end
    end
  end
end