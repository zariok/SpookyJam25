shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    // Get the original color from the sprite's texture
    vec4 original_color = texture(TEXTURE, UV);
    
    // Calculate the grayscale value (this is a standard formula for luminance)
    float gray = dot(original_color.rgb, vec3(0.299, 0.587, 0.114));
    
    // Set the final color to be the gray value for R, G, and B
    // Keep the original transparency (alpha)
    COLOR = vec4(gray, gray, gray, original_color.a);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
