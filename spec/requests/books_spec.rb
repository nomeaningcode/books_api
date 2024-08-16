require 'rails_helper'

describe 'Books API', type: :request do
  let(:first_author) { FactoryBot.create(:author, first_name: 'George', last_name: 'Orwell', age: 46) }
  let(:second_author) { FactoryBot.create(:author, first_name: 'H.G', last_name: 'Wells', age: 78) }

  describe 'GET /books' do
    before do
      FactoryBot.create(:book, title: '1984', author: first_author)
      FactoryBot.create(:book, title: 'Harry P', author: second_author)
    end

    it 'returns all books' do
      get '/api/v1/books'
  
      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(2)
      expect(response_body).to eq(
        [
          {
            'id' => 1,
            'title' => '1984',
            'author_name' => 'George Orwell',
            'author_age' => 46
          },
          {
            'id' => 2,
            'title' => 'Harry P',
            'author_name' => 'H.G Wells',
            'author_age' => 78
          }
        ]
      )
    end
  end
  
  describe 'POST /books' do
    it 'create a new book' do
      expect {
        post '/api/v1/books', params: { book: { title: 'The martian', author_id: first_author.id } }
      }.to change { Book.count }.from(0).to(1)

      expect(response).to have_http_status(:created)
      expect(response_body).to eq(
        {
          "id" => 1,
          "title" => 'The martian',
          "author_name" => 'George Orwell',
          "author_age" => 46
        }
      )
    end
  end

  describe 'DELETE /books/:id' do
    let!(:book) { FactoryBot.create(:book, title: '1984', author: second_author) }

    it 'delete a book' do
      expect {
        delete "/api/v1/books/#{book.id}"
    }.to change { Book.count }.from(1).to(0)

      expect(response).to have_http_status(:no_content)
    end
  end
end