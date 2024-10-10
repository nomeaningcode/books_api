class Api::V1::FhController < ApplicationController
  def ecategories
    categories = build_categoria(20, 'gasto')

    render json: categories, status: 200
  end
  
  def icategories
    categories = build_categoria(20, 'ingreso')

    render json: categories, status: 200
  end

  def always_ok
    render json: {
      'status':'ok'
    }, status: 200
  end

  def incomes
    incomes = build_income(54)

    render json: incomes, status: 200
  end

  def expenses 
    expenses = build_expense(54)

    render json: expenses, status: 200
  end

  private
  def build_categoria(_length, _type)
    Array.new(_length) { |i| {id: i+1, category_name: "categoria #{_type} #{i}"} }
  end
  def build_income(_length)
    # Duda con la frecuencia en el campo de repeticion

    Array.new(_length) { |i| {
      id: i+1, 
      amount: Random.rand(1..843),
      jobName: "trabajo #{i+1}",
      day_week: Random.rand(1..7),
      day_month: Random.rand(1..30),
      fk_income_category_id: Random.rand(1..20),
      fk_income_concept_id: Random.rand(1..20),
      fk_income_certainly_id: Random.rand(1..20),
      fk_income_frequency_id: Random.rand(1..20)
    }}
  end
  def build_expense(_length)
    type_options = {
      '1'=> 'Necesario',
      '2'=> 'Disminuible',
      '3'=> 'No necesario'
    }
    # Duda con la frecuencia en el campo de repeticion

    Array.new(_length) { |i| {
      id: i+1, 
      expense_name: "expense #{i+1}",
      amount: Random.rand(1..843),
      day_week: Random.rand(1..7),
      day_month: Random.rand(1..30),
      description: "gasto #{i+1}",
      type: type_options["#{Random.rand(1..3)}"],
      decreasing_percentage: Random.rand(1..10),
      fk_expense_category_id: Random.rand(1..20),
      fk_expense_food_id: Random.rand(1..20),
      fk_expense_service_id: Random.rand(1..20),
      fk_expense_frequency_id: Random.rand(1..20)
    }}
  end
end