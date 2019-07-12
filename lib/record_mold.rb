module RecordMold
  def self.included(model)
    exception_columns = model.send(:timestamp_attributes_for_create) + model.send(:timestamp_attributes_for_update) + model.defined_enums.keys
    exception_columns = (exception_columns + exception_columns.map { |column| model.attribute_aliases[column] }.compact).uniq
    model.columns.each do |field|
      next if field.name == model.primary_key
      next if exception_columns.include?(field.name)

      allow_nil = field.null
      case field.type
      when :boolean
        model.send(:validates_inclusion_of, field.name.to_sym, in: [true, false], allow_nil: allow_nil)
      when :integer, :float
        options = { only_integer: field.type == :integer, allow_nil: allow_nil }
        if field.limit && field.type == :integer
          unsigned = field.sql_type.include?('unsigned')
          options[:less_than] = unsigned ? 2 ** (8 * field.limit) : 2 ** (8 * field.limit) / 2
          options[:greater_than] = unsigned ? -(2 ** (8 * field.limit)) - 1 : -(2 ** (8 * field.limit) / 2) - 1
        end
        model.send(:validates_numericality_of, field.name.to_sym, **options)
      when :string, :text
        if field.limit
          maximum = field.limit
          model.send(:validates_length_of, field.name.to_sym, maximum: maximum, allow_nil: allow_nil)
        end
      else
        model.send(:validates_presence_of, field.name.to_sym) unless allow_nil
      end
    end

    ActiveRecord::Base.connection.indexes(model.table_name).each do |key|
      col_syms = key.columns.map(&:to_sym)
      model.send(:validates_uniqueness_of, col_syms.first.to_sym, scope: col_syms[1..-1]) if key.unique
    end
  end
end
