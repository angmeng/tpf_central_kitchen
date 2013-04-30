pdf.text "Stock Detail"

pdf.move_down(20)

products = @products.map do |item|
[
  item.name,
  item.product_category_name,
  number_with_precision(item.average_cost, :precision => 2),
  item.on_hand_quantity,
  number_to_currency(item.total_cost)
]

end

pdf.table products, :border_style => :grid,
  :row_colors => ["FFFFFF", "DDDDDD"],
  :headers => ["Product", "Category", "Cost", "Quantity", "Total"],
  :align => { 0 => :left, 1 => :left, 2 => :right, 3 => :center, 4 => :right}
  
pdf.move_down(30)

pdf.text "Gross Total : RM #{number_with_precision(@gross, :precision => 2)}", :size => 16, :style => :bold

  