require("setting")
require("controller")

function main()
    initialize_robot()
    while current_layer <= max_layers do
        process_box()
        update_counters()
    end
    finish_pallet()
end