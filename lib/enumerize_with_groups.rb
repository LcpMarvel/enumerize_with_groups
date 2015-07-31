require "enumerize_with_groups/version"
require "enumerize"

module EnumerizeWithGroups
  def self.extended(mod)
    unless mod.respond_to?(:enumerize)
      fail <<-MESSAGE
        You have to `extend Enumerize` before `extend EnumerizeWithGroups`.
      MESSAGE
    end

    mod.module_eval do
      def self.enumerize(name, options = {})
        super

        self.define_singleton_method("#{name}_groups") do
          options[:groups]
        end

        if options[:groups]
          options[:groups].each do |key, items|
            scope_name = "enumerize_with_groups_#{name}_#{key}_group"

            self.define_singleton_method("#{name}_#{key}") do
              items
            end

            if self.ancestors.include?(ActiveRecord::Base)
              scope scope_name, ->{ where(name => items) }

              self.define_singleton_method("#{name}_#{key}_scope") do
                self.send(scope_name)
              end
            end
          end
        end
      end
    end
  end
end
