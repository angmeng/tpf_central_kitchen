require "#{Rails.root.to_s}/lib/calendar_date_select/calendar_date_select"
ActionView::Helpers::FormHelper.send(:include, CalendarDateSelect::FormHelpers)
ActionView::Base.send(:include, CalendarDateSelect::FormHelpers)
ActionView::Base.send(:include, CalendarDateSelect::IncludesHelper)

ActionView::Helpers::InstanceTag.class_eval do
  class << self; alias new_with_backwards_compatibility new; end #TODO: singleton_class.class_eval
end