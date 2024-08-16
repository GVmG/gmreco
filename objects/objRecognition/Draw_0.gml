///@desc Event
//

draw_set_halign(fa_left);
draw_set_valign(fa_top);

var str=pathIndexToLetter(lastMatch)+" (confidence: "+string_format(1-lastMatchPrecision, 0, 6)+") ["+string_format(lastTime, 0, 6)+"s, "+string(ds_list_size(points))+" points]";
draw_text_transformed_color(5, 5, str, 1, 1, 0, #ffffff, #ffffff, #ffffff, #ffffff, 1);

draw_set_halign(fa_center);
draw_text_transformed_color(192, 5, string_upper(pathIndexToLetter(lastMatch)), 20, 20, 0, #ffffff, #ffffff, #ffffff, #ffffff, 0.2);


for (var i=1; i<ds_list_size(points); i++) {
	var p=points[| i], pp=points[| i-1];
	
	draw_line_width_color(p[0], p[1], pp[0], pp[1], 2, #ff0000, #ff0000);
}
