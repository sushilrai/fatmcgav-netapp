require 'puppet/provider/netapp'

Puppet::Type.type(:netapp_igroup_create_destroy).provide(:netapp_igroup_create_destroy, :parent => Puppet::Provider::Netapp) do
  @doc = "Manage Netapp iGroup create/destroy operations."

  confine :feature => :posix
  defaultfor :feature => :posix
 
  netapp_commands :igrouplist     => 'igroup-list-info'
  netapp_commands :igroupcreate   => 'igroup-create'
  netapp_commands :igroupdestroy  => 'igroup-destroy'
  

 def get_igroup_status  

    igroup_status = 'false'
    Puppet.debug("Fetching iGroup information")
     begin
       result = igrouplist("initiator-group-name", @resource[:name])
       Puppet.debug(" iGroup informations - #{result}")
      rescue   
     
      end
	
      if (result != nil)
        igroup_status = 'true'
      end
	  
    return igroup_status  
       
  end

  def get_create_command 
    arguments = ["initiator-group-name", @resource[:name], "initiator-group-type", @resource[:initiatorgrouptype]]
     if ((@resource[:bindportset]!= nil) && (@resource[:bindportset].length > 0))
       arguments +=["bind-portset", @resource[:bindportset]] 
     end

     if ((@resource[:ostype]!= nil) && (@resource[:ostype].length > 0))
       arguments +=["os-type", @resource[:ostype]] 
     end
	 
    return arguments
  end

  def get_destroy_command 
    arguments = ["initiator-group-name", @resource[:name]]
     if @resource[:force] == :true
       arguments +=["force", @resource[:force]] 
     end
	 
    return arguments
  end

  def create   
    Puppet.debug("Inside create method.")
    igroupcreate(*get_create_command)
    igroup_status = get_igroup_status
    Puppet.debug("iGroup existence status after executing create operation - #{igroup_status}")
  end

  def destroy  
    Puppet.debug("Inside destroy method.")
    igroupdestroy(*get_destroy_command)
    igroup_status = get_igroup_status
    Puppet.debug("iGroup existence status after executing destroy operation - #{igroup_status}")
  end

 def exists?
    Puppet.debug("Inside exists method.")
    igroup_status = get_igroup_status
    if  "#{igroup_status}" == "false"
      Puppet.debug("iGroup existence status before executing any create/destroy operation - #{igroup_status}")
      false
    else
      Puppet.debug("iGroup existence status before executing any create/destroy operation - #{igroup_status}")
      true
    end

    end

end


