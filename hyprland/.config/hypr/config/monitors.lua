------------------
---- MONITORS ----
------------------

-- configuration of the main HDR gamer monitor
hl.monitor({
	-- base arguments - FIX order
	output = "DP-1",
	mode = "2560x1440@180",
	position = "1440x720",
	scale = "1",
	-- optional extra arguments - any order
	vrr = 3,
	-- bitdepth = 10, -- comment this out is a workaround for failing restore SDR after exiting a HDR fullscreen app
	cm = "auto",
	supports_wide_color = 1,
	supports_hdr = 1,
	sdr_min_luminance = 0.005,
	sdr_max_luminance = 250,
	max_luminance = 1000,
	max_avg_luminance = 400,
})

-- configuration of the secondary SDR monitor, vertical on the left of the main monitor
hl.monitor({
	-- base arguments - FIX order
	output = "DP-2",
	mode = "2560x1440@144",
	position = "0x0",
	scale = "1",
	-- optional extra arguments - any order
	transform = 3,
	vrr = 0,
	bitdepth = 8,
	cm = "srgb",
})

-- configuration of the color management, to handle auto switch in case of HDR content
hl.config({
	render = {
		--    cm_fs_passthrough = 0 # bypass wayland ColorManagement pipeline (0:off | 1:always ON for fullscreen apps | 2:ON only for HDR fullscreen apps)
		cm_auto_hdr = 2, -- auto switch to HDR for fullscreen app (0:off | 1:on to HDR | 2:on to HDREDID)
		direct_scanout = 0, -- change to 1, to improve performance by scanning out buffers directly when possible
	},
})
