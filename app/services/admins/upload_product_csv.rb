class Admins::UploadProductCsv < Patterns::Service
  require 'csv'

  def initialize(file)
    @file = file
  end

  def call
    upload
  end

  private

  def upload
    CSV.foreach(@file, headers: true) do |row|
      transformed_key_row = row.to_hash.transform_keys { |k| k.strip.downcase }
      row_values = transformed_key_row.except('category').transform_values(&:capitalize)
      p = Product.new(row_values)
      if transformed_key_row['category'] == nil
        raise CsvNoCategoryError
      else
        categories = transformed_key_row['category'].split(', ')&.
          map { |c| Category.select { |s| s.name.downcase == c.strip.downcase } }.flatten
        p.assign_attributes(category_ids: categories.map{|c| c.id})
        p.save!
      end
    end
  end
end
