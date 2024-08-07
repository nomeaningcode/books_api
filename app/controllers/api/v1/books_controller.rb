module Api
  module V1
    class BooksController < ApplicationController
      def index
        render json: Book.all
      end

      def create
        book = Book.new(book_params)

        if book.save
          render json: book, status: :created
        else
          render json: book.errors, status: :unprocessable_entity
        end

      end

      def destroy
        Book.find(destroy_id[:id]).destroy!

        head :no_content
      end

      private
      def book_params
        params.require(:book).permit(:title, :author)
      end
      def destroy_id
        params.permit(:id)
      end
    end
  end
end