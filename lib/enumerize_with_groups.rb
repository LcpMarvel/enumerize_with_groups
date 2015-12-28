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
      def self.define_active_record_scope(name, key, items)
        return unless self.ancestors.include?(ActiveRecord::Base)

        scope_name = "enumerize_with_groups_#{name}_#{key}_group"
        scope scope_name, -> { where(name => items) }

        self.define_singleton_method("#{name}_#{key}_scope") do
          self.send(scope_name)
        end
      end

      def self.define_group_check_methods(name, key, items)
        define_method("in_#{name}_#{key}?") do
          fail "You have to define #{key} as group" unless items.is_a?(Array)

          items.map(&:to_s).include?(self.public_send(name))
        end
      end

      def self.define_methods_of_groups(name, groups)
        self.define_singleton_method("#{name}_groups") do
          groups
        end

        return unless groups.present?
        groups = groups.freeze

        groups.each do |key, items|
          next unless items.present?
          items = items.freeze

          self.define_singleton_method("#{name}_#{key}") do
            items
          end

          define_group_check_methods(name, key, items)
          define_active_record_scope(name, key, items)
        end
      end

      def self.enumerize(name, options = {})
        super

        define_methods_of_groups(name, options[:groups])
      end
    end
  end
end
