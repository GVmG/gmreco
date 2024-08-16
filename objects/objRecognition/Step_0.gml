///@desc Event
//

if (mouse_check_button_pressed(mb_left)) {
	ds_list_clear(points);
}

if (mouse_check_button(mb_left)) {
	var p=[mouse_x, mouse_y];
	if (point_distance(p[0], p[1], pp[0], pp[1])>minPointDist) {
		ds_list_add(points, p);
		pp=p;
	}
}

if (mouse_check_button_released(mb_left)) {
	var tim=get_timer();
	var res=checkAgainstPaths(points, false);
	lastTime=(get_timer()-tim)/1000000;
	
	lastMatch=res[0];
	lastMatchPrecision=res[1];
}

