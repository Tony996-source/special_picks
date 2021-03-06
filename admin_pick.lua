
 local pick_admin_toolcaps = {
	full_punch_interval = 0.1,
	max_drop_level = 3,
	groupcaps = {
		unbreakable = {times = {[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
		fleshy = {times = {[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
		choppy = {times = {[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
		bendy = {times = {[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
		cracky = {times = {[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
		crumbly = {times = {[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
		snappy = {times = {[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
	},
	damage_groups = {fleshy = 1000},
}

minetest.register_tool("special_picks:pick_admin", {
	description = ("Admin Pickaxe"),
	range = 20,
	inventory_image = "maptools_adminpick.png",
	tool_capabilities = pick_admin_toolcaps,
	groups = {not_in_creative_inventory=1},
})

minetest.register_tool("special_picks:admin_with_drops", {
	description = ("Admin Pickaxe with Drops"),
	range = 20,
	inventory_image = "maptools_adminpick_with_drops.png",
	tool_capabilities = pick_admin_toolcaps,
	groups = {not_in_creative_inventory=1},
})

minetest.register_on_punchnode(function(pos, node, puncher)
	if puncher:get_wielded_item():get_name() == "special_picks:pick_admin"
	and minetest.get_node(pos).name ~= "air" then
		minetest.log(
			"action",
			puncher:get_player_name() ..
			" digs " ..
			minetest.get_node(pos).name ..
			" at " ..
			minetest.pos_to_string(pos) ..
			" using an Admin Pickaxe."
		)
		-- The node is removed directly, which means it even works
		-- on non-empty containers and group-less nodes
		minetest.remove_node(pos)
		-- Run node update actions like falling nodes
		minetest.check_for_falling(pos)
	end
end)
