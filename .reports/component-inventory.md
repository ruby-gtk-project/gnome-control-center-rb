# gnome-control-center — upstream component inventory

Generated for the full-parity Ruby GTK4/Libadwaita port on the `ruby` branch.
Upstream ref: `origin/main` (`a53c22ada`). Inventory method: the
`component-identification` skill — blueprint/`.ui` declarative files read first,
then the `component-scan.sh` scan over the whole tree, then the C sources for the
widget classes that have no declarative file.

## Totals

| | Upstream (`origin/main`) | Port (`ruby` branch `lib/`) |
|---|---:|---:|
| Component units (widget classes + standalone UI objects) | 212 | 1 (placeholder `Application`) |
| Widget rows (scan, summed counts) | 2519 | ~6 |
| Distinct widget types | 92 | 5 |
| Distinct CSS classes | 107 | 0 |
| Distinct signals | 237 | 1 (`activate`) |
| Blueprint `.blp` files | 161 | 0 (house style builds in Ruby) |
| GtkBuilder `.ui` files | 5 | 0 |
| Panels registered in `cc-panel-loader.c` | 26 | 0 |
| GSettings schemas shipped by the app itself | 1 (`org.gnome.Settings`) | 0 |
| App stylesheet | `shell/style.css` | none |
| `po/LINGUAS` locales / `po/POTFILES.in` entries | 112 / 302 | 0 / 0 |

Nothing in `lib/` is a port of an upstream component yet. `lib/gnome_control_center/application.rb`
exists but is the generated placeholder (an `Adwaita::StatusPage` reading "The Ruby port has not
been written yet"), so every row below is `no`.

## Component table

One row per unit. `×` is the scan's summed widget count for the unit (both halves of a
`.blp` + `.c` pair unioned), a size estimate, not a parity target. Present = does a
corresponding file exist in `lib/` on `ruby`.

### Shell — the window, the sidebar, the panel base class, the app

| Upstream file(s) | → `lib/` | Kind | × | CSS classes | Signals | Actions | Present |
|---|---|---|---:|---|---:|---|---|
| `shell/cc-application.c` | `lib/gnome_control_center/application.rb` | application | 1 | — | 0 | `app.about`, `app.help`, `app.quit`, `app.shortcuts`, `app.launch-panel`, `app.launch-single-panel-mode` | placeholder only |
| `shell/cc-panel-list.blp` + `shell/cc-panel-list.c` | `lib/panel_list.rb` | widget | 11 | `compact`, `dim-label`, `navigation-sidebar` | 2 | — | no |
| `shell/cc-panel.blp` + `shell/cc-panel.c` | `lib/panel.rb` | page | 2 | — | 0 | — | no |
| `shell/cc-shell-model.c` | `lib/shell_model.rb` | model (backend) | 0 | — | 0 | — | no |
| `shell/cc-window.blp` + `shell/cc-window.c` | `lib/window.rb` | window (main) | 13 | — | 4 | `app.about`, `app.help`, `app.shortcuts`, `navigation.push` | no |
| `shell/shortcuts-dialog.blp` | `lib/shortcuts_dialog.rb` | shortcuts dialog | 9 | — | 0 | `app.help`, `app.shortcuts` | no |

### Shared rows and editors (panels/common)

| Upstream file(s) | → `lib/` | Kind | × | CSS classes | Signals | Actions | Present |
|---|---|---|---:|---|---:|---|---|
| `panels/common/cc-content-row.blp` + `panels/common/cc-content-row.c` | `lib/content_row.rb` | row | 17 | `content`, `contents`, `header`, `prefixes`, `subtitle`, `suffixes`, `title` | 2 | — | no |
| `panels/common/cc-duration-editor.blp` + `panels/common/cc-duration-editor.c` | `lib/duration_editor.rb` | widget | 2 | — | 1 | — | no |
| `panels/common/cc-duration-row.blp` + `panels/common/cc-duration-row.c` | `lib/duration_row.rb` | row | 6 | `combo`, `dropdown-arrow`, `has-open-popup`, `menu` | 0 | — | no |
| `panels/common/cc-hostname-entry.c` | `lib/hostname_entry.rb` | row | 1 | — | 1 | — | no |
| `panels/common/cc-illustrated-row.blp` + `panels/common/cc-illustrated-row.c` | `lib/illustrated_row.rb` | row | 2 | `background`, `frame`, `illustrated` | 2 | — | no |
| `panels/common/cc-language-chooser.blp` + `panels/common/cc-language-chooser.c` | `lib/language_chooser.rb` | dialog | 14 | `dim-label`, `suggested-action` | 3 | — | no |
| `panels/common/cc-language-row.blp` + `panels/common/cc-language-row.c` | `lib/language_row.rb` | row | 6 | `dim-label` | 0 | — | no |
| `panels/common/cc-list-row-info-button.blp` + `panels/common/cc-list-row-info-button.c` | `lib/list_row_info_button.rb` | widget | 4 | `flat` | 1 | — | no |
| `panels/common/cc-list-row.blp` + `panels/common/cc-list-row.c` | `lib/list_row.rb` | row | 4 | `dim-label` | 0 | — | no |
| `panels/common/cc-number-row.c` | `lib/number_row.rb` | widget | 1 | — | 1 | — | no |
| `panels/common/cc-permission-infobar.blp` + `panels/common/cc-permission-infobar.c` | `lib/permission_infobar.rb` | widget | 3 | — | 2 | — | no |
| `panels/common/cc-split-row.blp` + `panels/common/cc-split-row.c` | `lib/split_row.rb` | row | 18 | `activatable`, `background`, `frame`, `illustrated`, `split-row`, `subtitle`, `title` | 3 | — | no |
| `panels/common/cc-time-editor.blp` + `panels/common/cc-time-editor.c` | `lib/time_editor.rb` | widget | 2 | — | 1 | — | no |
| `panels/common/cc-timelike-editor-layout.c` | `lib/timelike_editor_layout.rb` | layout manager | 0 | — | 0 | — | no |
| `panels/common/cc-timelike-editor.blp` + `panels/common/cc-timelike-editor.c` | `lib/timelike_editor.rb` | widget | 10 | `circular`, `flat`, `title-3`, `titlebutton` | 5 | — | no |
| `panels/common/cc-timelike-entry.c` | `lib/timelike_entry.rb` | widget | 2 | — | 2 | — | no |

### Apps panel

| Upstream file(s) | → `lib/` | Kind | × | CSS classes | Signals | Actions | Present |
|---|---|---|---:|---|---:|---|---|
| `panels/applications/cc-applications-panel.blp` + `panels/applications/cc-applications-panel.c` | `lib/applications_panel.rb` | panel | 70 | `boxed-list`, `destructive-action`, `flat`, `icon-dropshadow`, `pill`, `property`, `suggested-action`, `title-1` | 12 | `navigation.push` | no |
| `panels/applications/cc-application-shortcut-dialog.blp` + `panels/applications/cc-application-shortcut-dialog.c` | `lib/application_shortcut_dialog.rb` | dialog | 8 | `destructive-action` | 6 | — | no |
| `panels/applications/cc-applications-row.blp` + `panels/applications/cc-applications-row.c` | `lib/applications_row.rb` | row | 4 | `lowres-icon` | 0 | — | no |
| `panels/applications/cc-default-apps-page.blp` + `panels/applications/cc-default-apps-page.c` | `lib/default_apps_page.rb` | page | 8 | — | 2 | — | no |
| `panels/applications/cc-default-apps-row.c` | `lib/default_apps_row.rb` | row | 7 | `dim-label`, `icon-dropshadow` | 4 | — | no |
| `panels/applications/cc-removable-media-settings.ui` + `panels/applications/cc-removable-media-settings.c` | `lib/removable_media_settings.rb` | widget | 22 | — | 4 | — | no |
| `panels/applications/cc-snap-row.ui` + `panels/applications/cc-snap-row.c` | `lib/snap_row.rb` | widget | 4 | — | 3 | — | no |

### Appearance panel

| Upstream file(s) | → `lib/` | Kind | × | CSS classes | Signals | Actions | Present |
|---|---|---|---:|---|---:|---|---|
| `panels/background/cc-background-panel.blp` + `panels/background/cc-background-panel.c` | `lib/background_panel.rb` | panel | 21 | `accent-button`, `background-preview-button`, `card`, `flat` | 5 | — | no |
| `panels/background/cc-background-chooser.blp` + `panels/background/cc-background-chooser.c` | `lib/background_chooser.rb` | widget | 13 | `active-item`, `background-flowbox`, `background-thumbnail`, `circular`, `osd`, `remove-button`, `selected-check`, `slideshow-icon` | 5 | — | no |
| `panels/background/cc-background-preview.blp` + `panels/background/cc-background-preview.c` | `lib/background_preview.rb` | widget | 7 | `back`, `background`, `dark`, `front`, `header-bar`, `light`, `sidebar`, `window` | 0 | — | no |

### Bluetooth panel

| Upstream file(s) | → `lib/` | Kind | × | CSS classes | Signals | Actions | Present |
|---|---|---|---:|---|---:|---|---|
| `panels/bluetooth/cc-bluetooth-panel.blp` + `panels/bluetooth/cc-bluetooth-panel.c` | `lib/bluetooth_panel.rb` | panel | 9 | `pill`, `suggested-action` | 5 | — | no |

### Color Management panel

| Upstream file(s) | → `lib/` | Kind | × | CSS classes | Signals | Actions | Present |
|---|---|---|---:|---|---:|---|---|
| `panels/color/cc-color-calibrate.blp` + `panels/color/cc-color-calibrate.c` | `lib/color_calibrate.rb` | widget | 9 | `cc-color-calibrate-window` | 3 | — | no |
| `panels/color/cc-color-cell-renderer-text.c` | `lib/color_cell_renderer_text.rb` | cell renderer | 0 | `dim-label` | 0 | — | no |
| `panels/color/cc-color-device.blp` + `panels/color/cc-color-device.c` | `lib/color_device.rb` | row | 5 | `dim-label`, `flat` | 3 | — | no |
| `panels/color/cc-color-panel.ui` + `panels/color/cc-color-panel.c` | `lib/color_panel.rb` | widget | 69 | `boxed-list`, `dim-label`, `linked`, `suggested-action` | 17 | — | no |
| `panels/color/cc-color-profile.blp` + `panels/color/cc-color-profile.c` | `lib/color_profile.rb` | row | 3 | — | 1 | — | no |

### Displays panel

| Upstream file(s) | → `lib/` | Kind | × | CSS classes | Signals | Actions | Present |
|---|---|---|---:|---|---:|---|---|
| `panels/display/cc-display-panel.blp` + `panels/display/cc-display-panel.c` | `lib/display_panel.rb` | panel | 38 | `monitor-label`, `suggested-action` | 12 | `navigation.push` | no |
| `panels/display/cc-display-arrangement.c` | `lib/display_arrangement.rb` | widget | 1 | `monitor`, `monitor-label`, `primary` | 3 | — | no |
| `panels/display/cc-display-settings.blp` + `panels/display/cc-display-settings.c` | `lib/display_settings.rb` | widget | 18 | `boxed-list` | 0 | — | no |
| `panels/display/cc-night-light-page.blp` + `panels/display/cc-night-light-page.c` | `lib/night_light_page.rb` | widget | 31 | `dim-label`, `heading`, `night-light-temperature`, `padded-spinbutton`, `time-widget`, `title`, `unpadded-button` | 7 | — | no |

### Keyboard panel

| Upstream file(s) | → `lib/` | Kind | × | CSS classes | Signals | Actions | Present |
|---|---|---|---:|---|---:|---|---|
| `panels/keyboard/cc-keyboard-panel.blp` + `panels/keyboard/cc-keyboard-panel.c` | `lib/keyboard_panel.rb` | panel | 11 | — | 1 | — | no |
| `panels/keyboard/cc-input-chooser.blp` + `panels/keyboard/cc-input-chooser.c` | `lib/input_chooser.rb` | dialog | 28 | `boxed-list`, `dim-label`, `flat`, `suggested-action`, `toolbar` | 6 | `window.close` | no |
| `panels/keyboard/cc-input-list-box.blp` + `panels/keyboard/cc-input-list-box.c` | `lib/input_list_box.rb` | widget | 4 | `boxed-list` | 10 | — | no |
| `panels/keyboard/cc-input-row.blp` + `panels/keyboard/cc-input-row.c` | `lib/input_row.rb` | row | 5 | `drag-handle`, `flat` | 4 | `row.move-down`, `row.move-up`, `row.remove`, `row.show-layout`, `row.show-settings` | no |
| `panels/keyboard/cc-input-source-ibus.c` | `lib/input_source_ibus.rb` | backend object | 0 | — | 0 | — | no |
| `panels/keyboard/cc-input-source-xkb.c` | `lib/input_source_xkb.rb` | backend object | 0 | — | 0 | — | no |
| `panels/keyboard/cc-keyboard-shortcut-editor.blp` + `panels/keyboard/cc-keyboard-shortcut-editor.c` | `lib/keyboard_shortcut_editor.rb` | dialog | 31 | `destructive-action`, `dim-label`, `edit-icon`, `pill`, `property`, `suggested-action`, `title-2` | 5 | — | no |
| `panels/keyboard/cc-keyboard-shortcut-group.blp` + `panels/keyboard/cc-keyboard-shortcut-group.c` | `lib/keyboard_shortcut_group.rb` | group | 4 | `boxed-list` | 4 | — | no |
| `panels/keyboard/cc-keyboard-shortcut-page.blp` + `panels/keyboard/cc-keyboard-shortcut-page.c` | `lib/keyboard_shortcut_page.rb` | page | 25 | `boxed-list`, `destructive-action`, `pill`, `suggested-action` | 10 | `navigation.pop` | no |
| `panels/keyboard/cc-keyboard-shortcut-row.blp` + `panels/keyboard/cc-keyboard-shortcut-row.c` | `lib/keyboard_shortcut_row.rb` | row | 6 | `circular`, `dim-label`, `flat`, `heading` | 2 | — | no |
| `panels/keyboard/cc-xkb-modifier-page.blp` + `panels/keyboard/cc-xkb-modifier-page.c` | `lib/xkb_modifier_page.rb` | page | 10 | — | 2 | — | no |

### Mouse & Touchpad panel

| Upstream file(s) | → `lib/` | Kind | × | CSS classes | Signals | Actions | Present |
|---|---|---|---:|---|---:|---|---|
| `panels/mouse/cc-mouse-panel.blp` + `panels/mouse/cc-mouse-panel.c` | `lib/mouse_panel.rb` | panel | 41 | — | 4 | — | no |
| `panels/mouse/cc-mouse-test.blp` + `panels/mouse/cc-mouse-test.c` | `lib/mouse_test.rb` | window | 22 | `bottom-arrow`, `circular`, `click-status-emblem`, `mouse-test-arrow`, `mouse-test-viewport`, `success`, `title-1`, `title-4`, `top-arrow` | 3 | — | no |

### Multitasking panel

| Upstream file(s) | → `lib/` | Kind | × | CSS classes | Signals | Actions | Present |
|---|---|---|---:|---|---:|---|---|
| `panels/multitasking/cc-multitasking-panel.blp` + `panels/multitasking/cc-multitasking-panel.c` | `lib/multitasking_panel.rb` | panel | 22 | — | 1 | — | no |

### Network — connection editor

| Upstream file(s) | → `lib/` | Kind | × | CSS classes | Signals | Actions | Present |
|---|---|---|---:|---|---:|---|---|
| `panels/network/connection-editor/8021x-security-page.blp` | `lib/8021x_security_page.rb` | widget | 6 | — | 0 | — | no |
| `panels/network/connection-editor/bluetooth-page.blp` | `lib/bluetooth_page.rb` | widget | 3 | — | 0 | — | no |
| `panels/network/connection-editor/ce-ip-address-entry.c` | `lib/ip_address_entry.rb` | widget | 1 | — | 1 | — | no |
| `panels/network/connection-editor/ce-netmask-entry.c` | `lib/netmask_entry.rb` | widget | 1 | — | 1 | — | no |
| `panels/network/connection-editor/ce-page-8021x-security.c` | `lib/page_8021x_security.rb` | widget | 1 | — | 3 | — | no |
| `panels/network/connection-editor/ce-page-bluetooth.c` | `lib/page_bluetooth.rb` | widget | 1 | — | 2 | — | no |
| `panels/network/connection-editor/ce-page-details.c` | `lib/page_details.rb` | widget | 2 | — | 5 | — | no |
| `panels/network/connection-editor/ce-page-ethernet.c` | `lib/page_ethernet.rb` | widget | 1 | — | 4 | — | no |
| `panels/network/connection-editor/ce-page-ip4.c` | `lib/page_ip4.rb` | widget | 10 | `linked`, `warning` | 7 | — | no |
| `panels/network/connection-editor/ce-page-ip6.c` | `lib/page_ip6.rb` | widget | 12 | `linked`, `warning` | 7 | — | no |
| `panels/network/connection-editor/ce-page-security.c` | `lib/page_security.rb` | widget | 1 | — | 3 | — | no |
| `panels/network/connection-editor/ce-page-vpn.c` | `lib/page_vpn.rb` | widget | 1 | — | 3 | — | no |
| `panels/network/connection-editor/ce-page-wifi.c` | `lib/page_wifi.rb` | widget | 1 | — | 2 | — | no |
| `panels/network/connection-editor/ce-page-wireguard.c` | `lib/page_wireguard.rb` | widget | 2 | — | 4 | — | no |
| `panels/network/connection-editor/connection-editor.blp` | `lib/connection_editor.rb` | window | 11 | `suggested-action` | 1 | — | no |
| `panels/network/connection-editor/details-page.blp` | `lib/details_page.rb` | widget | 32 | `caption`, `destructive-action`, `dim-label`, `pill` | 0 | — | no |
| `panels/network/connection-editor/ethernet-page.blp` | `lib/ethernet_page.rb` | widget | 13 | — | 0 | — | no |
| `panels/network/connection-editor/ip4-page.blp` | `lib/ip4_page.rb` | widget | 42 | `caption`, `dim-label`, `heading` | 0 | `ip4page.ip4method` | no |
| `panels/network/connection-editor/ip6-page.blp` | `lib/ip6_page.rb` | widget | 43 | `caption`, `dim-label`, `heading` | 0 | `ip6page.ip6method` | no |
| `panels/network/connection-editor/net-connection-editor.c` | `lib/net_connection_editor.rb` | widget | 6 | `boxed-list` | 4 | — | no |
| `panels/network/connection-editor/security-page.blp` | `lib/security_page.rb` | widget | 6 | — | 0 | — | no |
| `panels/network/connection-editor/vpn-page.blp` | `lib/vpn_page.rb` | widget | 7 | — | 0 | — | no |
| `panels/network/connection-editor/wifi-page.blp` | `lib/wifi_page.rb` | widget | 12 | — | 0 | — | no |
| `panels/network/connection-editor/wireguard-page.blp` | `lib/wireguard_page.rb` | widget | 26 | `boxed-list`, `flat`, `heading` | 3 | — | no |
| `panels/network/connection-editor/wireguard-peer.blp` | `lib/wireguard_peer.rb` | widget | 24 | `destructive-action`, `flat`, `suggested-action` | 0 | — | no |

### Network and Wi-Fi panels

| Upstream file(s) | → `lib/` | Kind | × | CSS classes | Signals | Actions | Present |
|---|---|---|---:|---|---:|---|---|
| `panels/network/cc-network-panel.blp` + `panels/network/cc-network-panel.c` | `lib/network_panel.rb` | panel | 14 | `boxed-list`, `cc-placeholder-row`, `dim-label`, `flat` | 7 | `navigation.push` | no |
| `panels/network/cc-wifi-panel.blp` + `panels/network/cc-wifi-panel.c` | `lib/wifi_panel.rb` | panel | 24 | `card`, `destructive-action`, `heading`, `pill`, `qr-image`, `title`, `title-1` | 7 | — | no |
| `panels/network/cc-net-proxy-page.blp` + `panels/network/cc-net-proxy-page.c` | `lib/net_proxy_page.rb` | page | 31 | `dim-label`, `suggested-action` | 3 | — | no |
| `panels/network/cc-qr-code-dialog.blp` + `panels/network/cc-qr-code-dialog.c` | `lib/qr_code_dialog.rb` | dialog | 11 | `card`, `property`, `qr-image` | 0 | — | no |
| `panels/network/cc-wifi-connection-list.c` | `lib/wifi_connection_list.rb` | widget | 3 | `boxed-list`, `cc-placeholder-row`, `dim-label` | 11 | — | no |
| `panels/network/cc-wifi-connection-row.blp` + `panels/network/cc-wifi-connection-row.c` | `lib/wifi_connection_row.rb` | row | 10 | `flat` | 1 | — | no |
| `panels/network/cc-wifi-hotspot-dialog.blp` + `panels/network/cc-wifi-hotspot-dialog.c` | `lib/wifi_hotspot_dialog.rb` | dialog | 16 | `caption`, `dim-label`, `suggested-action` | 3 | — | no |
| `panels/network/net-device-bluetooth.c` | `lib/net_device_bluetooth.rb` | row | 1 | — | 2 | — | no |
| `panels/network/net-device-ethernet.c` | `lib/net_device_ethernet.rb` | group | 10 | `dim-label` | 3 | — | no |
| `panels/network/net-device-mobile.c` | `lib/net_device_mobile.rb` | widget | 1 | — | 4 | — | no |
| `panels/network/net-device-wifi.c` | `lib/net_device_wifi.rb` | widget | 1 | — | 11 | — | no |
| `panels/network/net-vpn.c` | `lib/net_vpn.rb` | row | 1 | — | 3 | — | no |
| `panels/network/network-bluetooth.blp` | `lib/network_bluetooth.rb` | row | 3 | `flat` | 1 | — | no |
| `panels/network/network-ethernet.blp` | `lib/network_ethernet.rb` | group | 10 | `boxed-list`, `cc-placeholder-row`, `dim-label`, `flat` | 2 | — | no |
| `panels/network/network-mobile.ui` | `lib/network_mobile.rb` | widget | 26 | `dim-label`, `flat`, `title-4` | 3 | — | no |
| `panels/network/network-vpn.blp` | `lib/network_vpn.rb` | row | 3 | `flat` | 1 | — | no |
| `panels/network/network-wifi.blp` | `lib/network_wifi.rb` | widget | 16 | `boxed-list`, `property` | 1 | — | no |

### Notifications panel

| Upstream file(s) | → `lib/` | Kind | × | CSS classes | Signals | Actions | Present |
|---|---|---|---:|---|---:|---|---|
| `panels/notifications/cc-notifications-panel.blp` + `panels/notifications/cc-notifications-panel.c` | `lib/notifications_panel.rb` | panel | 9 | `boxed-list`, `lowres-icon` | 3 | — | no |
| `panels/notifications/cc-app-notifications-page.blp` + `panels/notifications/cc-app-notifications-page.c` | `lib/app_notifications_page.rb` | page | 14 | — | 1 | — | no |

### Online Accounts panel

| Upstream file(s) | → `lib/` | Kind | × | CSS classes | Signals | Actions | Present |
|---|---|---|---:|---|---:|---|---|
| `panels/online-accounts/cc-online-accounts-panel.blp` + `panels/online-accounts/cc-online-accounts-panel.c` | `lib/online_accounts_panel.rb` | panel | 10 | `boxed-list` | 3 | — | no |
| `panels/online-accounts/cc-online-account-provider-row.blp` + `panels/online-accounts/cc-online-account-provider-row.c` | `lib/online_account_provider_row.rb` | row | 4 | `lowres-icon`, `symbolic-circular` | 0 | — | no |
| `panels/online-accounts/cc-online-account-row.blp` + `panels/online-accounts/cc-online-account-row.c` | `lib/online_account_row.rb` | row | 7 | `error-box`, `lowres-icon`, `symbolic-circular` | 0 | — | no |

### Power panel

| Upstream file(s) | → `lib/` | Kind | × | CSS classes | Signals | Actions | Present |
|---|---|---|---:|---|---:|---|---|
| `panels/power/cc-power-panel.blp` + `panels/power/cc-power-panel.c` | `lib/power_panel.rb` | panel | 34 | `boxed-list` | 7 | — | no |
| `panels/power/cc-battery-row.blp` + `panels/power/cc-battery-row.c` | `lib/battery_row.rb` | row | 12 | `dim-label` | 0 | — | no |
| `panels/power/cc-power-profile-info-row.blp` + `panels/power/cc-power-profile-info-row.c` | `lib/power_profile_info_row.rb` | row | 3 | `power-profile-info-row` | 0 | — | no |
| `panels/power/cc-power-profile-row.blp` + `panels/power/cc-power-profile-row.c` | `lib/power_profile_row.rb` | row | 3 | — | 1 | — | no |

### Printers panel

| Upstream file(s) | → `lib/` | Kind | × | CSS classes | Signals | Actions | Present |
|---|---|---|---:|---|---:|---|---|
| `panels/printers/cc-printers-panel.blp` + `panels/printers/cc-printers-panel.c` | `lib/printers_panel.rb` | panel | 19 | `boxed-list-separate`, `pill`, `suggested-action` | 9 | — | no |
| `panels/printers/pp-details-dialog.blp` + `panels/printers/pp-details-dialog.c` | `lib/details_dialog.rb` | dialog | 20 | `caption`, `flat`, `property`, `warning` | 3 | — | no |
| `panels/printers/pp-ipp-option-widget.c` | `lib/ipp_option_widget.rb` | widget | 4 | — | 3 | — | no |
| `panels/printers/pp-job-row.blp` + `panels/printers/pp-job-row.c` | `lib/job_row.rb` | row | 6 | `dim-label`, `flat` | 1 | — | no |
| `panels/printers/pp-jobs-dialog.blp` + `panels/printers/pp-jobs-dialog.c` | `lib/jobs_dialog.rb` | dialog | 28 | `boxed-list`, `destructive-action`, `dim-label`, `heading` | 4 | — | no |
| `panels/printers/pp-new-printer-dialog.ui` + `panels/printers/pp-new-printer-dialog.c` | `lib/new_printer_dialog.rb` | widget | 30 | `background`, `heading`, `suggested-action`, `toolbar`, `view` | 6 | — | no |
| `panels/printers/pp-options-dialog.blp` + `panels/printers/pp-options-dialog.c` | `lib/options_dialog.rb` | window | 14 | `dim-label`, `navigation-sidebar`, `printer-options-sidebar`, `suggested-action` | 2 | — | no |
| `panels/printers/pp-ppd-option-widget.c` | `lib/ppd_option_widget.rb` | widget | 5 | — | 2 | — | no |
| `panels/printers/pp-ppd-selection-dialog.blp` + `panels/printers/pp-ppd-selection-dialog.c` | `lib/ppd_selection_dialog.rb` | window | 15 | `suggested-action` | 3 | — | no |
| `panels/printers/pp-printer-entry.blp` + `panels/printers/pp-printer-entry.c` | `lib/printer_entry.rb` | row | 22 | `dim-label`, `flat`, `heading`, `title-2` | 2 | `printer.clean-heads`, `printer.default`, `printer.details`, `printer.options`, `printer.remove` | no |
| `panels/printers/pp-samba-stub.c` | `lib/samba_stub.rb` | backend object | 0 | — | 0 | — | no |
| `panels/printers/pp-samba.c` | `lib/samba.rb` | backend object | 0 | — | 0 | — | no |

### Privacy & Security panel

| Upstream file(s) | → `lib/` | Kind | × | CSS classes | Signals | Actions | Present |
|---|---|---|---:|---|---:|---|---|
| `panels/privacy/cc-privacy-panel.blp` + `panels/privacy/cc-privacy-panel.c` | `lib/privacy_panel.rb` | panel | 5 | — | 0 | `navigation.push` | no |
| `panels/privacy/bolt/cc-bolt-device-dialog.blp` + `panels/privacy/bolt/cc-bolt-device-dialog.c` | `lib/bolt_device_dialog.rb` | dialog | 16 | `destructive-action`, `property`, `suggested-action` | 2 | — | no |
| `panels/privacy/bolt/cc-bolt-device-entry.blp` + `panels/privacy/bolt/cc-bolt-device-entry.c` | `lib/bolt_device_entry.rb` | row | 3 | — | 1 | — | no |
| `panels/privacy/bolt/cc-bolt-page.blp` + `panels/privacy/bolt/cc-bolt-page.c` | `lib/bolt_page.rb` | page | 27 | `boxed-list`, `heading`, `view` | 9 | — | no |
| `panels/privacy/camera/cc-camera-page.blp` + `panels/privacy/camera/cc-camera-page.c` | `lib/camera_page.rb` | page | 13 | `boxed-list`, `cc-placeholder-row`, `dim-label` | 2 | — | no |
| `panels/privacy/diagnostics/cc-diagnostics-page.blp` + `panels/privacy/diagnostics/cc-diagnostics-page.c` | `lib/diagnostics_page.rb` | page | 7 | — | 0 | — | no |
| `panels/privacy/firmware-security/cc-firmware-security-boot-dialog.blp` + `panels/privacy/firmware-security/cc-firmware-security-boot-dialog.c` | `lib/firmware_security_boot_dialog.rb` | dialog | 9 | `error`, `good`, `security-level-icon`, `title-2` | 0 | — | no |
| `panels/privacy/firmware-security/cc-firmware-security-dialog.blp` + `panels/privacy/firmware-security/cc-firmware-security-dialog.c` | `lib/firmware_security_dialog.rb` | dialog | 11 | `error`, `good`, `neutral`, `pill`, `security-level-icon`, `title-2`, `warning` | 1 | — | no |
| `panels/privacy/firmware-security/cc-firmware-security-help-dialog.blp` + `panels/privacy/firmware-security/cc-firmware-security-help-dialog.c` | `lib/firmware_security_help_dialog.rb` | dialog | 5 | — | 0 | — | no |
| `panels/privacy/firmware-security/cc-firmware-security-page.blp` + `panels/privacy/firmware-security/cc-firmware-security-page.c` | `lib/firmware_security_page.rb` | page | 27 | `caption`, `card`, `compact`, `dim-label`, `error`, `error-icon`, `good`, `heading`, `hide-arrow`, `image-button`, `neutral`, `security-level-icon`, `success-icon`, `warning` | 1 | — | no |
| `panels/privacy/location/cc-location-page.blp` + `panels/privacy/location/cc-location-page.c` | `lib/location_page.rb` | page | 14 | `boxed-list`, `cc-placeholder-row`, `dim-label` | 2 | — | no |
| `panels/privacy/screen/cc-screen-page.blp` + `panels/privacy/screen/cc-screen-page.c` | `lib/screen_page.rb` | page | 11 | — | 2 | — | no |
| `panels/privacy/usage/cc-usage-page.blp` + `panels/privacy/usage/cc-usage-page.c` | `lib/usage_page.rb` | page | 18 | `destructive-action` | 1 | — | no |

### Search panel

| Upstream file(s) | → `lib/` | Kind | × | CSS classes | Signals | Actions | Present |
|---|---|---|---:|---|---:|---|---|
| `panels/search/cc-search-panel.blp` + `panels/search/cc-search-panel.c` | `lib/search_panel.rb` | panel | 8 | `boxed-list`, `cc-placeholder-row`, `dim-label` | 3 | `navigation.push` | no |
| `panels/search/cc-search-locations-page.blp` + `panels/search/cc-search-locations-page.c` | `lib/search_locations_page.rb` | page | 16 | `boxed-list`, `flat` | 4 | — | no |
| `panels/search/cc-search-panel-row.blp` + `panels/search/cc-search-panel-row.c` | `lib/search_panel_row.rb` | row | 8 | `drag-handle`, `flat`, `lowres-icon` | 3 | `row.move-down`, `row.move-up` | no |

### Sharing panel

| Upstream file(s) | → `lib/` | Kind | × | CSS classes | Signals | Actions | Present |
|---|---|---|---:|---|---:|---|---|
| `panels/sharing/cc-sharing-panel.blp` + `panels/sharing/cc-sharing-panel.c` | `lib/sharing_panel.rb` | panel | 34 | `boxed-list`, `flat`, `property` | 4 | `navigation.push` | no |
| `panels/sharing/cc-sharing-networks.blp` + `panels/sharing/cc-sharing-networks.c` | `lib/sharing_networks.rb` | group | 10 | `boxed-list`, `cc-placeholder-row`, `dim-label`, `flat` | 3 | — | no |

### Sound panel

| Upstream file(s) | → `lib/` | Kind | × | CSS classes | Signals | Actions | Present |
|---|---|---|---:|---|---:|---|---|
| `panels/sound/cc-sound-panel.blp` + `panels/sound/cc-sound-panel.c` | `lib/sound_panel.rb` | panel | 25 | — | 6 | — | no |
| `panels/sound/cc-alert-chooser-page.blp` + `panels/sound/cc-alert-chooser-page.c` | `lib/alert_chooser_page.rb` | page | 16 | — | 2 | — | no |
| `panels/sound/cc-balance-slider.blp` + `panels/sound/cc-balance-slider.c` | `lib/balance_slider.rb` | widget | 3 | — | 2 | — | no |
| `panels/sound/cc-device-combo-row.blp` + `panels/sound/cc-device-combo-row.c` | `lib/device_combo_row.rb` | row | 8 | — | 5 | — | no |
| `panels/sound/cc-fade-slider.blp` + `panels/sound/cc-fade-slider.c` | `lib/fade_slider.rb` | widget | 3 | — | 2 | — | no |
| `panels/sound/cc-level-bar.c` | `lib/level_bar.rb` | widget | 2 | — | 0 | — | no |
| `panels/sound/cc-output-test-wheel.c` | `lib/output_test_wheel.rb` | widget | 3 | `background`, `circular`, `heading`, `test-button-bin` | 0 | — | no |
| `panels/sound/cc-output-test-window.blp` + `panels/sound/cc-output-test-window.c` | `lib/output_test_window.rb` | dialog | 4 | — | 0 | — | no |
| `panels/sound/cc-profile-combo-row.blp` + `panels/sound/cc-profile-combo-row.c` | `lib/profile_combo_row.rb` | row | 7 | — | 5 | — | no |
| `panels/sound/cc-speaker-test-button.c` | `lib/speaker_test_button.rb` | widget | 1 | `playing` | 1 | — | no |
| `panels/sound/cc-stream-row.blp` + `panels/sound/cc-stream-row.c` | `lib/stream_row.rb` | row | 6 | `lowres-icon` | 0 | — | no |
| `panels/sound/cc-subwoofer-slider.blp` + `panels/sound/cc-subwoofer-slider.c` | `lib/subwoofer_slider.rb` | widget | 3 | — | 2 | — | no |
| `panels/sound/cc-volume-levels-page.blp` + `panels/sound/cc-volume-levels-page.c` | `lib/volume_levels_page.rb` | page | 8 | — | 3 | — | no |
| `panels/sound/cc-volume-slider.blp` + `panels/sound/cc-volume-slider.c` | `lib/volume_slider.rb` | widget | 4 | `flat` | 3 | `volume-slider.mute` | no |

### System — About page

| Upstream file(s) | → `lib/` | Kind | × | CSS classes | Signals | Actions | Present |
|---|---|---|---:|---|---:|---|---|
| `panels/system/about/cc-about-page.blp` + `panels/system/about/cc-about-page.c` | `lib/about_page.rb` | page | 29 | `flat`, `property`, `suggested-action` | 3 | — | no |

### System — Date & Time

| Upstream file(s) | → `lib/` | Kind | × | CSS classes | Signals | Actions | Present |
|---|---|---|---:|---|---:|---|---|
| `panels/system/datetime/cc-datetime-page.blp` + `panels/system/datetime/cc-datetime-page.c` | `lib/datetime_page.rb` | page | 37 | `boxed-list`, `month-grid` | 15 | — | no |
| `panels/system/datetime/cc-month-row.blp` | `lib/month_row.rb` | row | 4 | `title` | 0 | — | no |
| `panels/system/datetime/cc-tz-dialog.blp` + `panels/system/datetime/cc-tz-dialog.c` | `lib/tz_dialog.rb` | dialog | 11 | `toolbar`, `view` | 4 | — | no |
| `panels/system/datetime/cc-tz-row.blp` | `lib/tz_row.rb` | row | 8 | `caption`, `dim-label`, `heading`, `numeric`, `title` | 0 | — | no |

### System — Region & Language

| Upstream file(s) | → `lib/` | Kind | × | CSS classes | Signals | Actions | Present |
|---|---|---|---:|---|---:|---|---|
| `panels/system/region/cc-region-page.blp` + `panels/system/region/cc-region-page.c` | `lib/region_page.rb` | panel | 7 | — | 7 | — | no |
| `panels/system/region/cc-format-chooser.blp` + `panels/system/region/cc-format-chooser.c` | `lib/format_chooser.rb` | dialog | 29 | `boxed-list`, `circular`, `flat`, `suggested-action`, `title-4`, `toolbar` | 4 | — | no |
| `panels/system/region/cc-format-preview.blp` + `panels/system/region/cc-format-preview.c` | `lib/format_preview.rb` | group | 8 | `property` | 0 | — | no |

### System — Remote Desktop / Desktop Sharing

| Upstream file(s) | → `lib/` | Kind | × | CSS classes | Signals | Actions | Present |
|---|---|---|---:|---|---:|---|---|
| `panels/system/remote-desktop/cc-desktop-sharing-page.blp` + `panels/system/remote-desktop/cc-desktop-sharing-page.c` | `lib/desktop_sharing_page.rb` | widget | 22 | `flat`, `property` | 6 | — | no |
| `panels/system/remote-desktop/cc-encryption-fingerprint-dialog.blp` + `panels/system/remote-desktop/cc-encryption-fingerprint-dialog.c` | `lib/encryption_fingerprint_dialog.rb` | dialog | 8 | `compact`, `tls-cert-fingerprint`, `tls-cert-verification` | 0 | — | no |
| `panels/system/remote-desktop/cc-remote-desktop-page.blp` + `panels/system/remote-desktop/cc-remote-desktop-page.c` | `lib/remote_desktop_page.rb` | page | 8 | — | 0 | — | no |
| `panels/system/remote-desktop/cc-remote-login-page.blp` + `panels/system/remote-desktop/cc-remote-login-page.c` | `lib/remote_login_page.rb` | widget | 20 | `flat`, `property` | 7 | — | no |

### System — Secure Shell

| Upstream file(s) | → `lib/` | Kind | × | CSS classes | Signals | Actions | Present |
|---|---|---|---:|---|---:|---|---|
| `panels/system/secure-shell/cc-secure-shell-page.blp` + `panels/system/secure-shell/cc-secure-shell-page.c` | `lib/secure_shell_page.rb` | dialog | 12 | `dim-label`, `flat`, `property` | 2 | — | no |

### System — Users

| Upstream file(s) | → `lib/` | Kind | × | CSS classes | Signals | Actions | Present |
|---|---|---|---:|---|---:|---|---|
| `panels/system/users/cc-users-page.blp` + `panels/system/users/cc-users-page.c` | `lib/users_page.rb` | panel | 6 | `boxed-list` | 7 | — | no |
| `panels/system/users/cc-add-user-dialog.blp` + `panels/system/users/cc-add-user-dialog.c` | `lib/add_user_dialog.rb` | dialog | 34 | `flat`, `suggested-action` | 7 | — | no |
| `panels/system/users/cc-avatar-chooser.blp` + `panels/system/users/cc-avatar-chooser.c` | `lib/avatar_chooser.rb` | popover | 9 | `suggested-action` | 3 | — | no |
| `panels/system/users/cc-crop-area.c` | `lib/crop_area.rb` | widget | 1 | — | 6 | — | no |
| `panels/system/users/cc-enterprise-login-dialog.blp` + `panels/system/users/cc-enterprise-login-dialog.c` | `lib/enterprise_login_dialog.rb` | dialog | 29 | `error`, `suggested-action` | 3 | — | no |
| `panels/system/users/cc-entry-feedback.blp` + `panels/system/users/cc-entry-feedback.c` | `lib/entry_feedback.rb` | widget | 5 | `caption` | 1 | — | no |
| `panels/system/users/cc-fingerprint-dialog.blp` + `panels/system/users/cc-fingerprint-dialog.c` | `lib/fingerprint_dialog.rb` | dialog | 34 | `circular`, `fingerprint-status-menu`, `fingerprint-status-page`, `fingerprint-touching`, `flat`, `pill`, `success`, `suggested-action` | 7 | — | no |
| `panels/system/users/cc-password-dialog.blp` + `panels/system/users/cc-password-dialog.c` | `lib/password_dialog.rb` | dialog | 20 | `error`, `flat`, `suggested-action` | 5 | — | no |
| `panels/system/users/cc-user-page.blp` + `panels/system/users/cc-user-page.c` | `lib/user_page.rb` | page | 25 | `circular`, `cutout-button`, `destructive-action` | 6 | — | no |

### System panel

| Upstream file(s) | → `lib/` | Kind | × | CSS classes | Signals | Actions | Present |
|---|---|---|---:|---|---:|---|---|
| `panels/system/cc-system-panel.blp` + `panels/system/cc-system-panel.c` | `lib/system_panel.rb` | panel | 7 | — | 1 | `navigation.push` | no |

### Accessibility panel

| Upstream file(s) | → `lib/` | Kind | × | CSS classes | Signals | Actions | Present |
|---|---|---|---:|---|---:|---|---|
| `panels/universal-access/cc-ua-panel.blp` + `panels/universal-access/cc-ua-panel.c` | `lib/ua_panel.rb` | panel | 6 | — | 0 | `navigation.push` | no |
| `panels/universal-access/cc-cursor-size-page.blp` + `panels/universal-access/cc-cursor-size-page.c` | `lib/cursor_size_page.rb` | page | 10 | — | 1 | — | no |
| `panels/universal-access/cc-ua-hearing-page.blp` + `panels/universal-access/cc-ua-hearing-page.c` | `lib/ua_hearing_page.rb` | page | 13 | `dim-label` | 3 | — | no |
| `panels/universal-access/cc-ua-mouse-page.blp` + `panels/universal-access/cc-ua-mouse-page.c` | `lib/ua_mouse_page.rb` | page | 20 | — | 0 | — | no |
| `panels/universal-access/cc-ua-seeing-page.blp` + `panels/universal-access/cc-ua-seeing-page.c` | `lib/ua_seeing_page.rb` | page | 30 | `boxed-list-separate`, `dim-label`, `suggested-action` | 5 | — | no |
| `panels/universal-access/cc-ua-typing-page.blp` + `panels/universal-access/cc-ua-typing-page.c` | `lib/ua_typing_page.rb` | page | 32 | — | 1 | — | no |
| `panels/universal-access/cc-ua-zoom-page.blp` + `panels/universal-access/cc-ua-zoom-page.c` | `lib/ua_zoom_page.rb` | page | 30 | — | 3 | — | no |

### Graphics Tablets (Wacom) panel

| Upstream file(s) | → `lib/` | Kind | × | CSS classes | Signals | Actions | Present |
|---|---|---|---:|---|---:|---|---|
| `panels/wacom/cc-wacom-panel.blp` + `panels/wacom/cc-wacom-panel.c` | `lib/wacom_panel.rb` | panel | 11 | `menu` | 3 | — | no |
| `panels/wacom/button-mapping.blp` | `lib/button_mapping.rb` | window | 8 | `heading` | 1 | — | no |
| `panels/wacom/calibrator/calibrator-gui.c` | `lib/calibrator_gui.rb` | window | 1 | — | 6 | — | no |
| `panels/wacom/calibrator/calibrator.blp` + `panels/wacom/calibrator/calibrator.c` | `lib/calibrator.rb` | window | 16 | — | 0 | — | no |
| `panels/wacom/calibrator/cc-clock.c` | `lib/clock.rb` | widget | 1 | — | 1 | — | no |
| `panels/wacom/cc-drawing-area.c` | `lib/drawing_area.rb` | widget | 1 | — | 2 | — | no |
| `panels/wacom/cc-wacom-button-row.c` | `lib/wacom_button_row.rb` | row | 4 | — | 4 | — | no |
| `panels/wacom/cc-wacom-ekr-page.blp` + `panels/wacom/cc-wacom-ekr-page.c` | `lib/wacom_ekr_page.rb` | widget | 3 | — | 1 | — | no |
| `panels/wacom/cc-wacom-page.blp` + `panels/wacom/cc-wacom-page.c` | `lib/wacom_page.rb` | widget | 11 | `dim-label` | 6 | — | no |
| `panels/wacom/cc-wacom-stylus-action-dialog.blp` + `panels/wacom/cc-wacom-stylus-action-dialog.c` | `lib/wacom_stylus_action_dialog.rb` | dialog | 29 | `dim-label`, `flat` | 4 | — | no |
| `panels/wacom/cc-wacom-stylus-page.blp` + `panels/wacom/cc-wacom-stylus-page.c` | `lib/wacom_stylus_page.rb` | widget | 8 | — | 5 | — | no |
| `panels/wacom/gsd-wacom-key-shortcut-button.c` | `lib/wacom_key_shortcut_button.rb` | widget | 1 | — | 3 | — | no |

### Wellbeing panel

| Upstream file(s) | → `lib/` | Kind | × | CSS classes | Signals | Actions | Present |
|---|---|---|---:|---|---:|---|---|
| `panels/wellbeing/cc-wellbeing-panel.blp` + `panels/wellbeing/cc-wellbeing-panel.c` | `lib/wellbeing_panel.rb` | panel | 20 | `compact`, `destructive-action`, `flat`, `pill` | 18 | — | no |
| `panels/wellbeing/cc-bar-chart-bar.blp` + `panels/wellbeing/cc-bar-chart-bar.c` | `lib/bar_chart_bar.rb` | widget | 2 | — | 0 | — | no |
| `panels/wellbeing/cc-bar-chart-group.blp` + `panels/wellbeing/cc-bar-chart-group.c` | `lib/bar_chart_group.rb` | widget | 2 | — | 1 | — | no |
| `panels/wellbeing/cc-bar-chart.blp` + `panels/wellbeing/cc-bar-chart.c` | `lib/bar_chart.rb` | widget | 4 | `continuous-axis-label`, `discrete-axis-label` | 5 | — | no |
| `panels/wellbeing/cc-break-schedule-row.blp` + `panels/wellbeing/cc-break-schedule-row.c` | `lib/break_schedule_row.rb` | row | 11 | `break-schedule-row` | 5 | — | no |
| `panels/wellbeing/cc-screen-time-statistics-row.blp` + `panels/wellbeing/cc-screen-time-statistics-row.c` | `lib/screen_time_statistics_row.rb` | row | 18 | `circular`, `compact`, `main-box`, `primary-label`, `primary-value`, `screen-time-statistics-row`, `secondary-label`, `secondary-value` | 2 | — | no |

### Mobile Network (WWAN) panel

| Upstream file(s) | → `lib/` | Kind | × | CSS classes | Signals | Actions | Present |
|---|---|---|---:|---|---:|---|---|
| `panels/wwan/cc-wwan-panel.blp` + `panels/wwan/cc-wwan-panel.c` | `lib/wwan_panel.rb` | panel | 21 | `boxed-list`, `pill`, `suggested-action` | 6 | — | no |
| `panels/wwan/cc-wwan-apn-dialog.blp` + `panels/wwan/cc-wwan-apn-dialog.c` | `lib/wwan_apn_dialog.rb` | dialog | 32 | `boxed-list`, `default`, `dim-label`, `error` | 4 | — | no |
| `panels/wwan/cc-wwan-details-dialog.blp` + `panels/wwan/cc-wwan-details-dialog.c` | `lib/wwan_details_dialog.rb` | dialog | 7 | `property` | 1 | — | no |
| `panels/wwan/cc-wwan-device-page.blp` + `panels/wwan/cc-wwan-device-page.c` | `lib/wwan_device_page.rb` | widget | 16 | `boxed-list`, `suggested-action` | 7 | — | no |
| `panels/wwan/cc-wwan-mode-dialog.blp` + `panels/wwan/cc-wwan-mode-dialog.c` | `lib/wwan_mode_dialog.rb` | window | 11 | `boxed-list`, `suggested-action` | 2 | — | no |
| `panels/wwan/cc-wwan-network-dialog.blp` + `panels/wwan/cc-wwan-network-dialog.c` | `lib/wwan_network_dialog.rb` | window | 18 | `boxed-list`, `frame`, `heading`, `suggested-action` | 2 | — | no |
| `panels/wwan/cc-wwan-sim-lock-dialog.blp` + `panels/wwan/cc-wwan-sim-lock-dialog.c` | `lib/wwan_sim_lock_dialog.rb` | window | 21 | `dim-label`, `frame`, `heading`, `suggested-action` | 3 | — | no |

### Global shortcuts provider (separate binary)

| Upstream file(s) | → `lib/` | Kind | × | CSS classes | Signals | Actions | Present |
|---|---|---|---:|---|---:|---|---|
| `global-shortcuts-provider/cc-global-shortcut-dialog.blp` + `global-shortcuts-provider/cc-global-shortcut-dialog.c` | `lib/global_shortcut_dialog.rb` | window | 7 | `suggested-action` | 4 | `window.close` | no |
| `global-shortcuts-provider/control-center-global-shortcuts-provider.c` | `lib/control_center_global_shortcuts_provider.rb` | application | 0 | — | 0 | — | no |

### Shell search provider (separate binary)

| Upstream file(s) | → `lib/` | Kind | × | CSS classes | Signals | Actions | Present |
|---|---|---|---:|---|---:|---|---|
| `search-provider/control-center-search-provider.c` | `lib/control_center_search_provider.rb` | application | 0 | — | 0 | — | no |

### Test-only panels (not user-facing)

| Upstream file(s) | → `lib/` | Kind | × | CSS classes | Signals | Actions | Present |
|---|---|---|---:|---|---:|---|---|
| `tests/interactive-panels/gtp-dynamic-panel.blp` + `tests/interactive-panels/gtp-dynamic-panel.c` | `lib/dynamic_panel.rb` | panel | 0 | — | 0 | — | no |
| `tests/interactive-panels/gtp-static-init.blp` + `tests/interactive-panels/gtp-static-init.c` | `lib/static_init.rb` | panel | 0 | — | 0 | — | no |
| `tests/network/cc-test-window.c` | `lib/test_window.rb` | window | 0 | — | 0 | — | no |
## Non-widget components the table does not cover

### Sidebar panel order (`shell/cc-panel-loader.c`, `default_panels[]`)

The sidebar is not alphabetical and is not built from the `.desktop` files' order;
`cc-panel-loader.c` fixes it, and `cc-panel-list.c` groups it. 26 panels, four
of them build-conditional:

`applications`, `background`, `bluetooth`†, `color`, `display`, `keyboard`,
`mouse`, `multitasking`, `network`†, `wifi`†, `notifications`, `online-accounts`,
`power`, `printers`, `privacy`, `search`, `sharing`, `sound`, `system`,
`universal-access`, `wacom`†, `wellbeing`, `wwan`†

† guarded by `BUILD_BLUETOOTH` / `BUILD_NETWORK` / `BUILD_WACOM` / `BUILD_WWAN`.
`wifi`, `sharing`, `wacom` and `wwan` also run a `static_init_func` that can hide
the panel at runtime when no hardware is present — a panel's visibility is a
component behaviour, not just a list entry.

User-visible panel titles and search keywords come from the 27
`panels/**/gnome-*-panel.desktop.in` files (`Name`, `Comment`, `Keywords`), not from
the C. `about`, `datetime`, `region` and `users` have `.desktop` files but are
subpages of `system`, which is why there are 27 desktop files for 26 loader entries.

### Application actions and accelerators (`shell/cc-application.c`)

| Action | Accel | Notes |
|---|---|---|
| `app.launch-panel` | — | `(sav)`; from D-Bus / command line |
| `app.launch-single-panel-mode` | — | `(sav)`; opens one panel with no sidebar |
| `app.help` | `F1` | opens the help page of the current panel |
| `app.quit` | `<Control>Q` | |
| `app.about` | — | `Adw.AboutDialog` built via `adw_about_dialog_new_from_appdata ("/org/gnome/Settings/metainfo")`, then version and `© 1998 <developer name>` set in code |

Command-line options (`--verbose`, `--search`, `--list`, `--version`, `[PANEL] [ARGUMENT…]`)
are user-facing surface too.

### Menus

Four `menu` definitions, none of which the widget scan sees:

| Where | Items |
|---|---|
| `shell/cc-window.blp` → `primary_menu` | `_Keyboard Shortcuts` (`app.shortcuts`), `_Help` (`app.help`), `_About Settings` (`app.about`) |
| `panels/keyboard/cc-input-row.blp` | `row.move-up`, `row.move-down`, `row.show-layout`, `row.show-settings`, `row.remove` |
| `panels/search/cc-search-panel-row.blp` | `row.move-up`, `row.move-down` |
| `panels/printers/pp-printer-entry.blp` | `printer.default`, `printer.details`, `printer.options`, `printer.clean-heads`, `printer.remove` |

### Keyboard shortcuts dialog (`shell/shortcuts-dialog.blp`)

An `Adw.ShortcutsDialog` with three sections — General (`<Control>Q` Quit,
`<Control>F` Search, `app.help` Show help, `app.shortcuts` Keyboard shortcuts),
Panels (`<Alt>Left` LTR / `<Alt>Right` RTL, Go back to previous panel) and
Search (`Escape` Cancel search). Note `Adwaita::ShortcutsDialog` is new API;
check it exists in the bindings before porting (see Blockers).

### Shortcut catalogues (Keyboard panel)

`panels/keyboard/00-multimedia.xml.in`, `01-input-sources.xml.in`,
`01-launchers.xml.in`, `01-system.xml.in`, `50-accessibility.xml.in` are the
translated, GSettings-backed list of every system shortcut the Keyboard panel
shows. They are data for `keyboard-shortcuts.c`, not widgets, but there is no
Keyboard panel without them — they decide the sections, rows and labels. Target:
one `lib/keyboard_shortcut_catalogue.rb` plus the five XML files carried over as data.

### Empty and error states

43 `Adw.StatusPage` instances across the blueprints, plus the `cc-placeholder-row`
label idiom. The ones worth naming:

| Component | State |
|---|---|
| `shell/cc-panel-list.blp` | "No Results Found" / "Try a different search" (`compact`) — sidebar search placeholder |
| `panels/bluetooth/cc-bluetooth-panel.blp` | "No Bluetooth Found", "Bluetooth Turned Off", "Airplane Mode is On", "Hardware Airplane Mode is On" |
| `panels/printers/cc-printers-panel.blp` | "No Printers", "No Results Found", plus a CUPS-missing state |
| `panels/printers/pp-jobs-dialog.blp` | "No Active Printer Jobs" |
| `panels/privacy/bolt/cc-bolt-page.blp` | "No Thunderbolt Support" |
| `panels/privacy/firmware-security/cc-firmware-security-page.blp` | "Device Security Unavailable", "No Events" |
| `panels/system/users/cc-fingerprint-dialog.blp` | "Error", "No fingerprint device", "Fingerprint Authentication", enrollment view |
| `panels/system/users/cc-enterprise-login-dialog.blp` | "Offline" |
| `panels/wacom/cc-wacom-panel.blp` | "No tablet detected" |
| `panels/system/datetime/cc-tz-dialog.blp`, `panels/system/region/cc-format-chooser.blp`, `panels/keyboard/cc-keyboard-shortcut-page.blp` | "No Results Found" |
| `panels/privacy/camera/cc-camera-page.blp`, `panels/privacy/location/cc-location-page.blp`, `panels/search/cc-search-panel.blp` | `cc-placeholder-row` labels: "No sandboxed apps have asked for camera/location access", "No Apps Found" |

### Settings, resources and style

| Upstream | → port |
|---|---|
| `shell/org.gnome.Settings.gschema.xml` — `last-panel` (`s`), `window-state` (`(iib)`) | `lib/settings.rb` wrapping `Gio::Settings`, plus the schema installed for the dev shell |
| `shell/style.css` — 943 lines, ~60 app-defined selectors (`.cc-placeholder-row`, `.power-profile`, `.background-thumbnail`, `.monitor-label`, `.mouse-test-arrow`, `.security-level-icon`, the eight accent colour classes, …) | one `lib/style.rb` loading a ported `data/style.css` through `Gtk::CssProvider`; the scan counts 107 distinct CSS classes in the blueprints, so the stylesheet is not optional decoration |
| 20 `*.gresource.xml` manifests (icons, SVG assets, mouse/multitasking illustrations, `enter-keyboard-shortcut.svg`, `cc-bar-chart-diagram.svg`) | assets copied to `data/`; the port has no GResource, so a small `lib/resources.rb` resolving asset paths |
| `po/` — 112 locales, `POTFILES.in` with 302 entries | translation parity is its own step (see the `translation-parity` skill); nothing in `lib/` is marked for translation yet |

### Separate binaries

`global-shortcuts-provider/` (its own `Adw.Application` plus `CcGlobalShortcutDialog`,
the XDG global-shortcuts portal UI) and `search-provider/` (the GNOME Shell search
provider, `org.gnome.Settings.SearchProvider`) are shipped alongside the app, not
inside it. They are in the table but are the last things to port.

## Scan caveats recorded while reading

- `s` appeared as an action in `shell/cc-window.c` — a scan false positive from a `GVariant` format string, not an action. Removed from the table.
- `panels/system/datetime/cc-month-row.blp` and `cc-tz-row.blp` are `template ListItem` — `Gtk::SignalListItemFactory` item templates, not widget subclasses. They port as factory `setup`/`bind` blocks inside `lib/datetime_page.rb` and `lib/tz_dialog.rb`, and their own `lib/*.rb` files are optional.
- `panels/wacom/button-mapping.blp` and `panels/color/cc-color-calibrate.blp` declare a bare top-level `Window` with no `template`, loaded by id from C. One unit each regardless.
- Repeaters, which the counts understate: the sidebar rows (`cc-panel-list.c`, one per panel), app rows (`cc-applications-row`), Wi-Fi rows (`cc-wifi-connection-row` over `cc-wifi-connection-list`), printer entries, printer job rows, battery rows, stream rows, user pages, shortcut rows (`cc-keyboard-shortcut-group` builds its rows from the five XML catalogues), bolt device entries, online-account rows, timezone rows, format rows, language rows, wacom button rows, wellbeing bar-chart bars.
- Dynamic CSS classes to chase when porting: `security-level-icon` + `good`/`warning`/`error` on firmware security, the eight accent classes (`blue`, `teal`, `green`, `yellow`, `orange`, `red`, `pink`, `purple`) in Appearance, `power-profile` variants, and the `error`/`warning`/`success` entry feedback in `cc-entry-feedback`.
- `panels/printers/pp-samba.c` / `pp-samba-stub.c`, `shell/cc-shell-model.c`, `panels/keyboard/cc-input-source-{ibus,xkb}.c` are `GObject`s, not widgets; they are in the table marked `backend object` / `model (backend)` because the panels do not work without them.
- `panels/common/cc-timelike-editor-layout.c` is a `GtkLayoutManager` and `panels/color/cc-color-cell-renderer-text.c` a `GtkCellRendererText`; neither is a widget, both are behaviour the port has to reproduce some other way (the Ruby bindings have no comfortable `GtkLayoutManager` subclassing — see Blockers).

## Blockers and open questions

1. **Size.** 212 component units, 2519 widget rows, 92 widget types, 107 CSS classes, 237 signals, 26 panels. This is one to two orders of magnitude larger than the pilot port (gnome-contacts, 30 `lib/*.rb` files). Full parity needs a `PLAN.md` that cuts the work into panel-sized units and an agreed panel order; the inventory alone does not make it tractable.
2. **System integration, not widgets, is the hard part.** Most panels are thin UI over a daemon: NetworkManager (`libnm`), ModemManager, UPower, UDisks2, `gnome-bluetooth`, CUPS (`libcups`), `pulseaudio`/`libgvc`, `accountsservice`, `localed`/`timedated`/`hostnamed`, `fwupd`, `bolt`, `colord`, `libwacom`, `malcontent`, GOA, `gnome-session`, the Mutter `DisplayConfig` D-Bus API, and the XDG portals. Several have no Ruby bindings at all, so those panels are D-Bus-by-hand (`Gio::DBusProxy`) or not portable. Worth deciding per panel before any code is written.
3. **`Adwaita::Application` and `Adwaita::ApplicationWindow` are broken in the Ruby bindings** (ruby-gtk skill, `references/adwaita-quirks.md`) — upstream's `CcApplication : AdwApplication` and `CcWindow : AdwApplicationWindow` have to become `Gtk::Application` + `Gtk::ApplicationWindow`, which the existing placeholder already does.
4. **`Adw.ShortcutsDialog`, `Adw.ShortcutsSection`, `Adw.ShortcutsItem`, `Adw.WrapBox` and `Adw.Breakpoint` setters** are recent libadwaita API. Whether the installed bindings expose them has to be checked in the dev shell before `lib/shortcuts_dialog.rb` and `lib/window.rb` are written; `Adw.Breakpoint` in particular carries the window's adaptive behaviour (`max-width: 550sp` collapses the split view).
5. **Subclassing GTK types from Ruby.** Upstream builds 212 `GObject` subclasses. The house style builds plain Ruby objects with a `build` method returning a widget, which works for composition but not where upstream *is* the type: `CcPanel : Adw.NavigationPage` (every panel is one), `CcListRow : Adw.ActionRow`, `CcTimelikeEditorLayout : Gtk.LayoutManager`, `CcBarChart : Gtk.Widget` with custom `measure`/`size_allocate`/`snapshot`, `CcCropArea`, `CcDrawingArea`, `CcDisplayArrangement`. Decide early whether these compose (`Adwaita::Bin` + delegation) or need real `type_register`.
6. **Custom-drawn widgets.** `cc-bar-chart*` (Wellbeing), `cc-display-arrangement` (Displays), `cc-crop-area` (user avatar), `cc-drawing-area` and `calibrator/cc-clock.c` (Wacom), `cc-level-bar` / `cc-output-test-wheel` (Sound) are Cairo/snapshot drawing, not widget trees — the scan's counts say nothing about their cost.
7. **Privileged operations.** Users, date & time, printers, firmware security and enterprise login all go through polkit and run as root; the port needs a story for that (and for the `cc-*-dialog` authentication flows) before those panels can be exercised.
8. **Panels the app ships but cannot show without hardware.** Wacom, WWAN, Bluetooth, Thunderbolt/bolt, colord devices and fingerprint readers. Their empty states are portable and testable; the live paths are not, in this environment.
9. **No `.ui` on the port side by design**, so the 161 blueprints and 5 `.ui` files are spec only — each one's widget tree, CSS classes and `=> $handler` signal bindings have to be re-expressed as memoized methods, and the parity check is `component-parity` against this inventory, not a file diff.
