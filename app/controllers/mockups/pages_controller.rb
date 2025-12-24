module Mockups
  class PagesController < BaseController
    layout :resolve_layout
    
    # Index - lists all available mockups
    def index
      # Uses application layout
    end
    
    # ==================
    # AUTH PAGES
    # ==================
    def login
    end
    
    def signup
    end
    
    # ==================
    # ADMIN PAGES
    # ==================
    def admin_dashboard
    end
    
    def admin_devices
    end
    
    def admin_device_detail
    end
    
    def admin_team
    end
    
    def admin_billing
    end
    
    def admin_treatments
    end
    
    # ==================
    # OPERATOR PAGES
    # ==================
    def operator_dashboard
    end
    
    def operator_monitor
    end
    
    def operator_new_treatment
    end
    
    def operator_treatments
    end
    
    def operator_treatment_detail
    end
    
    private
    
    def resolve_layout
      case action_name
      when "index"
        "application"
      when /^admin_/
        "mockup_admin"
      when /^operator_/
        "mockup_operator"
      else
        "mockup_auth"
      end
    end
  end
end
