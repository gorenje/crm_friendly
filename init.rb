require "fat_free_crm"
require 'friendly'

FatFreeCRM::Plugin.register(:crm_friendly, initializer) do
          name "Friendly Plugin for FatFreeCRM"
        author "Gerrit Riessen"
       version "0.1"
   description "The plugin for FatFree for Friendly gem."
end

require File.dirname(__FILE__)+'/lib/crm_friendly.rb'
