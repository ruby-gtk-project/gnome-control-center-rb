# Upstream component inventory — gnome-control-center-rb

Survey of upstream (`origin/main`, GNOME's gnome-control-center, aka "Settings")
against this fork's `ruby` branch, for the full-parity port. No app code was
written in this pass — this is the inventory only.

## Method

- Upstream file list: `git ls-tree -r --name-only origin/main` (1309 entries).
- Scoped to the files that build user-facing components, per the
  `component-identification` skill: every `panels/**/*.{c,h,blp,ui}` outside
  `tests/`/`icons/`, plus the shell chrome (`shell/`), the global-shortcuts
  provider, GSettings schemas, GResource manifests, and the `po/` catalogue.
  `meson.build`, `.desktop.in`, `appdata`/`metainfo`, man pages and CI files
  are support/build plumbing, not components, and are left out of the table
  rows (noted separately below).
- **The join is per component, not per file**: a component's `.c`, `.h`,
  `.blp`/`.ui` are unioned into one row, matching upstream's own
  subclass+template split (see the skill's "unit the two sides can be joined
  on" section). 282 such components exist under `panels/` alone.
- `kind` is a first-pass label inferred from upstream's own naming convention
  (`*-panel` → panel, `*dialog*` → dialog, `*-row` → row, `*-page` → page,
  `*-view`/`*-editor` → view/editor, `*enum*` → enum, everything else →
  support — helpers, models, backends, utility code with no widget tree of
  its own). It scopes later `component-parity` work; it is not a
  widget/CSS/signal-level identification (that is step 2, run one component
  at a time per the skill, not for the whole app in one pass).
- Proposed `lib/` path follows the pilot port's (`gnome-contacts-rb`)
  convention — one upstream component to one `lib/<path>.rb`, `cc-` stripped,
  dashes to underscores — and the existing `lib/panels/{common,sharing,sound}`
  files already on `ruby` confirm the convention (e.g. `cc-ui-util.c` →
  `lib/panels/common/ui_util.rb`, already present).
- "exists" checks today's `ruby` branch tree for that exact path.

## Gem wiring check (pre-existing, re-verified this pass)

`gudev` and `udisks` are declared in `gnome-control-center-rb.gemspec`,
mirrored in `nix/Gemfile`/`nix/Gemfile.lock`/`nix/gemset.nix`, backed by
`libgudev`/`udisks2` in `flake.nix`'s `gtkStack`, and both required and
called for real (not behind a rescue or a stub) in
`lib/gnome_control_center/system_info.rb` — `GUdev::Client#query_by_sysfs_path`
for DMI vendor/model, `UDisks::ManagerProxy`/`UDisks::DriveProxy` for disk
capacity. Re-verified live:
`nix develop --command ruby -e 'require "gudev"; require "udisks"; puts GUdev.constants.size; puts UDisks.constants.size'`
→ `10` / `138`. No regression found; nothing to fix.

# Component inventory: upstream gnome-control-center -> `ruby` port

Generated from `git ls-tree -r --name-only origin/main`, grouped by component
(each row unions a component's `.c`/`.h`/`.blp`/`.ui` files, per the
`component-identification` skill's file-join rule). `kind` is inferred from
upstream's naming convention (panel/dialog/row/page/view/editor/util/support);
it is a first-pass label for scoping later `component-parity` work, not a
widget-by-widget classification.

Proposed `lib/` path follows the two conventions already visible on `ruby`:
a panel's top-level `Adw`-panel class (upstream `*-panel.c`, or the page/file
that stands in for a panel not yet split out, e.g. `cc-about-page.c`) goes to
`lib/gnome_control_center/panels/<name>_panel.rb`; everything else — rows,
dialogs, views, backends, utilities — goes to `lib/panels/<panel>/<name>.rb`,
matching `lib/panels/common/ui_util.rb`, `lib/panels/sharing/
gsd_sharing_enums.rb` and `lib/panels/sound/sound_enums.rb`, all already
on `ruby`.

## panels/applications (11 components)

| Upstream file(s) | kind | proposed `lib/` path | exists |
|---|---|---|---|
| `panels/applications/cc-application-shortcut-dialog.blp, panels/applications/cc-application-shortcut-dialog.c, panels/applications/cc-application-shortcut-dialog.h` | dialog | `lib/panels/applications/application_shortcut_dialog.rb` | no |
| `panels/applications/cc-applications-panel.blp, panels/applications/cc-applications-panel.c, panels/applications/cc-applications-panel.h` | panel | `lib/gnome_control_center/panels/applications_panel.rb` | no |
| `panels/applications/cc-applications-row.blp, panels/applications/cc-applications-row.c, panels/applications/cc-applications-row.h` | row | `lib/panels/applications/applications_row.rb` | no |
| `panels/applications/cc-default-apps-page.blp, panels/applications/cc-default-apps-page.c, panels/applications/cc-default-apps-page.h` | page | `lib/panels/applications/default_apps_page.rb` | no |
| `panels/applications/cc-default-apps-row.c, panels/applications/cc-default-apps-row.h` | row | `lib/panels/applications/default_apps_row.rb` | no |
| `panels/applications/cc-removable-media-settings.c, panels/applications/cc-removable-media-settings.h, panels/applications/cc-removable-media-settings.ui` | support | `lib/panels/applications/removable_media_settings.rb` | no |
| `panels/applications/cc-snap-row.c, panels/applications/cc-snap-row.h, panels/applications/cc-snap-row.ui` | row | `lib/panels/applications/snap_row.rb` | no |
| `panels/applications/cc-snapd-client.c, panels/applications/cc-snapd-client.h` | support | `lib/panels/applications/snapd_client.rb` | no |
| `panels/applications/globs.c, panels/applications/globs.h` | support | `lib/panels/applications/globs.rb` | no |
| `panels/applications/search.c, panels/applications/search.h` | support | `lib/panels/applications/search.rb` | no |
| `panels/applications/utils.c, panels/applications/utils.h` | support | `lib/panels/applications/utils.rb` | no |

## panels/background (9 components)

| Upstream file(s) | kind | proposed `lib/` path | exists |
|---|---|---|---|
| `panels/background/bg-recent-source.c, panels/background/bg-recent-source.h` | support | `lib/panels/background/bg_recent_source.rb` | no |
| `panels/background/bg-source.c, panels/background/bg-source.h` | support | `lib/panels/background/bg_source.rb` | no |
| `panels/background/bg-wallpapers-source.c, panels/background/bg-wallpapers-source.h` | support | `lib/panels/background/bg_wallpapers_source.rb` | no |
| `panels/background/cc-background-chooser.blp, panels/background/cc-background-chooser.c, panels/background/cc-background-chooser.h` | support | `lib/panels/background/background_chooser.rb` | no |
| `panels/background/cc-background-item.c, panels/background/cc-background-item.h` | support | `lib/panels/background/background_item.rb` | no |
| `panels/background/cc-background-paintable.c, panels/background/cc-background-paintable.h` | support | `lib/panels/background/background_paintable.rb` | no |
| `panels/background/cc-background-panel.blp, panels/background/cc-background-panel.c, panels/background/cc-background-panel.h` | panel | `lib/gnome_control_center/panels/background_panel.rb` | no |
| `panels/background/cc-background-preview.blp, panels/background/cc-background-preview.c, panels/background/cc-background-preview.h` | support | `lib/panels/background/background_preview.rb` | no |
| `panels/background/cc-background-xml.c, panels/background/cc-background-xml.h` | support | `lib/panels/background/background_xml.rb` | no |

## panels/bluetooth (1 components)

| Upstream file(s) | kind | proposed `lib/` path | exists |
|---|---|---|---|
| `panels/bluetooth/cc-bluetooth-panel.blp, panels/bluetooth/cc-bluetooth-panel.c, panels/bluetooth/cc-bluetooth-panel.h` | panel | `lib/gnome_control_center/panels/bluetooth_panel.rb` | no |

## panels/color (6 components)

| Upstream file(s) | kind | proposed `lib/` path | exists |
|---|---|---|---|
| `panels/color/cc-color-calibrate.blp, panels/color/cc-color-calibrate.c, panels/color/cc-color-calibrate.h` | support | `lib/panels/color/color_calibrate.rb` | no |
| `panels/color/cc-color-cell-renderer-text.c, panels/color/cc-color-cell-renderer-text.h` | support | `lib/panels/color/color_cell_renderer_text.rb` | no |
| `panels/color/cc-color-common.c, panels/color/cc-color-common.h` | support | `lib/panels/color/color_common.rb` | no |
| `panels/color/cc-color-device.blp, panels/color/cc-color-device.c, panels/color/cc-color-device.h` | support | `lib/panels/color/color_device.rb` | no |
| `panels/color/cc-color-panel.c, panels/color/cc-color-panel.h, panels/color/cc-color-panel.ui` | panel | `lib/gnome_control_center/panels/color_panel.rb` | no |
| `panels/color/cc-color-profile.blp, panels/color/cc-color-profile.c, panels/color/cc-color-profile.h` | support | `lib/panels/color/color_profile.rb` | no |

## panels/common (26 components)

| Upstream file(s) | kind | proposed `lib/` path | exists |
|---|---|---|---|
| `panels/common/cc-common-language.c, panels/common/cc-common-language.h` | support | `lib/panels/common/common_language.rb` | no |
| `panels/common/cc-content-row.blp, panels/common/cc-content-row.c, panels/common/cc-content-row.h` | row | `lib/panels/common/content_row.rb` | no |
| `panels/common/cc-duration-editor.blp, panels/common/cc-duration-editor.c, panels/common/cc-duration-editor.h` | editor | `lib/panels/common/duration_editor.rb` | no |
| `panels/common/cc-duration-row.blp, panels/common/cc-duration-row.c, panels/common/cc-duration-row.h` | row | `lib/panels/common/duration_row.rb` | no |
| `panels/common/cc-hostname.c, panels/common/cc-hostname.h` | support | `lib/panels/common/hostname.rb` | no |
| `panels/common/cc-hostname-entry.c, panels/common/cc-hostname-entry.h` | support | `lib/panels/common/hostname_entry.rb` | no |
| `panels/common/cc-illustrated-row.blp, panels/common/cc-illustrated-row.c, panels/common/cc-illustrated-row.h` | row | `lib/panels/common/illustrated_row.rb` | no |
| `panels/common/cc-language-chooser.blp, panels/common/cc-language-chooser.c, panels/common/cc-language-chooser.h` | support | `lib/panels/common/language_chooser.rb` | no |
| `panels/common/cc-language-row.blp, panels/common/cc-language-row.c, panels/common/cc-language-row.h` | row | `lib/panels/common/language_row.rb` | no |
| `panels/common/cc-list-row.blp, panels/common/cc-list-row.c, panels/common/cc-list-row.h` | row | `lib/panels/common/list_row.rb` | no |
| `panels/common/cc-list-row-info-button.blp, panels/common/cc-list-row-info-button.c, panels/common/cc-list-row-info-button.h` | widget | `lib/panels/common/list_row_info_button.rb` | no |
| `panels/common/cc-mask-paintable.c, panels/common/cc-mask-paintable.h` | support | `lib/panels/common/mask_paintable.rb` | no |
| `panels/common/cc-number-row.c, panels/common/cc-number-row.h` | row | `lib/panels/common/number_row.rb` | no |
| `panels/common/cc-permission-infobar.blp, panels/common/cc-permission-infobar.c, panels/common/cc-permission-infobar.h` | support | `lib/panels/common/permission_infobar.rb` | no |
| `panels/common/cc-scaler.c, panels/common/cc-scaler.h` | support | `lib/panels/common/scaler.rb` | no |
| `panels/common/cc-split-row.blp, panels/common/cc-split-row.c, panels/common/cc-split-row.h` | row | `lib/panels/common/split_row.rb` | no |
| `panels/common/cc-texture-utils.c, panels/common/cc-texture-utils.h` | util | `lib/panels/common/texture_utils.rb` | no |
| `panels/common/cc-time-editor.blp, panels/common/cc-time-editor.c, panels/common/cc-time-editor.h` | editor | `lib/panels/common/time_editor.rb` | no |
| `panels/common/cc-timelike-editor.blp, panels/common/cc-timelike-editor.c, panels/common/cc-timelike-editor.h` | editor | `lib/panels/common/timelike_editor.rb` | no |
| `panels/common/cc-timelike-editor-layout.c, panels/common/cc-timelike-editor-layout.h` | support | `lib/panels/common/timelike_editor_layout.rb` | no |
| `panels/common/cc-timelike-entry.c, panels/common/cc-timelike-entry.h` | support | `lib/panels/common/timelike_entry.rb` | no |
| `panels/common/cc-ui-util.c, panels/common/cc-ui-util.h` | util | `lib/panels/common/ui_util.rb` | yes |
| `panels/common/cc-util.c, panels/common/cc-util.h` | util | `lib/panels/common/util.rb` | yes |
| `panels/common/gsd-device-manager.c, panels/common/gsd-device-manager.h` | support | `lib/panels/common/gsd_device_manager.rb` | no |
| `panels/common/gsd-input-helper.c, panels/common/gsd-input-helper.h` | util | `lib/panels/common/gsd_input_helper.rb` | no |
| `panels/common/hostname-helper.c, panels/common/hostname-helper.h` | util | `lib/panels/common/hostname_helper.rb` | no |

## panels/display (6 components)

| Upstream file(s) | kind | proposed `lib/` path | exists |
|---|---|---|---|
| `panels/display/cc-display-arrangement.c, panels/display/cc-display-arrangement.h` | support | `lib/panels/display/display_arrangement.rb` | no |
| `panels/display/cc-display-config.c, panels/display/cc-display-config.h` | support | `lib/panels/display/display_config.rb` | no |
| `panels/display/cc-display-config-manager.c, panels/display/cc-display-config-manager.h` | support | `lib/panels/display/display_config_manager.rb` | no |
| `panels/display/cc-display-panel.blp, panels/display/cc-display-panel.c, panels/display/cc-display-panel.h` | panel | `lib/gnome_control_center/panels/display_panel.rb` | no |
| `panels/display/cc-display-settings.blp, panels/display/cc-display-settings.c, panels/display/cc-display-settings.h` | support | `lib/panels/display/display_settings.rb` | no |
| `panels/display/cc-night-light-page.blp, panels/display/cc-night-light-page.c, panels/display/cc-night-light-page.h` | page | `lib/panels/display/night_light_page.rb` | no |

## panels/keyboard (16 components)

| Upstream file(s) | kind | proposed `lib/` path | exists |
|---|---|---|---|
| `panels/keyboard/cc-ibus-utils.c, panels/keyboard/cc-ibus-utils.h` | util | `lib/panels/keyboard/ibus_utils.rb` | no |
| `panels/keyboard/cc-input-chooser.blp, panels/keyboard/cc-input-chooser.c, panels/keyboard/cc-input-chooser.h` | support | `lib/panels/keyboard/input_chooser.rb` | no |
| `panels/keyboard/cc-input-list-box.blp, panels/keyboard/cc-input-list-box.c, panels/keyboard/cc-input-list-box.h` | list | `lib/panels/keyboard/input_list_box.rb` | no |
| `panels/keyboard/cc-input-row.blp, panels/keyboard/cc-input-row.c, panels/keyboard/cc-input-row.h` | row | `lib/panels/keyboard/input_row.rb` | no |
| `panels/keyboard/cc-input-source.c, panels/keyboard/cc-input-source.h` | support | `lib/panels/keyboard/input_source.rb` | no |
| `panels/keyboard/cc-input-source-ibus.c, panels/keyboard/cc-input-source-ibus.h` | support | `lib/panels/keyboard/input_source_ibus.rb` | no |
| `panels/keyboard/cc-input-source-xkb.c, panels/keyboard/cc-input-source-xkb.h` | support | `lib/panels/keyboard/input_source_xkb.rb` | no |
| `panels/keyboard/cc-keyboard-item.c, panels/keyboard/cc-keyboard-item.h` | support | `lib/panels/keyboard/keyboard_item.rb` | no |
| `panels/keyboard/cc-keyboard-manager.c, panels/keyboard/cc-keyboard-manager.h` | support | `lib/panels/keyboard/keyboard_manager.rb` | no |
| `panels/keyboard/cc-keyboard-panel.blp, panels/keyboard/cc-keyboard-panel.c, panels/keyboard/cc-keyboard-panel.h` | panel | `lib/gnome_control_center/panels/keyboard_panel.rb` | no |
| `panels/keyboard/cc-keyboard-shortcut-editor.blp, panels/keyboard/cc-keyboard-shortcut-editor.c, panels/keyboard/cc-keyboard-shortcut-editor.h` | editor | `lib/panels/keyboard/keyboard_shortcut_editor.rb` | no |
| `panels/keyboard/cc-keyboard-shortcut-group.blp, panels/keyboard/cc-keyboard-shortcut-group.c, panels/keyboard/cc-keyboard-shortcut-group.h` | support | `lib/panels/keyboard/keyboard_shortcut_group.rb` | no |
| `panels/keyboard/cc-keyboard-shortcut-page.blp, panels/keyboard/cc-keyboard-shortcut-page.c, panels/keyboard/cc-keyboard-shortcut-page.h` | page | `lib/panels/keyboard/keyboard_shortcut_page.rb` | no |
| `panels/keyboard/cc-keyboard-shortcut-row.blp, panels/keyboard/cc-keyboard-shortcut-row.c, panels/keyboard/cc-keyboard-shortcut-row.h` | row | `lib/panels/keyboard/keyboard_shortcut_row.rb` | no |
| `panels/keyboard/cc-xkb-modifier-page.blp, panels/keyboard/cc-xkb-modifier-page.c, panels/keyboard/cc-xkb-modifier-page.h` | page | `lib/panels/keyboard/xkb_modifier_page.rb` | no |
| `panels/keyboard/keyboard-shortcuts.c, panels/keyboard/keyboard-shortcuts.h` | support | `lib/panels/keyboard/keyboard_shortcuts.rb` | no |

## panels/mouse (3 components)

| Upstream file(s) | kind | proposed `lib/` path | exists |
|---|---|---|---|
| `panels/mouse/cc-mouse-panel.blp, panels/mouse/cc-mouse-panel.c, panels/mouse/cc-mouse-panel.h` | panel | `lib/gnome_control_center/panels/mouse_panel.rb` | no |
| `panels/mouse/cc-mouse-test.blp, panels/mouse/cc-mouse-test.c, panels/mouse/cc-mouse-test.h` | support | `lib/panels/mouse/mouse_test.rb` | no |
| `panels/mouse/test-gnome-mouse-test.c` | support | `lib/panels/mouse/test_gnome_mouse_test.rb` | no |

## panels/multitasking (1 components)

| Upstream file(s) | kind | proposed `lib/` path | exists |
|---|---|---|---|
| `panels/multitasking/cc-multitasking-panel.blp, panels/multitasking/cc-multitasking-panel.c, panels/multitasking/cc-multitasking-panel.h` | panel | `lib/gnome_control_center/panels/multitasking_panel.rb` | no |

## panels/network (48 components)

| Upstream file(s) | kind | proposed `lib/` path | exists |
|---|---|---|---|
| `panels/network/cc-net-proxy-page.blp, panels/network/cc-net-proxy-page.c, panels/network/cc-net-proxy-page.h` | page | `lib/panels/network/net_proxy_page.rb` | no |
| `panels/network/cc-network-panel.blp, panels/network/cc-network-panel.c, panels/network/cc-network-panel.h` | panel | `lib/gnome_control_center/panels/network_panel.rb` | no |
| `panels/network/cc-qr-code.c, panels/network/cc-qr-code.h` | support | `lib/panels/network/qr_code.rb` | no |
| `panels/network/cc-qr-code-dialog.blp, panels/network/cc-qr-code-dialog.c, panels/network/cc-qr-code-dialog.h` | dialog | `lib/panels/network/qr_code_dialog.rb` | no |
| `panels/network/cc-wifi-connection-list.c, panels/network/cc-wifi-connection-list.h` | list | `lib/panels/network/wifi_connection_list.rb` | no |
| `panels/network/cc-wifi-connection-row.blp, panels/network/cc-wifi-connection-row.c, panels/network/cc-wifi-connection-row.h` | row | `lib/panels/network/wifi_connection_row.rb` | no |
| `panels/network/cc-wifi-hotspot-dialog.blp, panels/network/cc-wifi-hotspot-dialog.c, panels/network/cc-wifi-hotspot-dialog.h` | dialog | `lib/panels/network/wifi_hotspot_dialog.rb` | no |
| `panels/network/cc-wifi-panel.blp, panels/network/cc-wifi-panel.c, panels/network/cc-wifi-panel.h` | panel | `lib/gnome_control_center/panels/wifi_panel.rb` | no |
| `panels/network/connection-editor/8021x-security-page.blp` | page | `lib/panels/network/connection_editor/8021x_security_page.rb` | no |
| `panels/network/connection-editor/bluetooth-page.blp` | page | `lib/panels/network/connection_editor/bluetooth_page.rb` | no |
| `panels/network/connection-editor/ce-ip-address-entry.c, panels/network/connection-editor/ce-ip-address-entry.h` | support | `lib/panels/network/connection_editor/ce_ip_address_entry.rb` | no |
| `panels/network/connection-editor/ce-netmask-entry.c, panels/network/connection-editor/ce-netmask-entry.h` | support | `lib/panels/network/connection_editor/ce_netmask_entry.rb` | no |
| `panels/network/connection-editor/ce-page.c, panels/network/connection-editor/ce-page.h` | page | `lib/panels/network/connection_editor/ce_page.rb` | no |
| `panels/network/connection-editor/ce-page-8021x-security.c, panels/network/connection-editor/ce-page-8021x-security.h` | support | `lib/panels/network/connection_editor/ce_page_8021x_security.rb` | no |
| `panels/network/connection-editor/ce-page-bluetooth.c, panels/network/connection-editor/ce-page-bluetooth.h` | support | `lib/panels/network/connection_editor/ce_page_bluetooth.rb` | no |
| `panels/network/connection-editor/ce-page-details.c, panels/network/connection-editor/ce-page-details.h` | support | `lib/panels/network/connection_editor/ce_page_details.rb` | no |
| `panels/network/connection-editor/ce-page-ethernet.c, panels/network/connection-editor/ce-page-ethernet.h` | support | `lib/panels/network/connection_editor/ce_page_ethernet.rb` | no |
| `panels/network/connection-editor/ce-page-ip4.c, panels/network/connection-editor/ce-page-ip4.h` | support | `lib/panels/network/connection_editor/ce_page_ip4.rb` | no |
| `panels/network/connection-editor/ce-page-ip6.c, panels/network/connection-editor/ce-page-ip6.h` | support | `lib/panels/network/connection_editor/ce_page_ip6.rb` | no |
| `panels/network/connection-editor/ce-page-security.c, panels/network/connection-editor/ce-page-security.h` | support | `lib/panels/network/connection_editor/ce_page_security.rb` | no |
| `panels/network/connection-editor/ce-page-vpn.c, panels/network/connection-editor/ce-page-vpn.h` | support | `lib/panels/network/connection_editor/ce_page_vpn.rb` | no |
| `panels/network/connection-editor/ce-page-wifi.c, panels/network/connection-editor/ce-page-wifi.h` | support | `lib/panels/network/connection_editor/ce_page_wifi.rb` | no |
| `panels/network/connection-editor/ce-page-wireguard.c, panels/network/connection-editor/ce-page-wireguard.h` | support | `lib/panels/network/connection_editor/ce_page_wireguard.rb` | no |
| `panels/network/connection-editor/connection-editor.blp` | editor | `lib/panels/network/connection_editor/connection_editor.rb` | no |
| `panels/network/connection-editor/details-page.blp` | page | `lib/panels/network/connection_editor/details_page.rb` | no |
| `panels/network/connection-editor/ethernet-page.blp` | page | `lib/panels/network/connection_editor/ethernet_page.rb` | no |
| `panels/network/connection-editor/ip4-page.blp` | page | `lib/panels/network/connection_editor/ip4_page.rb` | no |
| `panels/network/connection-editor/ip6-page.blp` | page | `lib/panels/network/connection_editor/ip6_page.rb` | no |
| `panels/network/connection-editor/net-connection-editor.c, panels/network/connection-editor/net-connection-editor.h` | editor | `lib/panels/network/connection_editor/net_connection_editor.rb` | no |
| `panels/network/connection-editor/security-page.blp` | page | `lib/panels/network/connection_editor/security_page.rb` | no |
| `panels/network/connection-editor/vpn-helpers.c, panels/network/connection-editor/vpn-helpers.h` | support | `lib/panels/network/connection_editor/vpn_helpers.rb` | no |
| `panels/network/connection-editor/vpn-page.blp` | page | `lib/panels/network/connection_editor/vpn_page.rb` | no |
| `panels/network/connection-editor/wifi-page.blp` | page | `lib/panels/network/connection_editor/wifi_page.rb` | no |
| `panels/network/connection-editor/wireguard-page.blp` | page | `lib/panels/network/connection_editor/wireguard_page.rb` | no |
| `panels/network/connection-editor/wireguard-peer.blp` | support | `lib/panels/network/connection_editor/wireguard_peer.rb` | no |
| `panels/network/net-device-bluetooth.c, panels/network/net-device-bluetooth.h` | support | `lib/panels/network/net_device_bluetooth.rb` | no |
| `panels/network/net-device-ethernet.c, panels/network/net-device-ethernet.h` | support | `lib/panels/network/net_device_ethernet.rb` | no |
| `panels/network/net-device-mobile.c, panels/network/net-device-mobile.h` | support | `lib/panels/network/net_device_mobile.rb` | no |
| `panels/network/net-device-wifi.c, panels/network/net-device-wifi.h` | support | `lib/panels/network/net_device_wifi.rb` | no |
| `panels/network/net-vpn.c, panels/network/net-vpn.h` | support | `lib/panels/network/net_vpn.rb` | no |
| `panels/network/network-bluetooth.blp` | support | `lib/panels/network/network_bluetooth.rb` | no |
| `panels/network/network-dialogs.c, panels/network/network-dialogs.h` | dialog | `lib/panels/network/network_dialogs.rb` | no |
| `panels/network/network-ethernet.blp` | support | `lib/panels/network/network_ethernet.rb` | no |
| `panels/network/network-mobile.ui` | support | `lib/panels/network/network_mobile.rb` | no |
| `panels/network/network-vpn.blp` | support | `lib/panels/network/network_vpn.rb` | no |
| `panels/network/network-wifi.blp` | support | `lib/panels/network/network_wifi.rb` | no |
| `panels/network/panel-common.c, panels/network/panel-common.h` | support | `lib/panels/network/panel_common.rb` | no |
| `panels/network/ui-helpers.c, panels/network/ui-helpers.h` | support | `lib/panels/network/ui_helpers.rb` | no |

## panels/notifications (2 components)

| Upstream file(s) | kind | proposed `lib/` path | exists |
|---|---|---|---|
| `panels/notifications/cc-app-notifications-page.blp, panels/notifications/cc-app-notifications-page.c, panels/notifications/cc-app-notifications-page.h` | page | `lib/panels/notifications/app_notifications_page.rb` | no |
| `panels/notifications/cc-notifications-panel.blp, panels/notifications/cc-notifications-panel.c, panels/notifications/cc-notifications-panel.h` | panel | `lib/gnome_control_center/panels/notifications_panel.rb` | no |

## panels/online-accounts (3 components)

| Upstream file(s) | kind | proposed `lib/` path | exists |
|---|---|---|---|
| `panels/online-accounts/cc-online-account-provider-row.blp, panels/online-accounts/cc-online-account-provider-row.c, panels/online-accounts/cc-online-account-provider-row.h` | row | `lib/panels/online-accounts/online_account_provider_row.rb` | no |
| `panels/online-accounts/cc-online-account-row.blp, panels/online-accounts/cc-online-account-row.c, panels/online-accounts/cc-online-account-row.h` | row | `lib/panels/online-accounts/online_account_row.rb` | no |
| `panels/online-accounts/cc-online-accounts-panel.blp, panels/online-accounts/cc-online-accounts-panel.c, panels/online-accounts/cc-online-accounts-panel.h` | panel | `lib/gnome_control_center/panels/online_accounts_panel.rb` | no |

## panels/power (4 components)

| Upstream file(s) | kind | proposed `lib/` path | exists |
|---|---|---|---|
| `panels/power/cc-battery-row.blp, panels/power/cc-battery-row.c, panels/power/cc-battery-row.h` | row | `lib/panels/power/battery_row.rb` | no |
| `panels/power/cc-power-panel.blp, panels/power/cc-power-panel.c, panels/power/cc-power-panel.h` | panel | `lib/gnome_control_center/panels/power_panel.rb` | no |
| `panels/power/cc-power-profile-info-row.blp, panels/power/cc-power-profile-info-row.c, panels/power/cc-power-profile-info-row.h` | row | `lib/panels/power/power_profile_info_row.rb` | no |
| `panels/power/cc-power-profile-row.blp, panels/power/cc-power-profile-row.c, panels/power/cc-power-profile-row.h` | row | `lib/panels/power/power_profile_row.rb` | no |

## panels/printers (20 components)

| Upstream file(s) | kind | proposed `lib/` path | exists |
|---|---|---|---|
| `panels/printers/cc-printers-panel.blp, panels/printers/cc-printers-panel.c, panels/printers/cc-printers-panel.h` | panel | `lib/gnome_control_center/panels/printers_panel.rb` | no |
| `panels/printers/pp-cups.c, panels/printers/pp-cups.h` | support | `lib/panels/printers/pp_cups.rb` | no |
| `panels/printers/pp-details-dialog.blp, panels/printers/pp-details-dialog.c, panels/printers/pp-details-dialog.h` | dialog | `lib/panels/printers/pp_details_dialog.rb` | no |
| `panels/printers/pp-host.c, panels/printers/pp-host.h` | support | `lib/panels/printers/pp_host.rb` | no |
| `panels/printers/pp-ipp-option-widget.c, panels/printers/pp-ipp-option-widget.h` | widget | `lib/panels/printers/pp_ipp_option_widget.rb` | no |
| `panels/printers/pp-job.c, panels/printers/pp-job.h` | support | `lib/panels/printers/pp_job.rb` | no |
| `panels/printers/pp-job-row.blp, panels/printers/pp-job-row.c, panels/printers/pp-job-row.h` | row | `lib/panels/printers/pp_job_row.rb` | no |
| `panels/printers/pp-jobs-dialog.blp, panels/printers/pp-jobs-dialog.c, panels/printers/pp-jobs-dialog.h` | dialog | `lib/panels/printers/pp_jobs_dialog.rb` | no |
| `panels/printers/pp-maintenance-command.c, panels/printers/pp-maintenance-command.h` | support | `lib/panels/printers/pp_maintenance_command.rb` | no |
| `panels/printers/pp-new-printer.c, panels/printers/pp-new-printer.h` | support | `lib/panels/printers/pp_new_printer.rb` | no |
| `panels/printers/pp-new-printer-dialog.c, panels/printers/pp-new-printer-dialog.h, panels/printers/pp-new-printer-dialog.ui` | dialog | `lib/panels/printers/pp_new_printer_dialog.rb` | no |
| `panels/printers/pp-options-dialog.blp, panels/printers/pp-options-dialog.c, panels/printers/pp-options-dialog.h` | dialog | `lib/panels/printers/pp_options_dialog.rb` | no |
| `panels/printers/pp-ppd-option-widget.c, panels/printers/pp-ppd-option-widget.h` | widget | `lib/panels/printers/pp_ppd_option_widget.rb` | no |
| `panels/printers/pp-ppd-selection-dialog.blp, panels/printers/pp-ppd-selection-dialog.c, panels/printers/pp-ppd-selection-dialog.h` | dialog | `lib/panels/printers/pp_ppd_selection_dialog.rb` | no |
| `panels/printers/pp-print-device.c, panels/printers/pp-print-device.h` | support | `lib/panels/printers/pp_print_device.rb` | no |
| `panels/printers/pp-printer.c, panels/printers/pp-printer.h` | support | `lib/panels/printers/pp_printer.rb` | no |
| `panels/printers/pp-printer-entry.blp, panels/printers/pp-printer-entry.c, panels/printers/pp-printer-entry.h` | support | `lib/panels/printers/pp_printer_entry.rb` | no |
| `panels/printers/pp-samba.c, panels/printers/pp-samba.h` | support | `lib/panels/printers/pp_samba.rb` | no |
| `panels/printers/pp-samba-stub.c` | support | `lib/panels/printers/pp_samba_stub.rb` | no |
| `panels/printers/pp-utils.c, panels/printers/pp-utils.h` | util | `lib/panels/printers/pp_utils.rb` | no |

## panels/privacy (22 components)

| Upstream file(s) | kind | proposed `lib/` path | exists |
|---|---|---|---|
| `panels/privacy/bolt/bolt-client.c, panels/privacy/bolt/bolt-client.h` | support | `lib/panels/privacy/bolt/bolt_client.rb` | no |
| `panels/privacy/bolt/bolt-device.c, panels/privacy/bolt/bolt-device.h` | support | `lib/panels/privacy/bolt/bolt_device.rb` | no |
| `panels/privacy/bolt/bolt-enums.c, panels/privacy/bolt/bolt-enums.h` | enum | `lib/panels/privacy/bolt/bolt_enums.rb` | no |
| `panels/privacy/bolt/bolt-error.c, panels/privacy/bolt/bolt-error.h` | support | `lib/panels/privacy/bolt/bolt_error.rb` | no |
| `panels/privacy/bolt/bolt-names.c, panels/privacy/bolt/bolt-names.h` | support | `lib/panels/privacy/bolt/bolt_names.rb` | no |
| `panels/privacy/bolt/bolt-proxy.c, panels/privacy/bolt/bolt-proxy.h` | support | `lib/panels/privacy/bolt/bolt_proxy.rb` | no |
| `panels/privacy/bolt/bolt-str.c, panels/privacy/bolt/bolt-str.h` | support | `lib/panels/privacy/bolt/bolt_str.rb` | no |
| `panels/privacy/bolt/bolt-time.c, panels/privacy/bolt/bolt-time.h` | support | `lib/panels/privacy/bolt/bolt_time.rb` | no |
| `panels/privacy/bolt/cc-bolt-device-dialog.blp, panels/privacy/bolt/cc-bolt-device-dialog.c, panels/privacy/bolt/cc-bolt-device-dialog.h` | dialog | `lib/panels/privacy/bolt/bolt_device_dialog.rb` | no |
| `panels/privacy/bolt/cc-bolt-device-entry.blp, panels/privacy/bolt/cc-bolt-device-entry.c, panels/privacy/bolt/cc-bolt-device-entry.h` | support | `lib/panels/privacy/bolt/bolt_device_entry.rb` | no |
| `panels/privacy/bolt/cc-bolt-page.blp, panels/privacy/bolt/cc-bolt-page.c, panels/privacy/bolt/cc-bolt-page.h` | page | `lib/panels/privacy/bolt/bolt_page.rb` | no |
| `panels/privacy/camera/cc-camera-page.blp, panels/privacy/camera/cc-camera-page.c, panels/privacy/camera/cc-camera-page.h` | page | `lib/panels/privacy/camera/camera_page.rb` | no |
| `panels/privacy/cc-privacy-panel.blp, panels/privacy/cc-privacy-panel.c, panels/privacy/cc-privacy-panel.h` | panel | `lib/gnome_control_center/panels/privacy_panel.rb` | no |
| `panels/privacy/diagnostics/cc-diagnostics-page.blp, panels/privacy/diagnostics/cc-diagnostics-page.c, panels/privacy/diagnostics/cc-diagnostics-page.h` | page | `lib/panels/privacy/diagnostics/diagnostics_page.rb` | no |
| `panels/privacy/firmware-security/cc-firmware-security-boot-dialog.blp, panels/privacy/firmware-security/cc-firmware-security-boot-dialog.c, panels/privacy/firmware-security/cc-firmware-security-boot-dialog.h` | dialog | `lib/panels/privacy/firmware_security/firmware_security_boot_dialog.rb` | no |
| `panels/privacy/firmware-security/cc-firmware-security-dialog.blp, panels/privacy/firmware-security/cc-firmware-security-dialog.c, panels/privacy/firmware-security/cc-firmware-security-dialog.h` | dialog | `lib/panels/privacy/firmware_security/firmware_security_dialog.rb` | no |
| `panels/privacy/firmware-security/cc-firmware-security-help-dialog.blp, panels/privacy/firmware-security/cc-firmware-security-help-dialog.c, panels/privacy/firmware-security/cc-firmware-security-help-dialog.h` | dialog | `lib/panels/privacy/firmware_security/firmware_security_help_dialog.rb` | no |
| `panels/privacy/firmware-security/cc-firmware-security-page.blp, panels/privacy/firmware-security/cc-firmware-security-page.c, panels/privacy/firmware-security/cc-firmware-security-page.h` | page | `lib/panels/privacy/firmware_security/firmware_security_page.rb` | no |
| `panels/privacy/firmware-security/cc-firmware-security-utils.c, panels/privacy/firmware-security/cc-firmware-security-utils.h` | util | `lib/panels/privacy/firmware_security/firmware_security_utils.rb` | no |
| `panels/privacy/location/cc-location-page.blp, panels/privacy/location/cc-location-page.c, panels/privacy/location/cc-location-page.h` | page | `lib/panels/privacy/location/location_page.rb` | no |
| `panels/privacy/screen/cc-screen-page.blp, panels/privacy/screen/cc-screen-page.c, panels/privacy/screen/cc-screen-page.h` | page | `lib/panels/privacy/screen/screen_page.rb` | no |
| `panels/privacy/usage/cc-usage-page.blp, panels/privacy/usage/cc-usage-page.c, panels/privacy/usage/cc-usage-page.h` | page | `lib/panels/privacy/usage/usage_page.rb` | no |

## panels/search (3 components)

| Upstream file(s) | kind | proposed `lib/` path | exists |
|---|---|---|---|
| `panels/search/cc-search-locations-page.blp, panels/search/cc-search-locations-page.c, panels/search/cc-search-locations-page.h` | page | `lib/panels/search/search_locations_page.rb` | no |
| `panels/search/cc-search-panel.blp, panels/search/cc-search-panel.c, panels/search/cc-search-panel.h` | panel | `lib/gnome_control_center/panels/search_panel.rb` | no |
| `panels/search/cc-search-panel-row.blp, panels/search/cc-search-panel-row.c, panels/search/cc-search-panel-row.h` | row | `lib/panels/search/search_panel_row.rb` | no |

## panels/sharing (5 components)

| Upstream file(s) | kind | proposed `lib/` path | exists |
|---|---|---|---|
| `panels/sharing/cc-media-sharing.c, panels/sharing/cc-media-sharing.h` | support | `lib/panels/sharing/media_sharing.rb` | no |
| `panels/sharing/cc-sharing-networks.blp, panels/sharing/cc-sharing-networks.c, panels/sharing/cc-sharing-networks.h` | support | `lib/panels/sharing/sharing_networks.rb` | no |
| `panels/sharing/cc-sharing-panel.blp, panels/sharing/cc-sharing-panel.c, panels/sharing/cc-sharing-panel.h` | panel | `lib/gnome_control_center/panels/sharing_panel.rb` | no |
| `panels/sharing/file-share-properties.c, panels/sharing/file-share-properties.h` | support | `lib/panels/sharing/file_share_properties.rb` | no |
| `panels/sharing/gsd-sharing-enums.h` | enum | `lib/panels/sharing/gsd_sharing_enums.rb` | yes |

## panels/sound (15 components)

| Upstream file(s) | kind | proposed `lib/` path | exists |
|---|---|---|---|
| `panels/sound/cc-alert-chooser-page.blp, panels/sound/cc-alert-chooser-page.c, panels/sound/cc-alert-chooser-page.h` | page | `lib/panels/sound/alert_chooser_page.rb` | no |
| `panels/sound/cc-balance-slider.blp, panels/sound/cc-balance-slider.c, panels/sound/cc-balance-slider.h` | support | `lib/panels/sound/balance_slider.rb` | no |
| `panels/sound/cc-device-combo-row.blp, panels/sound/cc-device-combo-row.c, panels/sound/cc-device-combo-row.h` | row | `lib/panels/sound/device_combo_row.rb` | no |
| `panels/sound/cc-fade-slider.blp, panels/sound/cc-fade-slider.c, panels/sound/cc-fade-slider.h` | support | `lib/panels/sound/fade_slider.rb` | no |
| `panels/sound/cc-level-bar.c, panels/sound/cc-level-bar.h` | support | `lib/panels/sound/level_bar.rb` | no |
| `panels/sound/cc-output-test-wheel.c, panels/sound/cc-output-test-wheel.h` | support | `lib/panels/sound/output_test_wheel.rb` | no |
| `panels/sound/cc-output-test-window.blp, panels/sound/cc-output-test-window.c, panels/sound/cc-output-test-window.h` | window | `lib/panels/sound/output_test_window.rb` | no |
| `panels/sound/cc-profile-combo-row.blp, panels/sound/cc-profile-combo-row.c, panels/sound/cc-profile-combo-row.h` | row | `lib/panels/sound/profile_combo_row.rb` | no |
| `panels/sound/cc-sound-enums.h` | enum | `lib/panels/sound/sound_enums.rb` | yes |
| `panels/sound/cc-sound-panel.blp, panels/sound/cc-sound-panel.c, panels/sound/cc-sound-panel.h` | panel | `lib/gnome_control_center/panels/sound_panel.rb` | no |
| `panels/sound/cc-speaker-test-button.c, panels/sound/cc-speaker-test-button.h` | widget | `lib/panels/sound/speaker_test_button.rb` | no |
| `panels/sound/cc-stream-row.blp, panels/sound/cc-stream-row.c, panels/sound/cc-stream-row.h` | row | `lib/panels/sound/stream_row.rb` | no |
| `panels/sound/cc-subwoofer-slider.blp, panels/sound/cc-subwoofer-slider.c, panels/sound/cc-subwoofer-slider.h` | support | `lib/panels/sound/subwoofer_slider.rb` | no |
| `panels/sound/cc-volume-levels-page.blp, panels/sound/cc-volume-levels-page.c, panels/sound/cc-volume-levels-page.h` | page | `lib/panels/sound/volume_levels_page.rb` | no |
| `panels/sound/cc-volume-slider.blp, panels/sound/cc-volume-slider.c, panels/sound/cc-volume-slider.h` | support | `lib/panels/sound/volume_slider.rb` | no |

## panels/system (40 components)

| Upstream file(s) | kind | proposed `lib/` path | exists |
|---|---|---|---|
| `panels/system/about/cc-about-page.blp, panels/system/about/cc-about-page.c, panels/system/about/cc-about-page.h` | page | `lib/gnome_control_center/panels/about_panel.rb` | yes |
| `panels/system/about/gnome-control-center-print-renderer.c` | support | `lib/panels/system/about/gnome_control_center_print_renderer.rb` | no |
| `panels/system/about/info-cleanup.c, panels/system/about/info-cleanup.h` | support | `lib/panels/system/about/info_cleanup.rb` | no |
| `panels/system/about/test-info-cleanup.c` | support | `lib/panels/system/about/test_info_cleanup.rb` | no |
| `panels/system/cc-password-utils.c, panels/system/cc-password-utils.h` | util | `lib/panels/system/password_utils.rb` | no |
| `panels/system/cc-system-panel.blp, panels/system/cc-system-panel.c, panels/system/cc-system-panel.h` | panel | `lib/gnome_control_center/panels/system_panel.rb` | no |
| `panels/system/cc-systemd-service.c, panels/system/cc-systemd-service.h` | support | `lib/panels/system/systemd_service.rb` | no |
| `panels/system/datetime/cc-datetime-page.blp, panels/system/datetime/cc-datetime-page.c, panels/system/datetime/cc-datetime-page.h` | page | `lib/panels/system/datetime/datetime_page.rb` | no |
| `panels/system/datetime/cc-month-row.blp` | row | `lib/panels/system/datetime/month_row.rb` | no |
| `panels/system/datetime/cc-tz-dialog.blp, panels/system/datetime/cc-tz-dialog.c, panels/system/datetime/cc-tz-dialog.h` | dialog | `lib/panels/system/datetime/tz_dialog.rb` | no |
| `panels/system/datetime/cc-tz-item.c, panels/system/datetime/cc-tz-item.h` | support | `lib/panels/system/datetime/tz_item.rb` | no |
| `panels/system/datetime/cc-tz-row.blp` | row | `lib/panels/system/datetime/tz_row.rb` | no |
| `panels/system/datetime/date-endian.c, panels/system/datetime/date-endian.h` | support | `lib/panels/system/datetime/date_endian.rb` | no |
| `panels/system/datetime/tz.c, panels/system/datetime/tz.h` | support | `lib/panels/system/datetime/tz.rb` | no |
| `panels/system/region/cc-format-chooser.blp, panels/system/region/cc-format-chooser.c, panels/system/region/cc-format-chooser.h` | support | `lib/panels/system/region/format_chooser.rb` | no |
| `panels/system/region/cc-format-preview.blp, panels/system/region/cc-format-preview.c, panels/system/region/cc-format-preview.h` | support | `lib/panels/system/region/format_preview.rb` | no |
| `panels/system/region/cc-region-page.blp, panels/system/region/cc-region-page.c, panels/system/region/cc-region-page.h` | page | `lib/panels/system/region/region_page.rb` | no |
| `panels/system/remote-desktop/cc-desktop-sharing-page.blp, panels/system/remote-desktop/cc-desktop-sharing-page.c, panels/system/remote-desktop/cc-desktop-sharing-page.h` | page | `lib/panels/system/remote_desktop/desktop_sharing_page.rb` | no |
| `panels/system/remote-desktop/cc-encryption-fingerprint-dialog.blp, panels/system/remote-desktop/cc-encryption-fingerprint-dialog.c, panels/system/remote-desktop/cc-encryption-fingerprint-dialog.h` | dialog | `lib/panels/system/remote_desktop/encryption_fingerprint_dialog.rb` | no |
| `panels/system/remote-desktop/cc-gnome-remote-desktop.c, panels/system/remote-desktop/cc-gnome-remote-desktop.h` | support | `lib/panels/system/remote_desktop/gnome_remote_desktop.rb` | no |
| `panels/system/remote-desktop/cc-remote-desktop-page.blp, panels/system/remote-desktop/cc-remote-desktop-page.c, panels/system/remote-desktop/cc-remote-desktop-page.h` | page | `lib/panels/system/remote_desktop/remote_desktop_page.rb` | no |
| `panels/system/remote-desktop/cc-remote-login-page.blp, panels/system/remote-desktop/cc-remote-login-page.c, panels/system/remote-desktop/cc-remote-login-page.h` | page | `lib/panels/system/remote_desktop/remote_login_page.rb` | no |
| `panels/system/remote-desktop/cc-tls-certificate.c, panels/system/remote-desktop/cc-tls-certificate.h` | support | `lib/panels/system/remote_desktop/tls_certificate.rb` | no |
| `panels/system/secure-shell/cc-secure-shell.c, panels/system/secure-shell/cc-secure-shell.h` | support | `lib/panels/system/secure_shell/secure_shell.rb` | no |
| `panels/system/secure-shell/cc-secure-shell-page.blp, panels/system/secure-shell/cc-secure-shell-page.c, panels/system/secure-shell/cc-secure-shell-page.h` | page | `lib/panels/system/secure_shell/secure_shell_page.rb` | no |
| `panels/system/users/cc-add-user-dialog.blp, panels/system/users/cc-add-user-dialog.c, panels/system/users/cc-add-user-dialog.h` | dialog | `lib/panels/system/users/add_user_dialog.rb` | no |
| `panels/system/users/cc-avatar-chooser.blp, panels/system/users/cc-avatar-chooser.c, panels/system/users/cc-avatar-chooser.h` | support | `lib/panels/system/users/avatar_chooser.rb` | no |
| `panels/system/users/cc-crop-area.c, panels/system/users/cc-crop-area.h` | support | `lib/panels/system/users/crop_area.rb` | no |
| `panels/system/users/cc-enterprise-login-dialog.blp, panels/system/users/cc-enterprise-login-dialog.c, panels/system/users/cc-enterprise-login-dialog.h` | dialog | `lib/panels/system/users/enterprise_login_dialog.rb` | no |
| `panels/system/users/cc-entry-feedback.blp, panels/system/users/cc-entry-feedback.c, panels/system/users/cc-entry-feedback.h` | support | `lib/panels/system/users/entry_feedback.rb` | no |
| `panels/system/users/cc-fingerprint-dialog.blp, panels/system/users/cc-fingerprint-dialog.c, panels/system/users/cc-fingerprint-dialog.h` | dialog | `lib/panels/system/users/fingerprint_dialog.rb` | no |
| `panels/system/users/cc-fingerprint-manager.c, panels/system/users/cc-fingerprint-manager.h` | support | `lib/panels/system/users/fingerprint_manager.rb` | no |
| `panels/system/users/cc-password-dialog.blp, panels/system/users/cc-password-dialog.c, panels/system/users/cc-password-dialog.h` | dialog | `lib/panels/system/users/password_dialog.rb` | no |
| `panels/system/users/cc-realm-manager.c, panels/system/users/cc-realm-manager.h` | support | `lib/panels/system/users/realm_manager.rb` | no |
| `panels/system/users/cc-user-page.blp, panels/system/users/cc-user-page.c, panels/system/users/cc-user-page.h` | page | `lib/panels/system/users/user_page.rb` | no |
| `panels/system/users/cc-users-page.blp, panels/system/users/cc-users-page.c, panels/system/users/cc-users-page.h` | page | `lib/panels/system/users/users_page.rb` | no |
| `panels/system/users/fingerprint-strings.h` | support | `lib/panels/system/users/fingerprint_strings.rb` | no |
| `panels/system/users/pw-utils.c, panels/system/users/pw-utils.h` | util | `lib/panels/system/users/pw_utils.rb` | no |
| `panels/system/users/run-passwd.c, panels/system/users/run-passwd.h` | support | `lib/panels/system/users/run_passwd.rb` | no |
| `panels/system/users/user-utils.c, panels/system/users/user-utils.h` | util | `lib/panels/system/users/user_utils.rb` | no |

## panels/universal-access (8 components)

| Upstream file(s) | kind | proposed `lib/` path | exists |
|---|---|---|---|
| `panels/universal-access/cc-cursor-size-page.blp, panels/universal-access/cc-cursor-size-page.c, panels/universal-access/cc-cursor-size-page.h` | page | `lib/panels/universal-access/cursor_size_page.rb` | no |
| `panels/universal-access/cc-ua-hearing-page.blp, panels/universal-access/cc-ua-hearing-page.c, panels/universal-access/cc-ua-hearing-page.h` | page | `lib/panels/universal-access/ua_hearing_page.rb` | no |
| `panels/universal-access/cc-ua-macros.h` | support | `lib/panels/universal-access/ua_macros.rb` | no |
| `panels/universal-access/cc-ua-mouse-page.blp, panels/universal-access/cc-ua-mouse-page.c, panels/universal-access/cc-ua-mouse-page.h` | page | `lib/panels/universal-access/ua_mouse_page.rb` | no |
| `panels/universal-access/cc-ua-panel.blp, panels/universal-access/cc-ua-panel.c, panels/universal-access/cc-ua-panel.h` | panel | `lib/gnome_control_center/panels/ua_panel.rb` | no |
| `panels/universal-access/cc-ua-seeing-page.blp, panels/universal-access/cc-ua-seeing-page.c, panels/universal-access/cc-ua-seeing-page.h` | page | `lib/panels/universal-access/ua_seeing_page.rb` | no |
| `panels/universal-access/cc-ua-typing-page.blp, panels/universal-access/cc-ua-typing-page.c, panels/universal-access/cc-ua-typing-page.h` | page | `lib/panels/universal-access/ua_typing_page.rb` | no |
| `panels/universal-access/cc-ua-zoom-page.blp, panels/universal-access/cc-ua-zoom-page.c, panels/universal-access/cc-ua-zoom-page.h` | page | `lib/panels/universal-access/ua_zoom_page.rb` | no |

## panels/wacom (17 components)

| Upstream file(s) | kind | proposed `lib/` path | exists |
|---|---|---|---|
| `panels/wacom/button-mapping.blp` | support | `lib/panels/wacom/button_mapping.rb` | no |
| `panels/wacom/calibrator/calibrator.blp, panels/wacom/calibrator/calibrator.c, panels/wacom/calibrator/calibrator.h` | support | `lib/panels/wacom/calibrator/calibrator.rb` | no |
| `panels/wacom/calibrator/calibrator-gui.c, panels/wacom/calibrator/calibrator-gui.h` | support | `lib/panels/wacom/calibrator/calibrator_gui.rb` | no |
| `panels/wacom/calibrator/cc-clock.c, panels/wacom/calibrator/cc-clock.h` | support | `lib/panels/wacom/calibrator/clock.rb` | no |
| `panels/wacom/cc-drawing-area.c, panels/wacom/cc-drawing-area.h` | support | `lib/panels/wacom/drawing_area.rb` | no |
| `panels/wacom/cc-tablet-tool-map.c, panels/wacom/cc-tablet-tool-map.h` | support | `lib/panels/wacom/tablet_tool_map.rb` | no |
| `panels/wacom/cc-wacom-button-row.c, panels/wacom/cc-wacom-button-row.h` | row | `lib/panels/wacom/wacom_button_row.rb` | no |
| `panels/wacom/cc-wacom-device.c, panels/wacom/cc-wacom-device.h` | support | `lib/panels/wacom/wacom_device.rb` | no |
| `panels/wacom/cc-wacom-ekr-page.blp, panels/wacom/cc-wacom-ekr-page.c, panels/wacom/cc-wacom-ekr-page.h` | page | `lib/panels/wacom/wacom_ekr_page.rb` | no |
| `panels/wacom/cc-wacom-page.blp, panels/wacom/cc-wacom-page.c, panels/wacom/cc-wacom-page.h` | page | `lib/panels/wacom/wacom_page.rb` | no |
| `panels/wacom/cc-wacom-panel.blp, panels/wacom/cc-wacom-panel.c, panels/wacom/cc-wacom-panel.h` | panel | `lib/gnome_control_center/panels/wacom_panel.rb` | no |
| `panels/wacom/cc-wacom-stylus-action-dialog.blp, panels/wacom/cc-wacom-stylus-action-dialog.c, panels/wacom/cc-wacom-stylus-action-dialog.h` | dialog | `lib/panels/wacom/wacom_stylus_action_dialog.rb` | no |
| `panels/wacom/cc-wacom-stylus-page.blp, panels/wacom/cc-wacom-stylus-page.c, panels/wacom/cc-wacom-stylus-page.h` | page | `lib/panels/wacom/wacom_stylus_page.rb` | no |
| `panels/wacom/cc-wacom-tool.c, panels/wacom/cc-wacom-tool.h` | support | `lib/panels/wacom/wacom_tool.rb` | no |
| `panels/wacom/gsd-enums.h` | enum | `lib/panels/wacom/gsd_enums.rb` | no |
| `panels/wacom/gsd-wacom-key-shortcut-button.c, panels/wacom/gsd-wacom-key-shortcut-button.h` | widget | `lib/panels/wacom/gsd_wacom_key_shortcut_button.rb` | no |
| `panels/wacom/test-wacom.c` | support | `lib/panels/wacom/test_wacom.rb` | no |

## panels/wellbeing (6 components)

| Upstream file(s) | kind | proposed `lib/` path | exists |
|---|---|---|---|
| `panels/wellbeing/cc-bar-chart.blp, panels/wellbeing/cc-bar-chart.c, panels/wellbeing/cc-bar-chart.h` | support | `lib/panels/wellbeing/bar_chart.rb` | no |
| `panels/wellbeing/cc-bar-chart-bar.blp, panels/wellbeing/cc-bar-chart-bar.c, panels/wellbeing/cc-bar-chart-bar.h` | support | `lib/panels/wellbeing/bar_chart_bar.rb` | no |
| `panels/wellbeing/cc-bar-chart-group.blp, panels/wellbeing/cc-bar-chart-group.c, panels/wellbeing/cc-bar-chart-group.h` | support | `lib/panels/wellbeing/bar_chart_group.rb` | no |
| `panels/wellbeing/cc-break-schedule-row.blp, panels/wellbeing/cc-break-schedule-row.c, panels/wellbeing/cc-break-schedule-row.h` | row | `lib/panels/wellbeing/break_schedule_row.rb` | no |
| `panels/wellbeing/cc-screen-time-statistics-row.blp, panels/wellbeing/cc-screen-time-statistics-row.c, panels/wellbeing/cc-screen-time-statistics-row.h` | row | `lib/panels/wellbeing/screen_time_statistics_row.rb` | no |
| `panels/wellbeing/cc-wellbeing-panel.blp, panels/wellbeing/cc-wellbeing-panel.c, panels/wellbeing/cc-wellbeing-panel.h` | panel | `lib/gnome_control_center/panels/wellbeing_panel.rb` | no |

## panels/wwan (10 components)

| Upstream file(s) | kind | proposed `lib/` path | exists |
|---|---|---|---|
| `panels/wwan/cc-wwan-apn-dialog.blp, panels/wwan/cc-wwan-apn-dialog.c, panels/wwan/cc-wwan-apn-dialog.h` | dialog | `lib/panels/wwan/wwan_apn_dialog.rb` | no |
| `panels/wwan/cc-wwan-data.c, panels/wwan/cc-wwan-data.h` | support | `lib/panels/wwan/wwan_data.rb` | no |
| `panels/wwan/cc-wwan-details-dialog.blp, panels/wwan/cc-wwan-details-dialog.c, panels/wwan/cc-wwan-details-dialog.h` | dialog | `lib/panels/wwan/wwan_details_dialog.rb` | no |
| `panels/wwan/cc-wwan-device.c, panels/wwan/cc-wwan-device.h` | support | `lib/panels/wwan/wwan_device.rb` | no |
| `panels/wwan/cc-wwan-device-page.blp, panels/wwan/cc-wwan-device-page.c, panels/wwan/cc-wwan-device-page.h` | page | `lib/panels/wwan/wwan_device_page.rb` | no |
| `panels/wwan/cc-wwan-errors-private.h` | support | `lib/panels/wwan/wwan_errors_private.rb` | no |
| `panels/wwan/cc-wwan-mode-dialog.blp, panels/wwan/cc-wwan-mode-dialog.c, panels/wwan/cc-wwan-mode-dialog.h` | dialog | `lib/panels/wwan/wwan_mode_dialog.rb` | no |
| `panels/wwan/cc-wwan-network-dialog.blp, panels/wwan/cc-wwan-network-dialog.c, panels/wwan/cc-wwan-network-dialog.h` | dialog | `lib/panels/wwan/wwan_network_dialog.rb` | no |
| `panels/wwan/cc-wwan-panel.blp, panels/wwan/cc-wwan-panel.c, panels/wwan/cc-wwan-panel.h` | panel | `lib/gnome_control_center/panels/wwan_panel.rb` | no |
| `panels/wwan/cc-wwan-sim-lock-dialog.blp, panels/wwan/cc-wwan-sim-lock-dialog.c, panels/wwan/cc-wwan-sim-lock-dialog.h` | dialog | `lib/panels/wwan/wwan_sim_lock_dialog.rb` | no |

**panels/ totals: 282 components, 5 already in `lib/`.**

## shell/ — application chrome (9 components)

| Upstream file(s) | kind | proposed `lib/` path | exists |
|---|---|---|---|
| `shell/cc-application.c, shell/cc-application.h` | support | `lib/gnome_control_center/application.rb` | yes |
| `shell/cc-log.c, shell/cc-log.h` | support | `lib/gnome_control_center/log.rb` | yes (partial — see component-parity) |
| `shell/cc-object-storage.c, shell/cc-object-storage.h` | support | `lib/gnome_control_center/object_storage.rb` | yes (boot-wired, no real caller yet — see component-parity) |
| `shell/cc-panel-list.blp, shell/cc-panel-list.c, shell/cc-panel-list.h` | support | `lib/gnome_control_center/panel_list.rb` | yes |
| `shell/cc-panel-loader.c, shell/cc-panel-loader.h` | support | `lib/gnome_control_center/panel_loader.rb` | yes |
| `shell/cc-panel.blp, shell/cc-panel.c, shell/cc-panel.h` | support | `lib/gnome_control_center/panel.rb` | yes |
| `shell/cc-shell-model.c, shell/cc-shell-model.h` | support | `lib/gnome_control_center/shell_model.rb` | yes |
| `shell/cc-window.blp, shell/cc-window.c, shell/cc-window.h` | window | `lib/gnome_control_center/window.rb` | yes |
| `shell/shortcuts-dialog.blp` | dialog | `lib/gnome_control_center/shortcuts_dialog.rb` | no |
| `shell/main.c` | support | `exe/gnome-control-center` | yes (entry point, not a `lib/` component) |

`lib/gnome_control_center/system_info.rb` has no single upstream counterpart
— it is this port's substitute for the overview rows upstream reads from
`gnome-desktop`/`libgtop`/GPU enumeration inside `panels/system/about/
cc-about-page.c` and `panels/system/cc-system-page.c`, documented as such in
its own header comment (see `lib/gnome_control_center/panels/about_panel.rb`
and `system_info.rb`'s class comment for exactly what is substituted).

## global-shortcuts-provider/ — standalone D-Bus service (2 components)

| Upstream file(s) | kind | proposed `lib/` path | exists |
|---|---|---|---|
| `global-shortcuts-provider/cc-global-shortcut-dialog.blp, global-shortcuts-provider/cc-global-shortcut-dialog.c, global-shortcuts-provider/cc-global-shortcut-dialog.h` | dialog | `lib/global_shortcuts_provider/global_shortcut_dialog.rb` | no |
| `global-shortcuts-provider/cc-global-shortcuts-provider.c, global-shortcuts-provider/cc-global-shortcuts-provider.h, global-shortcuts-provider/control-center-global-shortcuts-provider.c, global-shortcuts-provider/control-center-global-shortcuts-provider.h` | support | `lib/global_shortcuts_provider/provider.rb` | no |

This is upstream's separate `org.gnome.Settings.GlobalShortcutsProvider`
D-Bus service binary, built from its own `.xml` interface
(`global-shortcuts-provider/org.gnome.Settings.GlobalShortcutsProvider.service.in`).
It is out of process from the main shell; whether it is in scope for this
port (vs. the keyboard panel's shortcut *editor*, which is a different,
in-process component under `panels/keyboard/`) is a scoping call for
whoever picks up the keyboard-shortcuts component.

## search-provider/ — Shell search provider, standalone D-Bus service (2 components)

| Upstream file(s) | kind | proposed `lib/` path | exists |
|---|---|---|---|
| `search-provider/cc-search-provider.c, search-provider/cc-search-provider.h` | support | `lib/search_provider/search_provider.rb` | no |
| `search-provider/control-center-search-provider.c, search-provider/control-center-search-provider.h` | support | `lib/search_provider/main.rb` | no |

Implements `org.gnome.ShellSearchProvider2` (interface in
`search-provider/org.gnome.ShellSearchProvider2.xml`), registered via
`search-provider/org.gnome.Settings.search-provider.ini` and
`org.gnome.Settings.SearchProvider.service.in`. Out-of-process from the main
shell binary, same as `global-shortcuts-provider/` above; not yet ported.

## GSettings schemas (1)

| Upstream file | covers | exists in `ruby`? |
|---|---|---|
| `shell/org.gnome.Settings.gschema.xml` | shell-level prefs: last-visited panel, window geometry | no schema file under `ruby` yet |

Per-panel schemas live in `gsettings-desktop-schemas` (external, not in this
repo) except where a panel ships its own, e.g.
`panels/keyboard/50-accessibility.xml.in` and the `00/01-*.xml.in` keybinding
schemas, and `panels/system/users/data/*.xml` (Fprint/realmd D-Bus
interfaces, not GSettings). None of those are GSettings schemas either —
upstream's only true `.gschema.xml` is the shell one above.

## GResource manifests (24, one per panel + shell + global-shortcuts-provider)

Every panel directory (and `shell/`, and `global-shortcuts-provider/`) has
its own `<name>.gresource.xml[.in]` bundling that component's `.ui`
files/icons into the compiled binary. The Ruby port has no `.ui` files by
house style (widgets are built declaratively in code — see the `ruby-gtk`
skill) and therefore needs no GResource step; each manifest's *content* is
already covered by the panel rows above (every `.ui`/`.blp` it lists is its
own row), so these 24 files are build plumbing with no `lib/` counterpart,
not a missing component.

## po/ catalogue

`po/LINGUAS` (116 locale `.po` files), `po/POTFILES.in`, `po/POTFILES.skip`.
Upstream is internationalized via gettext; this fork has no `po/` directory
and no i18n story yet (`gettext`/`FastGettext` wiring, a `POTFILES`-equivalent
list of translatable strings, and locale files) — tracked here as a gap for
whichever pass does `translation-parity`, not attempted in this survey.

## Totals

- **panels/**: 282 components across 23 panel directories (`applications`,
  `background`, `bluetooth`, `color`, `common`, `display`, `keyboard`,
  `mouse`, `multitasking`, `network`, `notifications`, `online-accounts`,
  `power`, `printers`, `privacy`, `search`, `sharing`, `sound`, `system`,
  `universal-access`, `wacom`, `wellbeing`, `wwan`). 5 already exist in
  `lib/`: the panel-shaped `panels/system/about/cc-about-page.c` (ported as
  `lib/gnome_control_center/panels/about_panel.rb`), the two shared utility
  files `panels/common/cc-ui-util.*` / `cc-util.*`
  (`lib/panels/common/ui_util.rb` / `util.rb`), and the two enum headers
  `panels/sharing/gsd-sharing-enums.h` / `panels/sound/cc-sound-enums.h`.
- **shell/**: 9 components, 8 already in `lib/gnome_control_center/`
  (`application`, `log`, `object_storage`, `panel`, `panel_list`,
  `panel_loader`, `shell_model`, `window`); `main.c` is covered by
  `exe/gnome-control-center`; only `shortcuts-dialog.blp` is not yet ported.
  "In `lib/`" is a file-existence count, not a behaviour-parity count —
  `log.rb` and `object_storage.rb` exist and are called at boot
  (`Log.init`, `ObjectStorage.initialize_storage`) but see
  `component-parity.md` for what each actually does once called.
- **global-shortcuts-provider/**: 2 components, 0 in `lib/`.
- **search-provider/**: 2 components, 0 in `lib/`.
- 1 GSettings schema not yet ported.
- 24 GResource manifests: build plumbing, already covered by the panel/shell
  rows above, no separate `lib/` work needed.
- `po/` catalogue (116 locales): no i18n story on `ruby` yet.

**Overall: ~297 upstream components identified, 11 already represented in
`lib/` (3.7%).** The 11 are one genuinely-ported panel (`AboutPanel`, backed
by the invented `system_info.rb`, standing in for
`panels/system/about/cc-about-page.c`), 6 pieces of shell infrastructure
(`application`, `panel`, `panel_list`, `panel_loader`, `shell_model`,
`window`), 2 shared utility files, and 2 enum headers. All 22 other panels'
substantive UI (the panel bodies themselves, and every row/dialog/page/view/
editor under them), both standalone D-Bus service binaries
(`search-provider/`, `global-shortcuts-provider/`), the shell gschema and
i18n catalogue remain to be ported.

Biggest panels by component count: `network` (48), `system` (40),
`common` (26, shared infrastructure used by every panel), `privacy` (22),
`printers` (20), `wacom` (17), `keyboard` (16), `sound` (15).

## Note on an earlier version of this inventory

An earlier commit on `ruby` (`7d61d9e3e`) proposed `lib/panels/<panel>/
<name>_panel.rb` uniformly, including for panel-shaped components. That
conflicts with what was actually committed for `About` —
`lib/gnome_control_center/panels/about_panel.rb` — which this version follows
instead: panel-shaped components (upstream `*-panel.c`, or a page standing in
for one, like `cc-about-page.c`) go to `lib/gnome_control_center/panels/`,
everything else to `lib/panels/<panel>/`. Whoever ports the next panel should
settle this one way and update this file's proposed paths to match.
