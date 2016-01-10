json.array!(@items) do |item|
  json.extract! item, :id, :item_name, :amount
  json.url item_url(item, format: :json)
end
