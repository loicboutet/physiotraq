module Mockups
  class BaseController < ApplicationController
    # Skip authentication for all mockup pages
    skip_before_action :authenticate_user!, raise: false
    
    # Base controller for all mockup pages
    # Provides common layout selection logic
    
    layout :resolve_layout
    
    private
    
    # Determine which layout to use based on controller/action
    # Override in child controllers if needed
    def resolve_layout
      "application"
    end
  end
end
