require 'rails_helper'

RSpec.describe API::TimeEntriesController, type: :controller, seed: :configured, user: :logged_in do
  let(:entry) { create(:api_time_entry) }

  describe 'POST create' do
    context 'when password doesnt match' do
      it 'creates time entries per API' do
        post :create, api_time_entry: { time: '1122', hint: 'hint', password: 'bad', sender: 'sender' }
        expect(response).to be_success
        expect(response.body).to eq '{"success":false,"error":{"password":["ist nicht gültig"]}}'
      end
    end

    context 'when password match' do
      it 'creates time entries per API' do
        post :create, api_time_entry: { time: '1122', hint: 'hint', password: 'API', sender: 'sender' }
        expect(response).to be_success
        expect(response.body).to eq '{"success":true}'
      end
    end
  end

  describe 'GET index' do
    it 'renders index' do
      get :index
      expect(response).to be_success

      expect(assigns(:waiting_time_entries)).to eq([])
      expect(assigns(:closed_time_entries)).to eq([])
      expect(assigns(:lists)).to eq([])
    end
  end

  describe 'GET show' do
    it 'renders show' do
      get :show, id: entry.id
      expect(response).to be_success

      expect(assigns(:lists)).to eq([])
    end
  end
end
