require 'rails_helper'

describe 'PUT /services/:service_id/categories' do
  before(:each) do
    create_service
    @token = ENV['ADMIN_APP_TOKEN']
    @food = Category.create!(name: 'Food', oe_id: '101')
  end

  context 'when the passed in oe_id exists' do
    it "updates a service's categories" do
      put(
        api_endpoint(path: "/services/#{@service.id}/categories"),
        { oe_ids: ['101'] },
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response).to be_success
      expect(json['categories'].first['name']).to eq('Food')
    end
  end

  context "when the passed in oe_id doesn't exist" do
    it 'ignores it' do
      put(
        api_endpoint(path: "/services/#{@service.id}/categories"),
        { oe_ids: ['102'] },
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response.status).to eq(200)
      expect(json['categories']).to eq([])
    end
  end

  context 'without a valid token' do
    it 'returns a 401 error' do
      put(
        api_endpoint(path: "/services/#{@service.id}/categories"),
        { oe_ids: ['101'] },
        'HTTP_X_API_TOKEN' => 'foo'
      )
      expect(response.status).to eq(401)
    end
  end
end