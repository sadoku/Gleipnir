-- Hej
MODULE.Vehicles = {
	jeep = {
		script = "jeep_test",
		model = "models/buggy.mdl",
		Seats = {
			{pos = Vector(15,-35,20), visible = true, model = "models/nova/jeep_seat.mdl"}
		},
		Headlights = {
			{pos = Vector(10, 60, 40)},
			{pos = Vector(-10, 60, 40)}
		},
		fuel = 100
	},
	hummer = {
		script = "hmrh2",
		model = "models/sickness/hummer-h2.mdl",
		Seats = {
			{pos = Vector(20, -14, 25)},
			{pos = Vector(20, 20, 23)},
			{pos = Vector(-20, -14, 25)}
		}
	}
}
