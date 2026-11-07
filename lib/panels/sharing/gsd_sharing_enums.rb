# frozen_string_literal: true

module GnomeControlCenter
  module Panels
    module Sharing
      # Ported from upstream's panels/sharing/gsd-sharing-enums.h.
      module SharingStatus
        OFFLINE = :offline
        DISABLED_MOBILE_BROADBAND = :disabled_mobile_broadband
        DISABLED_LOW_SECURITY = :disabled_low_security
        AVAILABLE = :available
      end
    end
  end
end
