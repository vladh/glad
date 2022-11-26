export type gl_enum = uint;
export type gl_bitfield = uint;

export type GLDEBUGPROC = nullable *fn(
	source: gl_enum,
	type_: gl_enum,
	id: uint,
	severity: gl_enum,
	length: i32,
	message: nullable *const char,
	userParam: nullable *void
) void;
export type GLDEBUGPROCARB = nullable *fn(
	source: gl_enum,
	type_: gl_enum,
	id: uint,
	severity: gl_enum,
	length: i32,
	message: nullable *const char,
	userParam: nullable *void
) void;
export type GLDEBUGPROCKHR = nullable *fn(
	source: gl_enum,
	type_: gl_enum,
	id: uint,
	severity: gl_enum,
	length: i32,
	message: nullable *const char,
	userParam: nullable *void
) void;
export type GLDEBUGPROCAMD = nullable *fn(
	id: uint,
	category: gl_enum,
	severity: gl_enum,
	length: i32,
	message: nullable *const char,
	userParam: nullable *void
) void;
export type GLVULKANPROCNV = nullable *fn() void;
