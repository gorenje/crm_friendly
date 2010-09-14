module Friendly
  module Extensions
    extend Friendly::Document::Mixin
    
    module ClassMethods
      # done for ActiveRecord-like behaviour, not for performance.
      def count(*args)
        args.size == 0 ? all.size : super(*args)
      end

      def delete_all
        all.each { |document| document.destroy }
      end

      # default_value class becomes the type for the attribute. If default value is nil, then
      # String is used.
      def new_attribute(name, default_value, opts = {})
        attr_name = name.to_s.downcase.to_sym
        self.send("attribute", attr_name, opts[:type] || (default_value || "").class, 
                  {:default => default_value}) 
        opts[:obj].send("#{attr_name}=", opts[:value]) unless opts[:obj].nil?
        self
      end

      # Remove an attribute from the model. This will fail if the attribute has an index.
      # Otherwise, the associated methods for the attribute are removed. These are:
      #   #{name} 
      #   #{name}=
      #   #{name}_was
      #   #{name}_changed?
      # Should really be provided in the friendly gem, but for now, it's here.
      def remove_attribute(name)
        name = name.to_sym
        begin
          storage_proxy.index_for_fields([name])
          raise Friendly::HasIndex, "Field '#{name}' has index, not removing."
        rescue Friendly::MissingIndex
          attributes.delete(name) if attributes.has_key?(name)
          [name,"#{name}=","#{name}_was","#{name}_changed?"].map { |a| a.to_sym }.
            each do |method_name|
            undef_method(method_name) if method_defined?(method_name)
          end
        end
        self
      end
    end
    
    def errors
      @errors ||= ErrorProxy.new
    end

    def to_s
      id.to_s
    end
    
    def save_with_errors
      capture_exceptions do
        save
      end
    end

    def update(hsh)
      capture_exceptions do
        self.attributes = hsh
        save
      end
    end
    
    protected 
    
    def capture_exceptions
      errors.clear
      yield
      true
    rescue Exception => e 
      errors.push e
      false
    end
  end
end

