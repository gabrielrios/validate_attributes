require 'active_model'
require "validate_attributes/version"

module ValidateAttributes
  extend ActiveSupport::Concern

  def validate_attributes(options = {})
    return valid? if options.empty?
    errors.clear # Clean old validations as we're interested only on those

    _attributes = extract_attributes(options)

    # TODO: Use flat_map only with ruby 1.9
    if ActiveModel::VERSION::MAJOR == 3
      return validate_attributes_3(_attributes)
    end

    result = _attributes.map do |attr|
      self.class.validators_on(attr).map do |validator|
        validator.validate_each(self, attr.to_sym, send(attr))
        self.errors[attr].empty?
      end
    end
    return result.flatten.all?
  end

  private
  def validate_attributes_3(attrs)
    attrs.map!(&:to_sym)
    attrs.each do |attr|
      self.class.validators_on(attr).each do |validator|
        fields = validator.validate(self)
        rejected = fields.reject {|f| attrs.include?(f.to_sym) }
        rejected.each { |f| errors[f].clear }
      end
    end

    self.errors.blank?
  end

  def extract_attributes(options)
    only, except = options[:only], options[:except]

    if only.present?
      only = [only].flatten.map!(&:to_sym)
      _attributes = only
    end

    if except.present?
      except = [except].flatten.map!(&:to_sym)
      if _attributes.present?
        _attributes.reject!{|a| except.include?(a) }
      else
        _attributes = self.attribute_names
        _attributes.reject!{|a| except.include?(a.to_sym) }
      end
    end

    return _attributes
  end
end

module ActiveModel::Validations
  include ValidateAttributes
end
