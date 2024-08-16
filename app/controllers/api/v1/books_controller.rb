module Api
  module V1
    class BooksController < ApplicationController
      def index
        # books = Book.limit(params(:limit)).offset(params[:offset])
        books = Book.all
        render json: BooksRepresenter.new(books).as_json
      end

      def create
        book = Book.new(book_params)

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
      def book_params
        params.require(:book).permit(:title, :author_id)
      end
      def destroy_id
        params.permit(:id)
      end
    end
  end
end