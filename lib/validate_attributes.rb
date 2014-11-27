require 'active_model'
require "validate_attributes/version"

module ValidateAttributes
  extend ActiveSupport::Concern

  def validate_attributes(options = {})
    return valid? if options.empty?

    attributes = extract_attributes(options)

    attributes.flat_map do |attr|
      self.class.validators_on(attr).map do |validator|
        validator.validate_each(self, attr, send(attr)).empty?
      end
    end.all?
  end

  private
  def extract_attributes(options)
    only, except = options[:only], options[:except]

    if only.present?
      only.map!(&:to_sym)
      attributes = [only].flatten
    end

    if except.present?
      except.map!(&:to_sym)
      if attributes.present?
        attributes.reject!{|a| except.include?(a) }
      else
        attributes = self.attribute_names
        attributes.reject!{|a| except.include?(a.to_sym) }
      end
    end

    return attributes
  end
end

ActiveModel::Validations.send(:include, ValidateAttributes)
