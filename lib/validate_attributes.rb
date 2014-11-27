require 'active_model'
require "validate_attributes/version"
require 'byebug'

module ValidateAttributes
  extend ActiveSupport::Concern

  def validate_attributes(options = {})
    return valid? if options.empty?

    _attributes = extract_attributes(options)

    # TODO: Use flat_map only with ruby 1.9
    # TODO: Validate_each doesn't work with ruby 1.8
    if RUBY_VERSION =~ /^1.8/
      return validate_attributes_18(_attributes)
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
  def validate_attributes_18(attrs)
    result = attrs.map do |attr|
      self.class.validators_on(attr).map do |validator|
        fields = validator.validate(self)
        fields.each do|f|
          unless attrs.include?(f)
            self.errors[f].clear
          end
        end
      end
    end

    self.errors.present?
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

ActiveModel::Validations.send(:include, ValidateAttributes)
