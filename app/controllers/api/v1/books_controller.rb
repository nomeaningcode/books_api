module Api
  module V1
    class BooksController < ApplicationController
      MAX_PAGINATION_LIMIT = 100
      
      def index
        books = Book.limit(limit).offset(params[:offset])
        # books = Book.all
        render json: BooksRepresenter.new(books).as_json
      end

      def create
        book = Book.new(book_params)
        UpdateSkuJob.perform_later(book_params[:title])

        if book.save
          render json: BookRepresenter.new(book).as_json, status: :created
        else
          render json: book.errors, status: :unprocessable_entity
        end

      end

      def destroy
        Book.find(destroy_id[:id]).destroy!

        head :no_content
      end

      private
      def limit
        [params.fetch(:limit, MAX_PAGINATION_LIMIT).to_i, MAX_PAGINATION_LIMIT].min
      end
      def author_params
        params.require(:author).permit(:first_name, :last_name, :age)
      end
      def book_params
        params.require(:book).permit(:title, :author_id)
      end
      def destroy_id
        params.permit(:id)
      end
    end
  end
end