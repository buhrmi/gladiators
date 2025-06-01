class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  use_inertia_instance_props

  rescue_from ActiveRecord::RecordInvalid do |exception|
    raise exception unless request.inertia?

    redirect_back inertia: {
      errors: exception.record.errors
    }
  end

  rescue_from ActionController::BadRequest do |exception|
    flash[:error] = exception.message
    redirect_back(fallback_location: root_path)
  end

  inertia_share do
    {
      flash: flash.to_h,
      character_sgid: current_character&.to_sgid_param
    }
  end

  def inertia_referer
    request.headers["X-Inertia-Frame-Src"] || request.referer
  end

  def redirect_back(fallback_location: root_path, **args)
    if request.inertia?
      redirect_to inertia_referer || fallback_location, **args
    else
      super
    end
  end

  def only_on_initial_request(value)
    value unless request.inertia?
  end

  def current_character
    return unless session[:character_id]
    Current.character ||= Character.find_by(id: session[:character_id])
  end

  def launch_in_modal(root = root_path)
    return if request.inertia?
    flash[:modal] = request.fullpath
    redirect_to root
  end
end
