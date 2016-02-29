json.array!(@archived_bills) do |archived_bill|
  json.extract! archived_bill, :id, :bill_name, :item_name, :amount, :paid, :sub_total, :item_type
  json.url archived_bill_url(archived_bill, format: :json)
end
