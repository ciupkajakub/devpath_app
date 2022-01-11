class CsvNoCategoryError < StandardError
  def message
    'CSV with products is missing categories, please add them!'
  end
end
