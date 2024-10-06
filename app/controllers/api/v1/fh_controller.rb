class Api::V1::FhController < ApplicationController
  def ecategories
    categories = build_categoria(20, 'gasto')

    render json: {
      'categories'=> categories
    }, status: 200
  end
  
  def icategories
    categories = build_categoria(20, 'ingreso')

    render json: {
      'categories'=> categories
    }, status: 200
  end

  def always_ok
    render json: {
      'status':'ok'
    }, status: 200
  end

  private
  def build_categoria(_length, _type)
    Array.new(_length) { |i| {id: i+1, category_name: "categoria #{_type} #{i}"} }
  end
  def build_income(_length, _type)
    category_id = Random.rand(1..20)
    amount = Random.rand(1..843)
    day_week = Random.rand(1..7)
    day_month = Random.rand(1..30)
    jobName = "trabajo #{day_month}"
    income_category = "categoria #{category_id}"
    income_concept = "concepto #{category_id}"
    income_certainly = "certeza #{category_id}"
    income_certainly = "frecuencia #{category_id}"
    # Duda con la frecuencia en el campo de repeticion

    Array.new(_length) { |i| {
      id: i, 
      category_name: "categoria #{_type} #{i}"
    }}
  end
end