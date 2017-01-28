require "rails_helper"

RSpec.describe "find user by access_token", type: :request do
  describe 'access token invalid' do
    it 'returns json with error + code "not_found"' do
      post "/auth", params: {accessToken: 'non-valid'}
      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:not_found)
      expect(response.body).to eq({error: "not-found"}.to_json)
    end
  end

  describe 'access token valid' do
    it 'returns json with found user + code "ok"' do
      user = Struct.new(:id, :access_token).new(123)
      allow(User).to receive(:find_by_access_token){ user }

      post "/auth", params: {accessToken: user.access_token}
      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['id']).to eq(123)
    end
  end
end