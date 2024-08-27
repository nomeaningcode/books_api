class Book < ApplicationRecord
  belongs_to :author
  
  # se valida que el titulo exista al momento de intentar crear un registro y que este tenga una logitud de al menos 3 digitos
  validates :title, presence: true, length: {minimum: 3}
end
