json.entries do
	json.array! @entries, partial: 'entry.json', as: :entry
end
json.page @page
