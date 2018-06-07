Deface::Override.new(
  virtual_path: "spree/admin/shared/sub_menu/_configuration",
  name: "add_events_tracker_tab_to_configuration_sidebar",
  insert_bottom: "[data-hook='admin_configurations_sidebar_menu']",
  text: "<%= configurations_sidebar_menu_item Spree.t(:events_tracker), edit_admin_events_tracker_setting_path %>",
)
