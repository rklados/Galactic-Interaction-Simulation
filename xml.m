classdef xml
    %XML Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        item_store;
    end
    
    methods
       
        function item = xml(num_obj)
          item.item_store = zeros(num_obj, 4);
        end
        function newItem(item, type, number, x)
           
        end
        function write(item)
        end
       
    end
    
end

