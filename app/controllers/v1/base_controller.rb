class V1::BaseController < ApplicationController
  protected

  def update_trash(instance, state)
    return invalid_authorization unless authorize(:admin)
    
    if instance.update(trash: state)
      render json: instance
    else
      render json: instance.errors, status: :unprocessable_entity
    end
  end

  def update_trashes(instance, state)
    return invalid_authorization unless authorize(:admin)
    
    if instance.update(trash: state)
      return true
    else
      return false
    end
  end
  
end
