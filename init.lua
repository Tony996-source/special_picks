local modpath = minetest.get_modpath("special_picks").. DIR_DELIM

special_picks = {}
dofile(modpath.."admin_pick.lua")

local function table_contains(v, t)
	for _,i in ipairs(t) do
		if i == v then
			return true
		end
	end
	return false
end

local diamond_capabs = minetest.registered_tools["default:pick_diamond"].tool_capabilities

-- Instamine Pick

minetest.register_tool("special_picks:instamine_pick", {
	description = ("Instamine Pick"),
	inventory_image = "special_picks_instamine_pick.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=3,
		groupcaps={
			cracky = {times={[1]=0, [2]=0, [3]=0}, uses=30, maxlevel=3},
		},
		damage_groups = {fleshy=5},
	},
	sound = {breaks = "default_tool_breaks"},
})

minetest.register_craft({
	output = "special_picks:instamine_pick",
	recipe = {
		{"special_picks:pointed_diamond", "special_picks:pointed_diamond", "special_picks:pointed_diamond"},
		{"", "group:stick", ""},
		{"", "group:stick", ""},
	}
})

-- Silk Touch Pick

minetest.register_tool("special_picks:silk_touch_pick", {
	description = "Silk Touch Pickaxe",
	inventory_image = "special_picks_silk_touch_pick.png",
	tool_capabilities = diamond_capabs,
})

local special_tools = {}
local function add_tool(name, func)
	special_tools[name] = func
end

minetest.register_on_dignode(function(_, oldnode, digger)
	if digger == nil then
		return
	end
	local func = special_tools[digger:get_wielded_item():get_name()]
	if func
	and oldnode.name ~= "air" then
		func(digger, oldnode)
	end
end)

add_tool("special_picks:silk_touch_pick", function(digger, oldnode)
	local inv = digger:get_inventory()
	if inv then
		local free_slots = 0
		for _,i in pairs(inv:get_list("main")) do
			if i:get_count() == 0 then
				free_slots = free_slots+1
				break
			end
		end
		if free_slots == 0 then
			return
		end
		local nd = oldnode.name
		local items = minetest.get_node_drops(nd)
		local first_item = items[1]
		if not first_item then
			return
		end
		if first_item == nd then
			return
		end
		for _,item in ipairs(items) do
			inv:remove_item("main", item)
		end
		inv:add_item("main", nd)
	end
end)

minetest.register_craftitem("special_picks:soft_diamond", {
	description = "Soft Diamond",
	inventory_image = "special_picks_soft_diamond.png",
})

minetest.register_craft({
	output = "special_picks:soft_diamond",
	recipe = {
		{"group:wool", "default:coalblock","group:wool"},
		{"default:obsidian", "default:diamond","default:obsidian"},
		{"group:wool", "default:obsidian","group:wool"},
	}
})

minetest.register_craft({
	output = "special_picks:silk_touch_pick",
	recipe = {
		{"special_picks:soft_diamond", "special_picks:soft_diamond", "special_picks:soft_diamond"},
		{"", "group:stick", ""},
		{"", "group:stick", ""},
	}
})

-- Fortune Pick

minetest.register_tool("special_picks:fortune_pick", {
	description = "Fortune Pickaxe",
	inventory_image = "special_picks_fortune_pick.png",
	tool_capabilities = diamond_capabs,
})

local allowed_nodes = {"technic:mineral_sulfur","technic:mineral_lead","technic:mineral_zinc","technic:mineral_chromium","default:mineral_silver","default:mineral_tin","default:mineral_copper", "moreores:mineral_silver","moreores:mineral_mithril","moreores:mineral_tin","default:stone_with_coal","default:stone_with_iron","default:stone_with_copper","default:stone_with_mese", "default:stone_with_gold","default:stone_with_diamond","technic:mineral_chromium","technic:mineral_zinc","technic:mineral_lead","technic:mineral_sulfur","technic:mineral_uranium"}

add_tool("special_picks:fortune_pick", function(digger, oldnode)
	local nam = oldnode.name
	if not table_contains(nam, allowed_nodes) then
		return
	end
	if math.random(6) == 1 then
		return
	end
	local inv = digger:get_inventory()
	if inv then
		local items = minetest.get_node_drops(nam)
		for _,item in ipairs(items) do
			inv:add_item("main", item)
		end
	end
end)

minetest.register_craftitem("special_picks:fortune_diamond", {
	description = "Fortune Diamond",
	inventory_image = "special_picks_fortune_diamond.png",
})

minetest.register_craft({
	output = "special_picks:fortune_diamond",
	recipe = {
		{"moreores:silver_ingot", "moreores:mithril_ingot", "moreores:silver_ingot"},
		{"default:tin_ingot", "default:diamond", "default:tin_ingot"},
		{"technic:wrought_iron_ingot", "moreores:mithril_ingot", "technic:wrought_iron_ingot"},
	}
})

minetest.register_craft({
	output = "special_picks:fortune_pick",
	recipe = {
		{"special_picks:fortune_diamond", "special_picks:fortune_diamond", "special_picks:fortune_diamond"},
		{"", "group:stick", ""},
		{"", "group:stick", ""},
	}
})

minetest.register_craftitem("special_picks:abrasive_paper", {
	description = "Abrasive Paper",
	inventory_image = "special_picks_abrasive_paper.png",
})

minetest.register_craftitem("special_picks:pointed_diamond", {
	description = "Pointed Diamond",
	inventory_image = "special_picks_pointed_diamond.png",
})

minetest.register_craft({
	output = "special_picks:abrasive_paper 3",
	recipe = {
		{"default:sandstone", "default:sandstone", "default:sandstone"},
		{"default:paper", "default:paper", "default:paper"},
	}
})

minetest.register_craft({
	output = "special_picks:pointed_diamond",
	recipe = {
		{"", "special_picks:abrasive_paper", ""},
		{"special_picks:abrasive_paper", "default:diamond", "special_picks:abrasive_paper"},
		{"", "special_picks:abrasive_paper", ""},
	}
})



-- Fire Pick

local capabs = table.copy(diamond_capabs)
capabs.damage_groups.fleshy = capabs.damage_groups.fleshy+1

minetest.register_tool("special_picks:fire_pick", {
	description = "Fire Pickaxe",
	inventory_image = "special_picks_fire_pick.png",
	tool_capabilities = capabs,
})

add_tool("special_picks:fire_pick", function(digger, node)
	local inv = digger:get_inventory()
	if inv then
		local nam = node.name
		local drops = minetest.get_node_drops(nam)
		local result = minetest.get_craft_result({method = "cooking", width = 1, items = drops})["item"]
		if result:is_empty() then
			return
		end
		for _,item in ipairs(drops) do
			inv:remove_item("main", item)
		end
		inv:add_item("main", result)
	end
end)

minetest.register_craftitem("special_picks:hot_diamond", {
	description = "Hot Diamond",
	inventory_image = "special_picks_hot_diamond.png",
})

minetest.register_craft({
	output = "special_picks:hot_diamond",
	recipe = {
		{"default:coalblock", "bucket:bucket_lava", "default:coalblock"},
		{"bucket:bucket_lava", "default:diamond", "bucket:bucket_lava"},
		{"default:coal_lump", "bucket:bucket_lava", "default:coal_lump"},
	},
	replacements = {
		{"default:coalblock", "default:coal_lump 2"},
		{"default:coalblock", "default:coal_lump 2"},
		{"bucket:bucket_lava", "bucket:bucket_empty"},
		{"bucket:bucket_lava", "bucket:bucket_empty"},
		{"bucket:bucket_lava", "bucket:bucket_empty"},
		{"bucket:bucket_lava", "bucket:bucket_empty"},
	}
})

minetest.register_craft({
	output = "special_picks:fire_pick",
	recipe = {
		{"special_picks:hot_diamond", "special_picks:hot_diamond", "special_picks:hot_diamond"},
		{"", "group:stick", ""},
		{"", "group:stick", ""},
	}
})

--Instamine Fortune Pick

minetest.register_tool("special_picks:instafortune_pick", {
	description = "Instamine Fortune Pickaxe",
	inventory_image = "special_picks_instafortune_pick.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=3,
		groupcaps={
			cracky = {times={[1]=0, [2]=0, [3]=0}, uses=30, maxlevel=3},
		},
		damage_groups = {fleshy=5},
	},
	sound = {breaks = "default_tool_breaks"},
})

local nodes = {"technic:mineral_sulfur","technic:mineral_lead","technic:mineral_zinc","technic:mineral_chromium","default:mineral_silver","default:mineral_tin","default:mineral_copper", "moreores:mineral_silver","moreores:mineral_mithril","moreores:mineral_tin","default:stone_with_coal","default:stone_with_iron","default:stone_with_copper","default:stone_with_mese", "default:stone_with_gold","default:stone_with_diamond","technic:mineral_chromium","technic:mineral_zinc","technic:mineral_lead","technic:mineral_sulfur","technic:mineral_uranium"}

add_tool("special_picks:instafortune_pick", function(digger, oldnode)
	local nam = oldnode.name
	if not table_contains(nam, nodes) then
		return
	end
	if math.random(6) == 1 then
		return
	end
	local inv = digger:get_inventory()
	if inv then
		local items = minetest.get_node_drops(nam)
		for _,item in ipairs(items) do
			inv:add_item("main", item)
		end
	end
end)

minetest.register_craft({
	output = "special_picks:instafortune_pick",
	recipe = {
		{"special_picks:fortune_pick", "special_picks:instamine_pick", ""},
		{"", "", ""},
		{"", "", ""},
	}
})

--Instamine Fire Pick

local capabs = table.copy(diamond_capabs)
capabs.damage_groups.fleshy = capabs.damage_groups.fleshy+1

minetest.register_tool("special_picks:instafire_pick", {
	description = "Instamine Fire Pickaxe",
	inventory_image = "special_picks_instafire_pick.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=3,
		groupcaps={
			cracky = {times={[1]=0, [2]=0, [3]=0}, uses=30, maxlevel=3},
		},
		damage_groups = {fleshy=5},
	},
	sound = {breaks = "default_tool_breaks"},
})

add_tool("special_picks:instafire_pick", function(digger, node)
	local inv = digger:get_inventory()
	if inv then
		local nam = node.name
		local drops = minetest.get_node_drops(nam)
		local result = minetest.get_craft_result({method = "cooking", width = 1, items = drops})["item"]
		if result:is_empty() then
			return
		end
		for _,item in ipairs(drops) do
			inv:remove_item("main", item)
		end
		inv:add_item("main", result)
	end
end)

minetest.register_craft({
	output = "special_picks:instafire_pick",
	recipe = {
		{"special_picks:fire_pick", "special_picks:instamine_pick", ""},
		{"", "", ""},
		{"", "", ""},
	}
})

-- Unbreakable Pick

local pick_unbreakable_toolcaps = {
	full_punch_interval = 0.1,
	max_drop_level = 3,
	groupcaps = {
        cracky = {times = {[1] = 2.0, [2] = 0, [3] = 0.50}, uses = 0, maxlevel = 3},
	},
	damage_groups = {fleshy = 5},
}

minetest.register_tool("special_picks:unbreakable_pick", {
	description = ("Unbreakable Pickaxe"),
	range = 20,
	inventory_image = "special_picks_unbreakable_pick.png",
	tool_capabilities = pick_unbreakable_toolcaps,
})

minetest.register_craft({
	output = "special_picks:unbreakable_pick",
	recipe = {
		{"technic:composite_plate", "technic:mixed_metal_ingot", "technic:composite_plate"},
		{"", "group:stick", ""},
		{"", "group:stick", ""},
	}
})

-- Instamine Unbreakable Pick

minetest.register_tool("special_picks:instaunbreakable_pick", {
	description = ("Unbreakable Instamine Pick"),
	inventory_image = "special_picks_instaunbreakable_pick.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=3,
		groupcaps={
		cracky = {times = {[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
		},
		damage_groups = {fleshy=5},
	},
})

minetest.register_craft({
	output = "special_picks:instaunbreakable_pick",
	recipe = {
		{"special_picks:instamine_pick", "special_picks:unbreakable_pick", ""},
		{"", "", ""},
		{"", "", ""},
	}
})

-- Unbreakable Fire Pick

minetest.register_tool("special_picks:unbreakablefire_pick", {
	description = "Unbreakable Fire Pickaxe",
	inventory_image = "special_picks_unbreakablefire_pick.png",
	tool_capabilities = {
	full_punch_interval = 0.9,
	max_drop_level=3,
	groupcaps = {
        cracky = {times = {[1] = 2.0, [2] = 0, [3] = 0.50}, uses = 0, maxlevel = 3},
	},
	damage_groups = {fleshy = 5},
}
})

add_tool("special_picks:unbreakablefire_pick", function(digger, node)
	local inv = digger:get_inventory()
	if inv then
		local nam = node.name
		local drops = minetest.get_node_drops(nam)
		local result = minetest.get_craft_result({method = "cooking", width = 1, items = drops})["item"]
		if result:is_empty() then
			return
		end
		for _,item in ipairs(drops) do
			inv:remove_item("main", item)
		end
		inv:add_item("main", result)
	end
end)

minetest.register_craft({
	output = "special_picks:unbreakablefire_pick",
	recipe = {
		{"special_picks:fire_pick", "special_picks:unbreakable_pick", ""},
		{"", "", ""},
		{"", "", ""},
	}
})

-- Unbreakable Fortune Pick

minetest.register_tool("special_picks:unbreakablefortune_pick", {
	description = "Unbreakable Fortune Pickaxe",
	inventory_image = "special_picks_unbreakablefortune_pick.png",
	tool_capabilities = {
	full_punch_interval = 0.1,
	max_drop_level = 3,
	groupcaps = {
        cracky = {times = {[1] = 2.0, [2] = 0, [3] = 0.50}, uses = 0, maxlevel = 3},
	},
	damage_groups = {fleshy = 5},
}
})

local _node = {"technic:mineral_sulfur","technic:mineral_lead","technic:mineral_zinc","technic:mineral_chromium","default:mineral_silver","default:mineral_tin","default:mineral_copper", "moreores:mineral_silver","moreores:mineral_mithril","moreores:mineral_tin","default:stone_with_coal","default:stone_with_iron","default:stone_with_copper","default:stone_with_mese", "default:stone_with_gold","default:stone_with_diamond","technic:mineral_chromium","technic:mineral_zinc","technic:mineral_lead","technic:mineral_sulfur","technic:mineral_uranium"}

add_tool("special_picks:unbreakablefortune_pick", function(digger, oldnode)
	local nam = oldnode.name
	if not table_contains(nam, _node) then
		return
	end
	if math.random(6) == 1 then
		return
	end
	local inv = digger:get_inventory()
	if inv then
		local items = minetest.get_node_drops(nam)
		for _,item in ipairs(items) do
			inv:add_item("main", item)
		end
	end
end)

minetest.register_craft({
	output = "special_picks:unbreakablefortune_pick",
	recipe = {
		{"special_picks:fortune_pick", "special_picks:unbreakable_pick", ""},
		{"", "", ""},
		{"", "", ""},
	}
})

-- Instamine Unbreakable Fortune Pick

minetest.register_tool("special_picks:instaunbreakablefortune_pick", {
	description = "Unbreakable instamine Fortune Pickaxe",
	inventory_image = "special_picks_instaunbreakablefortune_pick.png",
	tool_capabilities = {
	full_punch_interval = 0.1,
	max_drop_level = 3,
	groupcaps = {
        cracky = {times = {[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
	},
	damage_groups = {fleshy = 5},
}
})

local node = {"technic:mineral_sulfur","technic:mineral_lead","technic:mineral_zinc","technic:mineral_chromium","default:mineral_silver","default:mineral_tin","default:mineral_copper", "moreores:mineral_silver","moreores:mineral_mithril","moreores:mineral_tin","default:stone_with_coal","default:stone_with_iron","default:stone_with_copper","default:stone_with_mese", "default:stone_with_gold","default:stone_with_diamond","technic:mineral_chromium","technic:mineral_zinc","technic:mineral_lead","technic:mineral_sulfur","technic:mineral_uranium"}

add_tool("special_picks:instaunbreakablefortune_pick", function(digger, oldnode)
	local nam = oldnode.name
	if not table_contains(nam, node) then
		return
	end
	if math.random(6) == 1 then
		return
	end
	local inv = digger:get_inventory()
	if inv then
		local items = minetest.get_node_drops(nam)
		for _,item in ipairs(items) do
			inv:add_item("main", item)
		end
	end
end)

minetest.register_craft({
	output = "special_picks:instaunbreakablefortune_pick",
	recipe = {
		{"special_picks:fortune_pick", "special_picks:unbreakable_pick", "special_picks:instamine_pick"},
		{"", "", ""},
		{"", "", ""},
	}
})

-- Instamine Unbreakable Fire Pick

minetest.register_tool("special_picks:instaunbreakablefire_pick", {
	description = "Instamine Unbreakable Fire Pickaxe",
	inventory_image = "special_picks_instaunbreakablefire_pick.png",
	tool_capabilities = {
	full_punch_interval = 0.9,
	max_drop_level=3,
	groupcaps = {
        cracky = {times = {[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
	},
	damage_groups = {fleshy = 5},
}
})

add_tool("special_picks:instaunbreakablefire_pick", function(digger, node)
	local inv = digger:get_inventory()
	if inv then
		local nam = node.name
		local drops = minetest.get_node_drops(nam)
		local result = minetest.get_craft_result({method = "cooking", width = 1, items = drops})["item"]
		if result:is_empty() then
			return
		end
		for _,item in ipairs(drops) do
			inv:remove_item("main", item)
		end
		inv:add_item("main", result)
	end
end)

minetest.register_craft({
	output = "special_picks:instaunbreakablefire_pick",
	recipe = {
		{"special_picks:fire_pick", "special_picks:unbreakable_pick", "special_picks:instamine_pick"},
		{"", "", ""},
		{"", "", ""},
	}
})
