module ApplicationHelper
    def current_user
        @current_user ||= User.find(params[:id])
    end

    def not_authorized
        render json: { error: 'Not Authorized' }, status: :unauthorized
    end
end
