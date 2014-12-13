
--  DOCUMENTATION: mg_villages.village_type_data has entries in the following form:
--      key = { data values }   with key beeing the name of the village type
--  meaning of the data values:
--      min, max: the village size will be choosen randomly between these two values;
--                the actual village will have a radius about twice as big (including sourrounding area)
--      space_between_buildings=2  How much space is there between the buildings. 1 or 2 are good values.
--                The higher, the further the buildings are spread apart.
--      mods = {'homedecor','moreblocks'} List of mods that are required for the buildings of this village type.
--                List all the mods the blocks used by your buildings which are not in default.
--      texture = 'wool_white.png'        Texture used to show the location of the village when using the
--                vmap  command.
--      name_prefix = 'Village ',
--      name_postfix = ''                 When creating village names for single houses which are spawned outside
--                of villages, the village name will consist of  name_prefix..village_name..name_postfix


local village_type_data_list = {
	nore         = { min = 20, max = 40,   space_between_buildings=1, mods={},            texture = 'default_stone_brick.png'},
	taoki        = { min = 30, max = 70,   space_between_buildings=1, mods={},            texture = 'default_brick.png' },
	medieval     = { min = 25, max = 60,   space_between_buildings=2, mods={'cottages'},  texture = 'cottages_darkage_straw.png'}, -- they often have straw roofs
	charachoal   = { min = 10, max = 15,   space_between_buildings=1, mods={'cottages'},  texture = 'default_coal_block.png'},
	lumberjack   = { min = 10, max = 30,   space_between_buildings=1, mods={'cottages'},  texture = 'default_tree.png', name_prefix = 'Camp '},
	claytrader   = { min = 10, max = 20,   space_between_buildings=1, mods={'cottages'},  texture = 'default_clay.png'},
	logcabin     = { min = 15, max = 30,   space_between_buildings=1, mods={'cottages'},  texture = 'default_wood.png'},
	canadian     = { min = 40, max = 110,  space_between_buildings=1, mods={'hdb','nbu'}, texture = 'wool_white.png'},
	grasshut     = { min = 10, max = 40,   space_between_buildings=1, mods={'dryplants'}, texture = 'dryplants_reed.png'},
	tent         = { min =  5, max = 20,   space_between_buildings=2, mods={'cottages'},  texture = 'wool_white.png', name_preifx = 'Tent at'},

	-- these sub-types may occour as single houses placed far from villages
	tower        = { only_single = 1, name_prefix = 'Tower at ',      mods={'cottages'},  texture = 'default_mese.png'},
	chateau      = { only_single = 1, name_prefix = 'Chateau ',                           texture = 'default_gold_block.png'},
	forge        = { only_single = 1, name_prefix = 'Forge at '},
	tavern       = { only_single = 1, name_prefix = 'Inn at '},
	well         = { only_single = 1, name_prefix = 'Well at '},
	trader       = { only_single = 1, name_prefix = 'Trading post ' },
	sawmill      = { only_single = 1, name_prefix = 'Sawmill at ' },
	farm_tiny    = { only_single = 1, name_prefix = 'House '},
	farm_full    = { only_single = 1, name_prefix = 'Farm '},
	single       = { only_single = 1, name_prefix = 'House '}, -- fallback
}

-- NOTE: Most values of village types added with mg_villages.add_village_type can still be changed later on by
--       changing the global variable mg_villages.village_type_data[ village_type ]
--       Village types where one or more of the required mods (listed in v.mods) are missing will not be
--       available.
-- You can add your own village type by i.e. calling
--         mg_villages.add_village_type( 'town', { min = 10, max = 30, space_between_buildings = 2, mods = {'moreblocks','homedecor'}, texture='default_diamond_block.png'} );
--   This will add a new village type named 'town', which will only be available if the mods moreblocks and homedecor are installed.
--   It will show the texture of the diamond block when showing the position of a village of that type in the map displayed by the /vmap command.
      

-- some villages require special mods as building material for their houses;
-- figure out which village types can be used 
mg_villages.add_village_type = function( type_name, v )
	local found = true;
	if( not( v.mods )) then
		v.mods = {};
	end
	for _,m in ipairs( v.mods ) do
		if( not( minetest.get_modpath( m ))) then
			-- this village type will not be used because not all required mods are installed
			return false;
		end
	end

	if( not( v.only_single ) and (not(v.min) or not(v.max))) then
		print('[mg_villages] Error: Village type '..tostring( type_name )..' lacks size information.');
		return false;
	end
	-- this village type is supported by the mods installed and may be used
	v.supported = 1;

	mg_villages.village_type_data[ type_name ] = v;
	return true;
end


-- build a list of all useable village types the mg_villages mod comes with
mg_villages.village_type_data = {};
for k,v in pairs( village_type_data_list ) do
	mg_villages.add_village_type( k, v );
end
village_type_data_list = nil;
