require 'builder'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Toggle < RailsAdmin::Config::Fields::Base
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)
          include RailsAdmin::Engine.routes.url_helpers

          register_instance_option :view_helper do
            :check_box
          end

          register_instance_option :pretty_value do
            def g_link(fv, on, badge)
              bindings[:view].link_to(
                fv.html_safe,
                toggle_path(model_name: abstract_model, id: bindings[:object].id, method: name, on: on.to_s),
                method: :post,
                class: 'badge ' + badge,
                title: I18n.t("admin.toggle.#{abstract_model.to_s.underscore}.#{name}_#{on}", default: I18n.t("admin.toggle.title_#{on}"))
              )
            end

            case value
              when nil
                g_link('&#x2718;', 0, 'badge-important') + g_link('&#x2713;', 1, 'badge-success')
              when false
                g_link('&#x2718;', 1, 'badge-important')
              when true
                g_link('&#x2713', 0, 'badge-success')
              else
                %{<span class="badge">-</span>}
            end.html_safe
          end

          register_instance_option :export_value do
            value.inspect
          end

          # Accessor for field's help text displayed below input field.
          register_instance_option :help do
            ""
          end

          def type
            @type ||= :boolean
          end
        end
      end
    end
  end
end