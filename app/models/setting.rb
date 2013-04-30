# coding: utf-8
class Setting < ActiveRecord::Base
  attr_accessible :ar_code, :ar_last_number, :ap_code, :ap_last_number, :invoice_code, :invoice_last_number

  
  CUSTOMER_PAYMENT = 1
  SUPPLIER_PAYMENT = 2
  
  ENGLISH = 1
  CHINESE = 2
  
  LANGUAGE_OPTIONS = [
  ["English", ENGLISH],
  ["华文", CHINESE]
  ].freeze

  def self.increment_of_invoice
    setting = Setting.first
    setting.invoice_last_number += 1
    setting.save
  end
  
  def self.increment_of_purchase_invoice
    setting = Setting.first
    setting.purchase_invoice_last_number += 1
    setting.save
  end
  
  def self.increment_of_purchase_order
    setting = Setting.first
    setting.purchase_order_last_number += 1
    setting.save
  end
  
  def self.increment_of_outlet_purchase_order
    setting = Setting.first
    setting.outlet_purchase_order_last_number += 1
    setting.save
  end
  
  def forward_to(number_of_days)
    setting = Setting.first
    setting.blowfish += number_of_days.to_i.days
    setting.save
    setting.reload
    setting.blowfish
  end
  
  def backward_to(number_of_days)
    setting = Setting.first
    setting.blowfish -= number_of_days.to_i.days
    setting.save
    setting.reload
    setting.blowfish
  end
  
end
