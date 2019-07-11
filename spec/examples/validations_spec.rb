require 'spec_helper'

RSpec.describe RecordMold do
  before do
    class User
      include RecordMold
    end
  end

  describe 'Class included this module' do
    it 'includes validations from database schema' do
      case ENV['TEST_DATABASE_ADAPTER']
      when 'postgresql'
        expect(User.validators.map { |validator| { class: validator.class, attributes: validator.attributes, options: validator.options } }).to eq(
          [
            {
              class: ActiveRecord::Validations::LengthValidator,
              attributes: [:name],
              options: { maximum: 30, allow_nil: false }
            },
            {
              class: ActiveModel::Validations::NumericalityValidator,
              attributes: [:age],
              options: { only_integer: true, greater_than: -2147483649, less_than: 2147483648, allow_nil: false }
            },
            {
              class: ActiveModel::Validations::NumericalityValidator,
              attributes: [:height],
              options: { only_integer: true, greater_than: -2147483649, less_than: 2147483648, allow_nil: true }
            },
            {
              class: ActiveModel::Validations::InclusionValidator,
              attributes: [:left],
              options: { in: [true, false], allow_nil: false }
            },
            {
              class: ActiveRecord::Validations::UniquenessValidator,
              attributes: [:my_number],
              options: { case_sensitive: true, scope: [] }
            }
          ]
        )
      else
        expect(User.validators.map { |validator| { class: validator.class, attributes: validator.attributes, options: validator.options } }).to eq(
          [
            {
              class: ActiveRecord::Validations::LengthValidator,
              attributes: [:name],
              options: { maximum: 30, allow_nil: false }
            },
            {
              class: ActiveModel::Validations::NumericalityValidator,
              attributes: [:age],
              options: { only_integer: true, allow_nil: false }
            },
            {
              class: ActiveModel::Validations::NumericalityValidator,
              attributes: [:height],
              options: { only_integer: true, allow_nil: true }
            },
            {
              class: ActiveModel::Validations::InclusionValidator,
              attributes: [:left],
              options: { in: [true, false], allow_nil: false }
            },
            {
              class: ActiveRecord::Validations::UniquenessValidator,
              attributes: [:my_number],
              options: { case_sensitive: true, scope: [] }
            }
          ]
        )
      end
    end
  end

  describe 'Instance of class included this module' do
    let(:user) { User.new(name: 'Bob', age: 18, left: false, my_number: '00000001') }

    context 'user\'s data is valid' do
      it 'is valid' do
        expect(user.valid?).to eq(true)
      end
    end

    context 'user\'s age is nil' do
      it 'is not valid' do
        user[:age] = nil
        expect(user.valid?).to eq(false)
      end
    end
  end
end
