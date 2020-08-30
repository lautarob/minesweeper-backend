require 'swagger_helper'

describe 'Users API' do

  path '/users' do

    post 'Creates an user' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: [ 'name' ]
      }

      response '201', 'user created' do
        let(:user) { { name: 'User name' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:blog) { { name: 1 } }
        run_test!
      end
    end
  end

  path '/users/{uuid}' do

    get 'Retrieves an user' do
      tags 'Users'
      produces 'application/json', 'application/xml'
      parameter name: :uuid, in: :path, type: :string

      response '200', 'user found' do
        schema type: :object,
          properties: {
            uuid: { type: :string },
            name: { type: :string }
          },
          required: [ 'uuid', 'name' ]

        let(:uuid) { User.create(name: 'Test user').uuid }
        run_test!
      end

      response '404', 'user not found' do
        let(:uuid) { 'invalid' }
        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:'Accept') { 'application/foo' }
        run_test!
      end
    end

    put 'Update an user' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: [ 'name' ]
      }
  
      response '201', 'user updated' do
        let(:user) { { name: 'User name' } }
        run_test!
      end
  
      response '422', 'invalid request' do
        let(:blog) { { name: 1 } }
        run_test!
      end
    end
  end
end