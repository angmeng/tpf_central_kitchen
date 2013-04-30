module ProductMovementsHelper
  
  def generate_description(product_movement)
    case product_movement.movement_category_id
    when ProductMovement::OPENING
        "<td style='color: blue;'>" + (t "product.open_balance") + "</td>"
    when ProductMovement::INVOICE
      if product_movement.debit
        "<td style='color: green;'>" + (t "product_movement.deleted_from_invoice") + "</td>"
      else
        "<td style='color: red;'>" + (t "product_movement.added_into_invoice") + "</td>"
      end
    when ProductMovement::PURCHASE_INVOICE
      if product_movement.debit
        "<td style='color: green;'>" + (t "product_movement.added_into_purchase_invoice") + "</td>"
      else
        "<td style='color: red;'>" + (t "product_movement.deleted_from_purchase_invoice") + "</td>"
      end
      
    when ProductMovement::ADJUSTMENT
      if product_movement.deleted
        if product_movement.debit
          "<td style='color: green;'>" + (t "product_movement.adjustment_deleted") + "</td>"
        else
          "<td style='color: red;'>" + (t "product_movement.adjustment_deleted") + "</td>"
        end
        
      else
        if product_movement.debit
          "<td style='color: green;'>" + (t "product_movement.adjustment_created") + "</td>"
        else
          "<td style='color: red;'>" + (t "product_movement.adjustment_deleted") + "</td>"
        end
      end
      
    when ProductMovement::TRANSFER
      if product_movement.deleted
        if product_movement.debit
          "<td style='color: green;'>" + (t "product_movement.transfer_created") + "</td>"
        else
          "<td style='color: red;'>" + (t "product_movement.transfer_created") + "</td>"
        end
        
      else
        if product_movement.debit
          "<td style='color: green;'>" + (t "product_movement.transfer_created") + "</td>"
        else
          "<td style='color: red;'>" + (t "product_movement.transfer_created") + "</td>"
        end
      end
  
    end
  end
  
  def generate_debit_credit(product_movement)
    if product_movement.debit
        "<td style='text-align: center;'>" + product_movement.quantity.to_s + "</td><td></td>"
      
    else
         "<td></td><td style='text-align: center;'>" + product_movement.quantity.to_s + "</td>"
    end
  end
  
  def generate_invoice_link(product_movement)
    case product_movement.movement_category_id
    when ProductMovement::OPENING
        "<td style='text-align: center'>" + (link_to (t "links.show_product"), product_movement.product, {:target => "_blank"}) + "</td>"
    when ProductMovement::INVOICE
      if product_movement.deleted
        "<td style='text-align: center;color: red;'>" + (t "product_movement.invoice_deleted") + "</td>"
      else
        "<td style='text-align: center;'>" + (link_to (t "links.show_invoice"), Invoice.find(product_movement.reference_id), {:target => "_blank"}) + "</td>" rescue "<td style='text-align: center;color: red;'>" + (t "product_movement.invoice_deleted") + "</td>"
      end
    when ProductMovement::PURCHASE_INVOICE
      if product_movement.deleted
        "<td style='text-align: center;color: red;'>" + (t "product_movement.purchase_invoice_deleted") + "</td>"
      else
        "<td style='text-align: center;'>" + (link_to (t "links.show_purchase_invoice"),PurchaseInvoice.find(product_movement.reference_id), {:target => "_blank"}) + "</td>" rescue "<td style='text-align: center;color: red;'>" + (t "product_movement.purchase_invoice_deleted") + "</td>"
      end
      
    when ProductMovement::ADJUSTMENT
      if product_movement.deleted
        "<td style='text-align: center;color: red;'>" + (t "product_movement.adjustment_deleted") + "</td>"
      else
        "<td style='text-align: center;'>" + (link_to (t "links.show_adjustment"), StockAdjustment.find(product_movement.reference_id), {:target => "_blank"}) + "</td>" rescue  "<td style='text-align: center;color: red;'>" + (t "product_movement.adjustment_deleted") + "</td>"
      end
      
    when ProductMovement::TRANSFER
      if product_movement.deleted
        "<td style='text-align: center;color: red;'>" + (t "product_movement.transfer_deleted") + "</td>"
      else
        "<td style='text-align: center;'>" + (link_to (t "links.show_transfer"), StockTransfer.find(product_movement.reference_id), {:target => "_blank"}) + "</td>" rescue  "<td style='text-align: center;color: red;'>" + (t "product_movement.transfer_deleted") + "</td>"
      end
    end
  end
  
end
