class AddReferenceInComment < ActiveRecord::Migration[5.1]
  def change
  	add_reference :comments, :category, foreign_key: true
  end
end
