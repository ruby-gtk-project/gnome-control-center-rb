# Upstream component inventory — gnome-control-center-rb

Survey only. No application code was written in this step (per task instructions).

Upstream: `origin/main` in this same repo (gnome-control-center, GNOME Settings).
Port: this fork's `ruby` branch.

## State of the port

`lib/` on `ruby` currently holds only the gem skeleton:

```
lib/gnome_control_center.rb
lib/gnome_control_center/application.rb
lib/gnome/control/center/rb/version.rb
```

None of the 24 panels, the shell window, the two D-Bus service providers
(search-provider, global-shortcuts-provider), or any dialog/row/page widget
exists yet. Every row below is "No" under Exists.

## Scope and method

Per the `component-identification` skill: the declarative-UI-first pass,
file-level unit of comparison (one upstream `.c`/`.h` pair, often plus a
`.blp` or `.ui` template, maps to one port file), and the GIR symbol table
were used as the method. Given the size of this app (1309 upstream paths,
24 panels), this is the **opening survey of a fresh fork**: a map of how much
app is left, not a widget-by-widget signal/CSS breakdown. That detail belongs
to the component-parity check done per unit when a panel is actually ported
(see the skill: "pick a unit").

Totals: 24 panels, 278 distinct upstream component files (excluding build
files, desktop launchers, D-Bus interface XML, policy files, and the
po-timezones translation catalogue), 0 ported.

Kind legend: `panel` (top-level Adw view for one settings panel), `page`
(a sub-view pushed inside a panel, usually via Adw.NavigationView), `dialog`,
`row` (a list/action row), `window`, `chooser widget`, `editor widget`,
`entry widget`, `group widget`, `model/item`, `model/device`, `model/config`,
`manager/service`, `client/service`, `widget` (a freestanding visual
control), `widget/helper` (non-widget C/Ruby support code — enums, utils,
D-Bus proxies, parsers — that a ported panel will still need even though it
draws nothing itself).

Proposed `lib/` layout: `lib/panels/<panel>/<name>.rb`, one port file per
upstream component (uniting its `.c`/`.h` and `.blp`/`.ui` into one Ruby
class, per house style). This is a proposal for the next step to confirm,
not yet acted on.

---

## panels/applications/

| Upstream file(s) | Kind | lib/*.rb path | Exists? |
|---|---|---|---|
| `cc-application-shortcut-dialog.blp, cc-application-shortcut-dialog.c, cc-application-shortcut-dialog.h` | dialog | `lib/panels/applications/application_shortcut_dialog.rb` | No |
| `cc-applications-panel.blp, cc-applications-panel.c, cc-applications-panel.h` | panel | `lib/panels/applications/applications_panel.rb` | No |
| `cc-applications-row.blp, cc-applications-row.c, cc-applications-row.h` | row | `lib/panels/applications/applications_row.rb` | No |
| `cc-default-apps-page.blp, cc-default-apps-page.c, cc-default-apps-page.h` | page | `lib/panels/applications/default_apps_page.rb` | No |
| `cc-default-apps-row.c, cc-default-apps-row.h` | row | `lib/panels/applications/default_apps_row.rb` | No |
| `cc-removable-media-settings.c, cc-removable-media-settings.h, cc-removable-media-settings.ui` | widget/helper | `lib/panels/applications/removable_media_settings.rb` | No |
| `cc-snap-row.c, cc-snap-row.h, cc-snap-row.ui` | row | `lib/panels/applications/snap_row.rb` | No |
| `cc-snapd-client.c, cc-snapd-client.h` | client/service | `lib/panels/applications/snapd_client.rb` | No |
| `globs.c, globs.h` | widget/helper | `lib/panels/applications/globs.rb` | No |
| `search.c, search.h` | widget/helper | `lib/panels/applications/search.rb` | No |
| `utils.c, utils.h` | widget/helper | `lib/panels/applications/utils.rb` | No |

## panels/background/

| Upstream file(s) | Kind | lib/*.rb path | Exists? |
|---|---|---|---|
| `bg-recent-source.c, bg-recent-source.h` | widget/helper | `lib/panels/background/bg_recent_source.rb` | No |
| `bg-source.c, bg-source.h` | widget/helper | `lib/panels/background/bg_source.rb` | No |
| `bg-wallpapers-source.c, bg-wallpapers-source.h` | widget/helper | `lib/panels/background/bg_wallpapers_source.rb` | No |
| `cc-background-chooser.blp, cc-background-chooser.c, cc-background-chooser.h` | chooser widget | `lib/panels/background/background_chooser.rb` | No |
| `cc-background-item.c, cc-background-item.h` | model/item | `lib/panels/background/background_item.rb` | No |
| `cc-background-paintable.c, cc-background-paintable.h` | widget/helper | `lib/panels/background/background_paintable.rb` | No |
| `cc-background-panel.blp, cc-background-panel.c, cc-background-panel.h` | panel | `lib/panels/background/background_panel.rb` | No |
| `cc-background-preview.blp, cc-background-preview.c, cc-background-preview.h` | widget/helper | `lib/panels/background/background_preview.rb` | No |
| `cc-background-xml.c, cc-background-xml.h` | widget/helper | `lib/panels/background/background_xml.rb` | No |

## panels/bluetooth/

| Upstream file(s) | Kind | lib/*.rb path | Exists? |
|---|---|---|---|
| `cc-bluetooth-panel.blp, cc-bluetooth-panel.c, cc-bluetooth-panel.h` | panel | `lib/panels/bluetooth/bluetooth_panel.rb` | No |

## panels/color/

| Upstream file(s) | Kind | lib/*.rb path | Exists? |
|---|---|---|---|
| `cc-color-calibrate.blp, cc-color-calibrate.c, cc-color-calibrate.h` | widget/helper | `lib/panels/color/color_calibrate.rb` | No |
| `cc-color-cell-renderer-text.c, cc-color-cell-renderer-text.h` | widget/helper | `lib/panels/color/color_cell_renderer_text.rb` | No |
| `cc-color-common.c, cc-color-common.h` | widget/helper | `lib/panels/color/color_common.rb` | No |
| `cc-color-device.blp, cc-color-device.c, cc-color-device.h` | model/device | `lib/panels/color/color_device.rb` | No |
| `cc-color-panel.c, cc-color-panel.h, cc-color-panel.ui` | panel | `lib/panels/color/color_panel.rb` | No |
| `cc-color-profile.blp, cc-color-profile.c, cc-color-profile.h` | widget/helper | `lib/panels/color/color_profile.rb` | No |

## panels/common/

| Upstream file(s) | Kind | lib/*.rb path | Exists? |
|---|---|---|---|
| `cc-common-language.c, cc-common-language.h` | widget/helper | `lib/panels/common/common_language.rb` | No |
| `cc-content-row.blp, cc-content-row.c, cc-content-row.h` | row | `lib/panels/common/content_row.rb` | No |
| `cc-duration-editor.blp, cc-duration-editor.c, cc-duration-editor.h` | editor widget | `lib/panels/common/duration_editor.rb` | No |
| `cc-duration-row.blp, cc-duration-row.c, cc-duration-row.h` | row | `lib/panels/common/duration_row.rb` | No |
| `cc-hostname-entry.c, cc-hostname-entry.h` | entry widget | `lib/panels/common/hostname_entry.rb` | No |
| `cc-hostname.c, cc-hostname.h` | widget/helper | `lib/panels/common/hostname.rb` | No |
| `cc-illustrated-row.blp, cc-illustrated-row.c, cc-illustrated-row.h` | row | `lib/panels/common/illustrated_row.rb` | No |
| `cc-language-chooser.blp, cc-language-chooser.c, cc-language-chooser.h` | chooser widget | `lib/panels/common/language_chooser.rb` | No |
| `cc-language-row.blp, cc-language-row.c, cc-language-row.h` | row | `lib/panels/common/language_row.rb` | No |
| `cc-list-row-info-button.blp, cc-list-row-info-button.c, cc-list-row-info-button.h` | widget | `lib/panels/common/list_row_info_button.rb` | No |
| `cc-list-row.blp, cc-list-row.c, cc-list-row.h` | row | `lib/panels/common/list_row.rb` | No |
| `cc-mask-paintable.c, cc-mask-paintable.h` | widget/helper | `lib/panels/common/mask_paintable.rb` | No |
| `cc-number-row.c, cc-number-row.h` | row | `lib/panels/common/number_row.rb` | No |
| `cc-permission-infobar.blp, cc-permission-infobar.c, cc-permission-infobar.h` | widget/helper | `lib/panels/common/permission_infobar.rb` | No |
| `cc-scaler.c, cc-scaler.h` | widget/helper | `lib/panels/common/scaler.rb` | No |
| `cc-split-row.blp, cc-split-row.c, cc-split-row.h` | row | `lib/panels/common/split_row.rb` | No |
| `cc-texture-utils.c, cc-texture-utils.h` | widget/helper | `lib/panels/common/texture_utils.rb` | No |
| `cc-time-editor.blp, cc-time-editor.c, cc-time-editor.h` | editor widget | `lib/panels/common/time_editor.rb` | No |
| `cc-timelike-editor-layout.c, cc-timelike-editor-layout.h` | widget/helper | `lib/panels/common/timelike_editor_layout.rb` | No |
| `cc-timelike-editor.blp, cc-timelike-editor.c, cc-timelike-editor.h` | editor widget | `lib/panels/common/timelike_editor.rb` | No |
| `cc-timelike-entry.c, cc-timelike-entry.h` | entry widget | `lib/panels/common/timelike_entry.rb` | No |
| `cc-ui-util.c, cc-ui-util.h` | widget/helper | `lib/panels/common/ui_util.rb` | No |
| `cc-util.c, cc-util.h` | widget/helper | `lib/panels/common/util.rb` | No |
| `gsd-device-manager.c, gsd-device-manager.h` | manager/service | `lib/panels/common/gsd_device_manager.rb` | No |
| `gsd-input-helper.c, gsd-input-helper.h` | widget/helper | `lib/panels/common/gsd_input_helper.rb` | No |
| `hostname-helper.c, hostname-helper.h` | widget/helper | `lib/panels/common/hostname_helper.rb` | No |

## panels/display/

| Upstream file(s) | Kind | lib/*.rb path | Exists? |
|---|---|---|---|
| `cc-display-arrangement.c, cc-display-arrangement.h` | widget/helper | `lib/panels/display/display_arrangement.rb` | No |
| `cc-display-config-manager.c, cc-display-config-manager.h` | manager/service | `lib/panels/display/display_config_manager.rb` | No |
| `cc-display-config.c, cc-display-config.h` | model/config | `lib/panels/display/display_config.rb` | No |
| `cc-display-panel.blp, cc-display-panel.c, cc-display-panel.h` | panel | `lib/panels/display/display_panel.rb` | No |
| `cc-display-settings.blp, cc-display-settings.c, cc-display-settings.h` | widget/helper | `lib/panels/display/display_settings.rb` | No |
| `cc-night-light-page.blp, cc-night-light-page.c, cc-night-light-page.h` | page | `lib/panels/display/night_light_page.rb` | No |

## panels/keyboard/

| Upstream file(s) | Kind | lib/*.rb path | Exists? |
|---|---|---|---|
| `cc-ibus-utils.c, cc-ibus-utils.h` | widget/helper | `lib/panels/keyboard/ibus_utils.rb` | No |
| `cc-input-chooser.blp, cc-input-chooser.c, cc-input-chooser.h` | chooser widget | `lib/panels/keyboard/input_chooser.rb` | No |
| `cc-input-list-box.blp, cc-input-list-box.c, cc-input-list-box.h` | widget/helper | `lib/panels/keyboard/input_list_box.rb` | No |
| `cc-input-row.blp, cc-input-row.c, cc-input-row.h` | row | `lib/panels/keyboard/input_row.rb` | No |
| `cc-input-source-ibus.c, cc-input-source-ibus.h` | widget/helper | `lib/panels/keyboard/input_source_ibus.rb` | No |
| `cc-input-source-xkb.c, cc-input-source-xkb.h` | widget/helper | `lib/panels/keyboard/input_source_xkb.rb` | No |
| `cc-input-source.c, cc-input-source.h` | widget/helper | `lib/panels/keyboard/input_source.rb` | No |
| `cc-keyboard-item.c, cc-keyboard-item.h` | model/item | `lib/panels/keyboard/keyboard_item.rb` | No |
| `cc-keyboard-manager.c, cc-keyboard-manager.h` | manager/service | `lib/panels/keyboard/keyboard_manager.rb` | No |
| `cc-keyboard-panel.blp, cc-keyboard-panel.c, cc-keyboard-panel.h` | panel | `lib/panels/keyboard/keyboard_panel.rb` | No |
| `cc-keyboard-shortcut-editor.blp, cc-keyboard-shortcut-editor.c, cc-keyboard-shortcut-editor.h` | editor widget | `lib/panels/keyboard/keyboard_shortcut_editor.rb` | No |
| `cc-keyboard-shortcut-group.blp, cc-keyboard-shortcut-group.c, cc-keyboard-shortcut-group.h` | group widget | `lib/panels/keyboard/keyboard_shortcut_group.rb` | No |
| `cc-keyboard-shortcut-page.blp, cc-keyboard-shortcut-page.c, cc-keyboard-shortcut-page.h` | page | `lib/panels/keyboard/keyboard_shortcut_page.rb` | No |
| `cc-keyboard-shortcut-row.blp, cc-keyboard-shortcut-row.c, cc-keyboard-shortcut-row.h` | row | `lib/panels/keyboard/keyboard_shortcut_row.rb` | No |
| `cc-xkb-modifier-page.blp, cc-xkb-modifier-page.c, cc-xkb-modifier-page.h` | page | `lib/panels/keyboard/xkb_modifier_page.rb` | No |
| `keyboard-shortcuts.c, keyboard-shortcuts.h` | widget/helper | `lib/panels/keyboard/keyboard_shortcuts.rb` | No |

## panels/mouse/

| Upstream file(s) | Kind | lib/*.rb path | Exists? |
|---|---|---|---|
| `cc-mouse-panel.blp, cc-mouse-panel.c, cc-mouse-panel.h` | panel | `lib/panels/mouse/mouse_panel.rb` | No |
| `cc-mouse-test.blp, cc-mouse-test.c, cc-mouse-test.h` | widget/helper | `lib/panels/mouse/mouse_test.rb` | No |

## panels/multitasking/

| Upstream file(s) | Kind | lib/*.rb path | Exists? |
|---|---|---|---|
| `cc-multitasking-panel.blp, cc-multitasking-panel.c, cc-multitasking-panel.h` | panel | `lib/panels/multitasking/multitasking_panel.rb` | No |

## panels/network/

| Upstream file(s) | Kind | lib/*.rb path | Exists? |
|---|---|---|---|
| `cc-net-proxy-page.blp, cc-net-proxy-page.c, cc-net-proxy-page.h` | page | `lib/panels/network/net_proxy_page.rb` | No |
| `cc-network-panel.blp, cc-network-panel.c, cc-network-panel.h` | panel | `lib/panels/network/network_panel.rb` | No |
| `cc-qr-code-dialog.blp, cc-qr-code-dialog.c, cc-qr-code-dialog.h` | dialog | `lib/panels/network/qr_code_dialog.rb` | No |
| `cc-qr-code.c, cc-qr-code.h` | widget/helper | `lib/panels/network/qr_code.rb` | No |
| `cc-wifi-connection-list.c, cc-wifi-connection-list.h` | widget/helper | `lib/panels/network/wifi_connection_list.rb` | No |
| `cc-wifi-connection-row.blp, cc-wifi-connection-row.c, cc-wifi-connection-row.h` | row | `lib/panels/network/wifi_connection_row.rb` | No |
| `cc-wifi-hotspot-dialog.blp, cc-wifi-hotspot-dialog.c, cc-wifi-hotspot-dialog.h` | dialog | `lib/panels/network/wifi_hotspot_dialog.rb` | No |
| `cc-wifi-panel.blp, cc-wifi-panel.c, cc-wifi-panel.h` | panel | `lib/panels/network/wifi_panel.rb` | No |
| `connection-editor/8021x-security-page.blp` | page | `lib/panels/network/connection_editor_8021x_security_page.rb` | No |
| `connection-editor/bluetooth-page.blp` | page | `lib/panels/network/connection_editor_bluetooth_page.rb` | No |
| `connection-editor/ce-ip-address-entry.c, connection-editor/ce-ip-address-entry.h` | entry widget | `lib/panels/network/connection_editor_ce_ip_address_entry.rb` | No |
| `connection-editor/ce-netmask-entry.c, connection-editor/ce-netmask-entry.h` | entry widget | `lib/panels/network/connection_editor_ce_netmask_entry.rb` | No |
| `connection-editor/ce-page-8021x-security.c, connection-editor/ce-page-8021x-security.h` | widget/helper | `lib/panels/network/connection_editor_ce_page_8021x_security.rb` | No |
| `connection-editor/ce-page-bluetooth.c, connection-editor/ce-page-bluetooth.h` | widget/helper | `lib/panels/network/connection_editor_ce_page_bluetooth.rb` | No |
| `connection-editor/ce-page-details.c, connection-editor/ce-page-details.h` | widget/helper | `lib/panels/network/connection_editor_ce_page_details.rb` | No |
| `connection-editor/ce-page-ethernet.c, connection-editor/ce-page-ethernet.h` | widget/helper | `lib/panels/network/connection_editor_ce_page_ethernet.rb` | No |
| `connection-editor/ce-page-ip4.c, connection-editor/ce-page-ip4.h` | widget/helper | `lib/panels/network/connection_editor_ce_page_ip4.rb` | No |
| `connection-editor/ce-page-ip6.c, connection-editor/ce-page-ip6.h` | widget/helper | `lib/panels/network/connection_editor_ce_page_ip6.rb` | No |
| `connection-editor/ce-page-security.c, connection-editor/ce-page-security.h` | widget/helper | `lib/panels/network/connection_editor_ce_page_security.rb` | No |
| `connection-editor/ce-page-vpn.c, connection-editor/ce-page-vpn.h` | widget/helper | `lib/panels/network/connection_editor_ce_page_vpn.rb` | No |
| `connection-editor/ce-page-wifi.c, connection-editor/ce-page-wifi.h` | widget/helper | `lib/panels/network/connection_editor_ce_page_wifi.rb` | No |
| `connection-editor/ce-page-wireguard.c, connection-editor/ce-page-wireguard.h` | widget/helper | `lib/panels/network/connection_editor_ce_page_wireguard.rb` | No |
| `connection-editor/ce-page.c, connection-editor/ce-page.h` | page | `lib/panels/network/connection_editor_ce_page.rb` | No |
| `connection-editor/connection-editor.blp` | editor widget | `lib/panels/network/connection_editor_connection_editor.rb` | No |
| `connection-editor/details-page.blp` | page | `lib/panels/network/connection_editor_details_page.rb` | No |
| `connection-editor/ethernet-page.blp` | page | `lib/panels/network/connection_editor_ethernet_page.rb` | No |
| `connection-editor/ip4-page.blp` | page | `lib/panels/network/connection_editor_ip4_page.rb` | No |
| `connection-editor/ip6-page.blp` | page | `lib/panels/network/connection_editor_ip6_page.rb` | No |
| `connection-editor/net-connection-editor.c, connection-editor/net-connection-editor.h` | editor widget | `lib/panels/network/connection_editor_net_connection_editor.rb` | No |
| `connection-editor/security-page.blp` | page | `lib/panels/network/connection_editor_security_page.rb` | No |
| `connection-editor/vpn-helpers.c, connection-editor/vpn-helpers.h` | widget/helper | `lib/panels/network/connection_editor_vpn_helpers.rb` | No |
| `connection-editor/vpn-page.blp` | page | `lib/panels/network/connection_editor_vpn_page.rb` | No |
| `connection-editor/wifi-page.blp` | page | `lib/panels/network/connection_editor_wifi_page.rb` | No |
| `connection-editor/wireguard-page.blp` | page | `lib/panels/network/connection_editor_wireguard_page.rb` | No |
| `connection-editor/wireguard-peer.blp` | widget/helper | `lib/panels/network/connection_editor_wireguard_peer.rb` | No |
| `net-device-bluetooth.c, net-device-bluetooth.h` | widget/helper | `lib/panels/network/net_device_bluetooth.rb` | No |
| `net-device-ethernet.c, net-device-ethernet.h` | widget/helper | `lib/panels/network/net_device_ethernet.rb` | No |
| `net-device-mobile.c, net-device-mobile.h` | widget/helper | `lib/panels/network/net_device_mobile.rb` | No |
| `net-device-wifi.c, net-device-wifi.h` | widget/helper | `lib/panels/network/net_device_wifi.rb` | No |
| `net-vpn.c, net-vpn.h` | widget/helper | `lib/panels/network/net_vpn.rb` | No |
| `network-bluetooth.blp` | widget/helper | `lib/panels/network/network_bluetooth.rb` | No |
| `network-dialogs.c, network-dialogs.h` | widget/helper | `lib/panels/network/network_dialogs.rb` | No |
| `network-ethernet.blp` | widget/helper | `lib/panels/network/network_ethernet.rb` | No |
| `network-mobile.ui` | widget/helper | `lib/panels/network/network_mobile.rb` | No |
| `network-vpn.blp` | widget/helper | `lib/panels/network/network_vpn.rb` | No |
| `network-wifi.blp` | widget/helper | `lib/panels/network/network_wifi.rb` | No |
| `panel-common.c, panel-common.h` | widget/helper | `lib/panels/network/panel_common.rb` | No |
| `ui-helpers.c, ui-helpers.h` | widget/helper | `lib/panels/network/ui_helpers.rb` | No |

## panels/notifications/

| Upstream file(s) | Kind | lib/*.rb path | Exists? |
|---|---|---|---|
| `cc-app-notifications-page.blp, cc-app-notifications-page.c, cc-app-notifications-page.h` | page | `lib/panels/notifications/app_notifications_page.rb` | No |
| `cc-notifications-panel.blp, cc-notifications-panel.c, cc-notifications-panel.h` | panel | `lib/panels/notifications/notifications_panel.rb` | No |

## panels/online-accounts/

| Upstream file(s) | Kind | lib/*.rb path | Exists? |
|---|---|---|---|
| `cc-online-account-provider-row.blp, cc-online-account-provider-row.c, cc-online-account-provider-row.h` | row | `lib/panels/online-accounts/online_account_provider_row.rb` | No |
| `cc-online-account-row.blp, cc-online-account-row.c, cc-online-account-row.h` | row | `lib/panels/online-accounts/online_account_row.rb` | No |
| `cc-online-accounts-panel.blp, cc-online-accounts-panel.c, cc-online-accounts-panel.h` | panel | `lib/panels/online-accounts/online_accounts_panel.rb` | No |

## panels/power/

| Upstream file(s) | Kind | lib/*.rb path | Exists? |
|---|---|---|---|
| `cc-battery-row.blp, cc-battery-row.c, cc-battery-row.h` | row | `lib/panels/power/battery_row.rb` | No |
| `cc-power-panel.blp, cc-power-panel.c, cc-power-panel.h` | panel | `lib/panels/power/power_panel.rb` | No |
| `cc-power-profile-info-row.blp, cc-power-profile-info-row.c, cc-power-profile-info-row.h` | row | `lib/panels/power/power_profile_info_row.rb` | No |
| `cc-power-profile-row.blp, cc-power-profile-row.c, cc-power-profile-row.h` | row | `lib/panels/power/power_profile_row.rb` | No |

## panels/printers/

| Upstream file(s) | Kind | lib/*.rb path | Exists? |
|---|---|---|---|
| `cc-printers-panel.blp, cc-printers-panel.c, cc-printers-panel.h` | panel | `lib/panels/printers/printers_panel.rb` | No |
| `pp-cups.c, pp-cups.h` | widget/helper | `lib/panels/printers/pp_cups.rb` | No |
| `pp-details-dialog.blp, pp-details-dialog.c, pp-details-dialog.h` | dialog | `lib/panels/printers/pp_details_dialog.rb` | No |
| `pp-host.c, pp-host.h` | widget/helper | `lib/panels/printers/pp_host.rb` | No |
| `pp-ipp-option-widget.c, pp-ipp-option-widget.h` | widget/helper | `lib/panels/printers/pp_ipp_option_widget.rb` | No |
| `pp-job-row.blp, pp-job-row.c, pp-job-row.h` | row | `lib/panels/printers/pp_job_row.rb` | No |
| `pp-job.c, pp-job.h` | widget/helper | `lib/panels/printers/pp_job.rb` | No |
| `pp-jobs-dialog.blp, pp-jobs-dialog.c, pp-jobs-dialog.h` | dialog | `lib/panels/printers/pp_jobs_dialog.rb` | No |
| `pp-maintenance-command.c, pp-maintenance-command.h` | widget/helper | `lib/panels/printers/pp_maintenance_command.rb` | No |
| `pp-new-printer-dialog.c, pp-new-printer-dialog.h, pp-new-printer-dialog.ui` | dialog | `lib/panels/printers/pp_new_printer_dialog.rb` | No |
| `pp-new-printer.c, pp-new-printer.h` | widget/helper | `lib/panels/printers/pp_new_printer.rb` | No |
| `pp-options-dialog.blp, pp-options-dialog.c, pp-options-dialog.h` | dialog | `lib/panels/printers/pp_options_dialog.rb` | No |
| `pp-ppd-option-widget.c, pp-ppd-option-widget.h` | widget/helper | `lib/panels/printers/pp_ppd_option_widget.rb` | No |
| `pp-ppd-selection-dialog.blp, pp-ppd-selection-dialog.c, pp-ppd-selection-dialog.h` | dialog | `lib/panels/printers/pp_ppd_selection_dialog.rb` | No |
| `pp-print-device.c, pp-print-device.h` | model/device | `lib/panels/printers/pp_print_device.rb` | No |
| `pp-printer-entry.blp, pp-printer-entry.c, pp-printer-entry.h` | entry widget | `lib/panels/printers/pp_printer_entry.rb` | No |
| `pp-printer.c, pp-printer.h` | widget/helper | `lib/panels/printers/pp_printer.rb` | No |
| `pp-samba-stub.c` | widget/helper | `lib/panels/printers/pp_samba_stub.rb` | No |
| `pp-samba.c, pp-samba.h` | widget/helper | `lib/panels/printers/pp_samba.rb` | No |
| `pp-utils.c, pp-utils.h` | widget/helper | `lib/panels/printers/pp_utils.rb` | No |

## panels/privacy/

| Upstream file(s) | Kind | lib/*.rb path | Exists? |
|---|---|---|---|
| `bolt/bolt-client.c, bolt/bolt-client.h` | client/service | `lib/panels/privacy/bolt_bolt_client.rb` | No |
| `bolt/bolt-device.c, bolt/bolt-device.h` | model/device | `lib/panels/privacy/bolt_bolt_device.rb` | No |
| `bolt/bolt-enums.c, bolt/bolt-enums.h` | widget/helper | `lib/panels/privacy/bolt_bolt_enums.rb` | No |
| `bolt/bolt-error.c, bolt/bolt-error.h` | widget/helper | `lib/panels/privacy/bolt_bolt_error.rb` | No |
| `bolt/bolt-names.c, bolt/bolt-names.h` | widget/helper | `lib/panels/privacy/bolt_bolt_names.rb` | No |
| `bolt/bolt-proxy.c, bolt/bolt-proxy.h` | widget/helper | `lib/panels/privacy/bolt_bolt_proxy.rb` | No |
| `bolt/bolt-str.c, bolt/bolt-str.h` | widget/helper | `lib/panels/privacy/bolt_bolt_str.rb` | No |
| `bolt/bolt-time.c, bolt/bolt-time.h` | widget/helper | `lib/panels/privacy/bolt_bolt_time.rb` | No |
| `bolt/cc-bolt-device-dialog.blp, bolt/cc-bolt-device-dialog.c, bolt/cc-bolt-device-dialog.h` | dialog | `lib/panels/privacy/bolt_cc_bolt_device_dialog.rb` | No |
| `bolt/cc-bolt-device-entry.blp, bolt/cc-bolt-device-entry.c, bolt/cc-bolt-device-entry.h` | entry widget | `lib/panels/privacy/bolt_cc_bolt_device_entry.rb` | No |
| `bolt/cc-bolt-page.blp, bolt/cc-bolt-page.c, bolt/cc-bolt-page.h` | page | `lib/panels/privacy/bolt_cc_bolt_page.rb` | No |
| `camera/cc-camera-page.blp, camera/cc-camera-page.c, camera/cc-camera-page.h` | page | `lib/panels/privacy/camera_cc_camera_page.rb` | No |
| `cc-privacy-panel.blp, cc-privacy-panel.c, cc-privacy-panel.h` | panel | `lib/panels/privacy/privacy_panel.rb` | No |
| `diagnostics/cc-diagnostics-page.blp, diagnostics/cc-diagnostics-page.c, diagnostics/cc-diagnostics-page.h` | page | `lib/panels/privacy/diagnostics_cc_diagnostics_page.rb` | No |
| `firmware-security/cc-firmware-security-boot-dialog.blp, firmware-security/cc-firmware-security-boot-dialog.c, firmware-security/cc-firmware-security-boot-dialog.h` | dialog | `lib/panels/privacy/firmware_security_cc_firmware_security_boot_dialog.rb` | No |
| `firmware-security/cc-firmware-security-dialog.blp, firmware-security/cc-firmware-security-dialog.c, firmware-security/cc-firmware-security-dialog.h` | dialog | `lib/panels/privacy/firmware_security_cc_firmware_security_dialog.rb` | No |
| `firmware-security/cc-firmware-security-help-dialog.blp, firmware-security/cc-firmware-security-help-dialog.c, firmware-security/cc-firmware-security-help-dialog.h` | dialog | `lib/panels/privacy/firmware_security_cc_firmware_security_help_dialog.rb` | No |
| `firmware-security/cc-firmware-security-page.blp, firmware-security/cc-firmware-security-page.c, firmware-security/cc-firmware-security-page.h` | page | `lib/panels/privacy/firmware_security_cc_firmware_security_page.rb` | No |
| `firmware-security/cc-firmware-security-utils.c, firmware-security/cc-firmware-security-utils.h` | widget/helper | `lib/panels/privacy/firmware_security_cc_firmware_security_utils.rb` | No |
| `location/cc-location-page.blp, location/cc-location-page.c, location/cc-location-page.h` | page | `lib/panels/privacy/location_cc_location_page.rb` | No |
| `screen/cc-screen-page.blp, screen/cc-screen-page.c, screen/cc-screen-page.h` | page | `lib/panels/privacy/screen_cc_screen_page.rb` | No |
| `usage/cc-usage-page.blp, usage/cc-usage-page.c, usage/cc-usage-page.h` | page | `lib/panels/privacy/usage_cc_usage_page.rb` | No |

## panels/search/

| Upstream file(s) | Kind | lib/*.rb path | Exists? |
|---|---|---|---|
| `cc-search-locations-page.blp, cc-search-locations-page.c, cc-search-locations-page.h` | page | `lib/panels/search/search_locations_page.rb` | No |
| `cc-search-panel-row.blp, cc-search-panel-row.c, cc-search-panel-row.h` | row | `lib/panels/search/search_panel_row.rb` | No |
| `cc-search-panel.blp, cc-search-panel.c, cc-search-panel.h` | panel | `lib/panels/search/search_panel.rb` | No |

## panels/sharing/

| Upstream file(s) | Kind | lib/*.rb path | Exists? |
|---|---|---|---|
| `cc-media-sharing.c, cc-media-sharing.h` | widget/helper | `lib/panels/sharing/media_sharing.rb` | No |
| `cc-sharing-networks.blp, cc-sharing-networks.c, cc-sharing-networks.h` | widget/helper | `lib/panels/sharing/sharing_networks.rb` | No |
| `cc-sharing-panel.blp, cc-sharing-panel.c, cc-sharing-panel.h` | panel | `lib/panels/sharing/sharing_panel.rb` | No |
| `file-share-properties.c, file-share-properties.h` | widget/helper | `lib/panels/sharing/file_share_properties.rb` | No |
| `gsd-sharing-enums.h` | widget/helper | `lib/panels/sharing/gsd_sharing_enums.rb` | No |

## panels/sound/

| Upstream file(s) | Kind | lib/*.rb path | Exists? |
|---|---|---|---|
| `cc-alert-chooser-page.blp, cc-alert-chooser-page.c, cc-alert-chooser-page.h` | page | `lib/panels/sound/alert_chooser_page.rb` | No |
| `cc-balance-slider.blp, cc-balance-slider.c, cc-balance-slider.h` | widget | `lib/panels/sound/balance_slider.rb` | No |
| `cc-device-combo-row.blp, cc-device-combo-row.c, cc-device-combo-row.h` | row | `lib/panels/sound/device_combo_row.rb` | No |
| `cc-fade-slider.blp, cc-fade-slider.c, cc-fade-slider.h` | widget | `lib/panels/sound/fade_slider.rb` | No |
| `cc-level-bar.c, cc-level-bar.h` | widget | `lib/panels/sound/level_bar.rb` | No |
| `cc-profile-combo-row.blp, cc-profile-combo-row.c, cc-profile-combo-row.h` | row | `lib/panels/sound/profile_combo_row.rb` | No |
| `cc-sound-enums.h` | widget/helper | `lib/panels/sound/sound_enums.rb` | No |
| `cc-sound-panel.blp, cc-sound-panel.c, cc-sound-panel.h` | panel | `lib/panels/sound/sound_panel.rb` | No |
| `cc-stream-row.blp, cc-stream-row.c, cc-stream-row.h` | row | `lib/panels/sound/stream_row.rb` | No |
| `cc-subwoofer-slider.blp, cc-subwoofer-slider.c, cc-subwoofer-slider.h` | widget | `lib/panels/sound/subwoofer_slider.rb` | No |
| `cc-volume-levels-page.blp, cc-volume-levels-page.c, cc-volume-levels-page.h` | page | `lib/panels/sound/volume_levels_page.rb` | No |
| `cc-volume-slider.blp, cc-volume-slider.c, cc-volume-slider.h` | widget | `lib/panels/sound/volume_slider.rb` | No |

## panels/system/

| Upstream file(s) | Kind | lib/*.rb path | Exists? |
|---|---|---|---|
| `about/cc-about-page.blp, about/cc-about-page.c, about/cc-about-page.h` | page | `lib/panels/system/about_cc_about_page.rb` | No |
| `about/gnome-control-center-print-renderer.c` | widget/helper | `lib/panels/system/about_gnome_control_center_print_renderer.rb` | No |
| `about/info-cleanup.c, about/info-cleanup.h` | widget/helper | `lib/panels/system/about_info_cleanup.rb` | No |
| `cc-password-utils.c, cc-password-utils.h` | widget/helper | `lib/panels/system/password_utils.rb` | No |
| `cc-system-panel.blp, cc-system-panel.c, cc-system-panel.h` | panel | `lib/panels/system/system_panel.rb` | No |
| `cc-systemd-service.c, cc-systemd-service.h` | widget/helper | `lib/panels/system/systemd_service.rb` | No |
| `datetime/backward` | widget/helper | `lib/panels/system/datetime_backward.rb` | No |
| `datetime/cc-datetime-page.blp, datetime/cc-datetime-page.c, datetime/cc-datetime-page.h` | page | `lib/panels/system/datetime_cc_datetime_page.rb` | No |
| `datetime/cc-month-row.blp` | row | `lib/panels/system/datetime_cc_month_row.rb` | No |
| `datetime/cc-tz-dialog.blp, datetime/cc-tz-dialog.c, datetime/cc-tz-dialog.h` | dialog | `lib/panels/system/datetime_cc_tz_dialog.rb` | No |
| `datetime/cc-tz-item.c, datetime/cc-tz-item.h` | model/item | `lib/panels/system/datetime_cc_tz_item.rb` | No |
| `datetime/cc-tz-row.blp` | row | `lib/panels/system/datetime_cc_tz_row.rb` | No |
| `datetime/date-endian.c, datetime/date-endian.h` | widget/helper | `lib/panels/system/datetime_date_endian.rb` | No |
| `datetime/tz.c, datetime/tz.h` | widget/helper | `lib/panels/system/datetime_tz.rb` | No |
| `region/cc-format-chooser.blp, region/cc-format-chooser.c, region/cc-format-chooser.h` | chooser widget | `lib/panels/system/region_cc_format_chooser.rb` | No |
| `region/cc-format-preview.blp, region/cc-format-preview.c, region/cc-format-preview.h` | widget/helper | `lib/panels/system/region_cc_format_preview.rb` | No |
| `region/cc-region-page.blp, region/cc-region-page.c, region/cc-region-page.h` | page | `lib/panels/system/region_cc_region_page.rb` | No |
| `remote-desktop/cc-desktop-sharing-page.blp, remote-desktop/cc-desktop-sharing-page.c, remote-desktop/cc-desktop-sharing-page.h` | page | `lib/panels/system/remote_desktop_cc_desktop_sharing_page.rb` | No |
| `remote-desktop/cc-encryption-fingerprint-dialog.blp, remote-desktop/cc-encryption-fingerprint-dialog.c, remote-desktop/cc-encryption-fingerprint-dialog.h` | dialog | `lib/panels/system/remote_desktop_cc_encryption_fingerprint_dialog.rb` | No |
| `remote-desktop/cc-gnome-remote-desktop.c, remote-desktop/cc-gnome-remote-desktop.h` | widget/helper | `lib/panels/system/remote_desktop_cc_gnome_remote_desktop.rb` | No |
| `remote-desktop/cc-remote-desktop-page.blp, remote-desktop/cc-remote-desktop-page.c, remote-desktop/cc-remote-desktop-page.h` | page | `lib/panels/system/remote_desktop_cc_remote_desktop_page.rb` | No |
| `remote-desktop/cc-remote-login-page.blp, remote-desktop/cc-remote-login-page.c, remote-desktop/cc-remote-login-page.h` | page | `lib/panels/system/remote_desktop_cc_remote_login_page.rb` | No |
| `remote-desktop/cc-tls-certificate.c, remote-desktop/cc-tls-certificate.h` | widget/helper | `lib/panels/system/remote_desktop_cc_tls_certificate.rb` | No |
| `secure-shell/cc-secure-shell-page.blp, secure-shell/cc-secure-shell-page.c, secure-shell/cc-secure-shell-page.h` | page | `lib/panels/system/secure_shell_cc_secure_shell_page.rb` | No |
| `secure-shell/cc-secure-shell.c, secure-shell/cc-secure-shell.h` | widget/helper | `lib/panels/system/secure_shell_cc_secure_shell.rb` | No |
| `users/cc-add-user-dialog.blp, users/cc-add-user-dialog.c, users/cc-add-user-dialog.h` | dialog | `lib/panels/system/users_cc_add_user_dialog.rb` | No |
| `users/cc-avatar-chooser.blp, users/cc-avatar-chooser.c, users/cc-avatar-chooser.h` | chooser widget | `lib/panels/system/users_cc_avatar_chooser.rb` | No |
| `users/cc-crop-area.c, users/cc-crop-area.h` | widget/helper | `lib/panels/system/users_cc_crop_area.rb` | No |
| `users/cc-enterprise-login-dialog.blp, users/cc-enterprise-login-dialog.c, users/cc-enterprise-login-dialog.h` | dialog | `lib/panels/system/users_cc_enterprise_login_dialog.rb` | No |
| `users/cc-entry-feedback.blp, users/cc-entry-feedback.c, users/cc-entry-feedback.h` | widget/helper | `lib/panels/system/users_cc_entry_feedback.rb` | No |
| `users/cc-fingerprint-dialog.blp, users/cc-fingerprint-dialog.c, users/cc-fingerprint-dialog.h` | dialog | `lib/panels/system/users_cc_fingerprint_dialog.rb` | No |
| `users/cc-fingerprint-manager.c, users/cc-fingerprint-manager.h` | manager/service | `lib/panels/system/users_cc_fingerprint_manager.rb` | No |
| `users/cc-password-dialog.blp, users/cc-password-dialog.c, users/cc-password-dialog.h` | dialog | `lib/panels/system/users_cc_password_dialog.rb` | No |
| `users/cc-realm-manager.c, users/cc-realm-manager.h` | manager/service | `lib/panels/system/users_cc_realm_manager.rb` | No |
| `users/cc-user-page.blp, users/cc-user-page.c, users/cc-user-page.h` | page | `lib/panels/system/users_cc_user_page.rb` | No |
| `users/cc-users-page.blp, users/cc-users-page.c, users/cc-users-page.h` | page | `lib/panels/system/users_cc_users_page.rb` | No |
| `users/fingerprint-strings.h` | widget/helper | `lib/panels/system/users_fingerprint_strings.rb` | No |
| `users/pw-utils.c, users/pw-utils.h` | widget/helper | `lib/panels/system/users_pw_utils.rb` | No |
| `users/run-passwd.c, users/run-passwd.h` | widget/helper | `lib/panels/system/users_run_passwd.rb` | No |
| `users/user-utils.c, users/user-utils.h` | widget/helper | `lib/panels/system/users_user_utils.rb` | No |

## panels/universal-access/

| Upstream file(s) | Kind | lib/*.rb path | Exists? |
|---|---|---|---|
| `cc-cursor-size-page.blp, cc-cursor-size-page.c, cc-cursor-size-page.h` | page | `lib/panels/universal-access/cursor_size_page.rb` | No |
| `cc-ua-hearing-page.blp, cc-ua-hearing-page.c, cc-ua-hearing-page.h` | page | `lib/panels/universal-access/ua_hearing_page.rb` | No |
| `cc-ua-macros.h` | widget/helper | `lib/panels/universal-access/ua_macros.rb` | No |
| `cc-ua-mouse-page.blp, cc-ua-mouse-page.c, cc-ua-mouse-page.h` | page | `lib/panels/universal-access/ua_mouse_page.rb` | No |
| `cc-ua-panel.blp, cc-ua-panel.c, cc-ua-panel.h` | panel | `lib/panels/universal-access/ua_panel.rb` | No |
| `cc-ua-seeing-page.blp, cc-ua-seeing-page.c, cc-ua-seeing-page.h` | page | `lib/panels/universal-access/ua_seeing_page.rb` | No |
| `cc-ua-typing-page.blp, cc-ua-typing-page.c, cc-ua-typing-page.h` | page | `lib/panels/universal-access/ua_typing_page.rb` | No |
| `cc-ua-zoom-page.blp, cc-ua-zoom-page.c, cc-ua-zoom-page.h` | page | `lib/panels/universal-access/ua_zoom_page.rb` | No |

## panels/wacom/

| Upstream file(s) | Kind | lib/*.rb path | Exists? |
|---|---|---|---|
| `button-mapping.blp` | widget/helper | `lib/panels/wacom/button_mapping.rb` | No |
| `calibrator/COPYING` | widget/helper | `lib/panels/wacom/calibrator_COPYING.rb` | No |
| `calibrator/calibrator-gui.c, calibrator/calibrator-gui.h` | widget/helper | `lib/panels/wacom/calibrator_calibrator_gui.rb` | No |
| `calibrator/calibrator.blp, calibrator/calibrator.c, calibrator/calibrator.h` | widget/helper | `lib/panels/wacom/calibrator_calibrator.rb` | No |
| `calibrator/cc-clock.c, calibrator/cc-clock.h` | widget/helper | `lib/panels/wacom/calibrator_cc_clock.rb` | No |
| `cc-drawing-area.c, cc-drawing-area.h` | widget/helper | `lib/panels/wacom/drawing_area.rb` | No |
| `cc-tablet-tool-map.c, cc-tablet-tool-map.h` | widget/helper | `lib/panels/wacom/tablet_tool_map.rb` | No |
| `cc-wacom-button-row.c, cc-wacom-button-row.h` | row | `lib/panels/wacom/wacom_button_row.rb` | No |
| `cc-wacom-device.c, cc-wacom-device.h` | model/device | `lib/panels/wacom/wacom_device.rb` | No |
| `cc-wacom-ekr-page.blp, cc-wacom-ekr-page.c, cc-wacom-ekr-page.h` | page | `lib/panels/wacom/wacom_ekr_page.rb` | No |
| `cc-wacom-page.blp, cc-wacom-page.c, cc-wacom-page.h` | page | `lib/panels/wacom/wacom_page.rb` | No |
| `cc-wacom-panel.blp, cc-wacom-panel.c, cc-wacom-panel.h` | panel | `lib/panels/wacom/wacom_panel.rb` | No |
| `cc-wacom-stylus-action-dialog.blp, cc-wacom-stylus-action-dialog.c, cc-wacom-stylus-action-dialog.h` | dialog | `lib/panels/wacom/wacom_stylus_action_dialog.rb` | No |
| `cc-wacom-stylus-page.blp, cc-wacom-stylus-page.c, cc-wacom-stylus-page.h` | page | `lib/panels/wacom/wacom_stylus_page.rb` | No |
| `cc-wacom-tool.c, cc-wacom-tool.h` | widget/helper | `lib/panels/wacom/wacom_tool.rb` | No |
| `gsd-enums.h` | widget/helper | `lib/panels/wacom/gsd_enums.rb` | No |
| `gsd-wacom-key-shortcut-button.c, gsd-wacom-key-shortcut-button.h` | widget | `lib/panels/wacom/gsd_wacom_key_shortcut_button.rb` | No |

## panels/wellbeing/

| Upstream file(s) | Kind | lib/*.rb path | Exists? |
|---|---|---|---|
| `cc-bar-chart-bar.blp, cc-bar-chart-bar.c, cc-bar-chart-bar.h` | widget | `lib/panels/wellbeing/bar_chart_bar.rb` | No |
| `cc-bar-chart-group.blp, cc-bar-chart-group.c, cc-bar-chart-group.h` | group widget | `lib/panels/wellbeing/bar_chart_group.rb` | No |
| `cc-bar-chart.blp, cc-bar-chart.c, cc-bar-chart.h` | widget/helper | `lib/panels/wellbeing/bar_chart.rb` | No |
| `cc-break-schedule-row.blp, cc-break-schedule-row.c, cc-break-schedule-row.h` | row | `lib/panels/wellbeing/break_schedule_row.rb` | No |
| `cc-screen-time-statistics-row.blp, cc-screen-time-statistics-row.c, cc-screen-time-statistics-row.h` | row | `lib/panels/wellbeing/screen_time_statistics_row.rb` | No |
| `cc-wellbeing-panel.blp, cc-wellbeing-panel.c, cc-wellbeing-panel.h` | panel | `lib/panels/wellbeing/wellbeing_panel.rb` | No |

## panels/wwan/

| Upstream file(s) | Kind | lib/*.rb path | Exists? |
|---|---|---|---|
| `cc-wwan-apn-dialog.blp, cc-wwan-apn-dialog.c, cc-wwan-apn-dialog.h` | dialog | `lib/panels/wwan/wwan_apn_dialog.rb` | No |
| `cc-wwan-data.c, cc-wwan-data.h` | widget/helper | `lib/panels/wwan/wwan_data.rb` | No |
| `cc-wwan-details-dialog.blp, cc-wwan-details-dialog.c, cc-wwan-details-dialog.h` | dialog | `lib/panels/wwan/wwan_details_dialog.rb` | No |
| `cc-wwan-device-page.blp, cc-wwan-device-page.c, cc-wwan-device-page.h` | page | `lib/panels/wwan/wwan_device_page.rb` | No |
| `cc-wwan-device.c, cc-wwan-device.h` | model/device | `lib/panels/wwan/wwan_device.rb` | No |
| `cc-wwan-errors-private.h` | widget/helper | `lib/panels/wwan/wwan_errors_private.rb` | No |
| `cc-wwan-mode-dialog.blp, cc-wwan-mode-dialog.c, cc-wwan-mode-dialog.h` | dialog | `lib/panels/wwan/wwan_mode_dialog.rb` | No |
| `cc-wwan-network-dialog.blp, cc-wwan-network-dialog.c, cc-wwan-network-dialog.h` | dialog | `lib/panels/wwan/wwan_network_dialog.rb` | No |
| `cc-wwan-panel.blp, cc-wwan-panel.c, cc-wwan-panel.h` | panel | `lib/panels/wwan/wwan_panel.rb` | No |
| `cc-wwan-sim-lock-dialog.blp, cc-wwan-sim-lock-dialog.c, cc-wwan-sim-lock-dialog.h` | dialog | `lib/panels/wwan/wwan_sim_lock_dialog.rb` | No |


## shell/

The application shell: window, panel list/sidebar, panel loader, shortcuts
dialog. This is the entry point every panel plugs into and should be ported
before or alongside the first panel.

| Upstream file(s) | Kind | lib/*.rb path | Exists? |
|---|---|---|---|
| `shell/cc-application.c/.h` | manager/service (Adw.Application subclass: actions, accelerators, About) | `lib/shell/application.rb` | No (superseded by the gem's own `lib/gnome_control_center/application.rb` skeleton — needs the real actions/menu/About wiring) |
| `shell/cc-window.blp`, `cc-window.c/.h` | window (main `Adw.ApplicationWindow`: header bar, search, sidebar + content `Adw.NavigationSplitView`) | `lib/shell/window.rb` | No |
| `shell/cc-panel.blp`, `cc-panel.c/.h` | widget/helper (base class every panel subclasses) | `lib/shell/panel.rb` | No |
| `shell/cc-panel-list.blp`, `cc-panel-list.c/.h` | widget (sidebar list of panels, category headers, search filtering) | `lib/shell/panel_list.rb` | No |
| `shell/cc-panel-loader.c/.h` | manager/service (maps panel id → GType, lazy-loads panel modules) | `lib/shell/panel_loader.rb` | No |
| `shell/cc-shell-model.c/.h` | model/config (GListModel of panel entries backing the sidebar) | `lib/shell/shell_model.rb` | No |
| `shell/cc-object-storage.c/.h` | widget/helper (cache of long-lived GObjects, e.g. GDBusProxies) | `lib/shell/object_storage.rb` | No |
| `shell/cc-log.c/.h` | widget/helper (debug logging) | `lib/shell/log.rb` | No |
| `shell/shortcuts-dialog.blp` | dialog (standalone `.blp` with no backing source file — a `Gtk.ShortcutsWindow`) | `lib/shell/shortcuts_dialog.rb` | No |
| `shell/main.c` | widget/helper (process entry point) | `lib/gnome_control_center/application.rb` (merge into existing entry point) | Partial — entry point exists but holds none of this logic |
| `shell/org.gnome.Settings.gschema.xml` | GSettings schema (not a component; last-panel memory, window size, etc.) | — define as a `.gschema.xml` resource the gem installs, not a `.rb` file | No |
| `shell/gnome-control-center.gresource.xml.in` | GResource manifest (not a component; bundles shell/style.css + shell .ui) | — n/a to a Ruby port, which builds widgets in code | No |
| `shell/style.css` | stylesheet (defines/overrides CSS classes referenced by shell and panel widgets) | ship as a resource file, not `.rb` | No |
| `shell/org.gnome.Settings.desktop.in`, `.service.in` | app launcher / D-Bus activation (not a UI component) | packaging concern | No |

## search-provider/ — Shell search provider (D-Bus service)

| Upstream file(s) | Kind | lib/*.rb path | Exists? |
|---|---|---|---|
| `search-provider/cc-search-provider.c/.h` | client/service (implements `org.gnome.ShellSearchProvider2`; answers GNOME Shell's overview search with matching panels) | `lib/search_provider/search_provider.rb` | No |
| `search-provider/control-center-search-provider.c/.h` | widget/helper (binary entry point for the provider service) | `lib/search_provider/main.rb` | No |
| `search-provider/org.gnome.ShellSearchProvider2.xml` | D-Bus interface definition (not a component) | — | No |
| `search-provider/org.gnome.Settings.search-provider.ini`, `.service.in` | D-Bus/search-provider registration (packaging) | — | No |

## global-shortcuts-provider/ — Global shortcuts D-Bus service

| Upstream file(s) | Kind | lib/*.rb path | Exists? |
|---|---|---|---|
| `global-shortcuts-provider/cc-global-shortcut-dialog.blp`, `.c/.h` | dialog (asks the user to confirm/bind a requested global shortcut) | `lib/global_shortcuts_provider/global_shortcut_dialog.rb` | No |
| `global-shortcuts-provider/cc-global-shortcuts-provider.c/.h` | manager/service (implements `org.gnome.GlobalShortcutsProvider`, used by the portal) | `lib/global_shortcuts_provider/global_shortcuts_provider.rb` | No |
| `global-shortcuts-provider/control-center-global-shortcuts-provider.c/.h` | widget/helper (binary entry point) | `lib/global_shortcuts_provider/main.rb` | No |
| `global-shortcuts-provider/org.gnome.GlobalShortcutsProvider.xml` | D-Bus interface definition (not a component) | — | No |

## GSettings schemas

One schema file upstream-wide: `shell/org.gnome.Settings.gschema.xml` (shell
window/last-panel state). Individual panels read other apps'/daemons'
schemas (e.g. `org.gnome.desktop.*`, `org.gnome.SettingsDaemon.*`) rather
than defining their own — none of those is a component to inventory here,
but each ported panel that reads one needs the matching schema installed in
the dev shell for `Gio::Settings` to resolve it.

## GResource manifests

Every panel directory has its own `<panel>.gresource.xml` bundling that
panel's `.blp`-compiled `.ui` + icons; `shell/gnome-control-center.gresource.xml.in`
bundles the shell's. These have no Ruby port equivalent by house style (the
port builds widgets in code, never loads `.ui` at runtime), so they are
listed above only where relevant and otherwise excluded from the per-panel
tables.

## po/ catalogue

116 upstream files: `po/LINGUAS`, `po/POTFILES.in`, `po/POTFILES.skip`, and
~113 `<lang>.po` translation files. `po/POTFILES.in` is the list of upstream
source files with translatable strings — it is the authoritative check, once
porting starts, for which user-facing strings a panel owns. No translation
infrastructure exists in `lib/` yet; out of scope for this survey beyond
noting it needs its own pass (see the `translation-parity` skill) once panels
exist to translate.

## Not covered by this pass

- `tests/`, `subprojects/` (gnome-desktop, ibus submodules vendored for build) — not user-facing components.
- `build-aux/`, `.gitlab-ci/`, `man/`, `docs/` — build/CI/doc, not UI.
- Per-panel `.desktop.in` launchers and `.policy.in` PolicyKit actions — packaging/privilege concerns, not widgets; each should be read when the panel that needs them is ported (several panels, e.g. `system/users`, `system/datetime`, `system/remote-desktop`, `system/secure-shell`, shell out through policy-gated D-Bus calls that the port must still honor, just not as a UI component).
- Panel `.gresource.xml` files and compiled `.ui` (superseded by `.blp` sources already listed).

## Next step

Pick one unit (the skill's own guidance: start with `shell/` since every
panel plugs into it, or with a small, self-contained panel like
`multitasking` or `mouse` to get the house-style pattern established) and
run the full component-identification + component-parity pass on just that
unit before writing any widget code.
