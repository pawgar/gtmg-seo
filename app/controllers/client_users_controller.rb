class ClientUsersController < ApplicationController
    
    before_action :admin_only 
    
    
    def add_as_owner
        if ClientUser.update(params[:id], user_role: 1)
            flash[:notice] = "Successfully added as owner!"
        else
            flash[:notice] = "Error!"
        end
        redirect_to :back
    end
    
    def remove_as_owner
        if ClientUser.update(params[:id], user_role: 0)
            flash[:notice] = "Successfully remove ownership!"
        else
            flash[:notice] = "Error!"
        end
        redirect_to :back
    end
    
end
