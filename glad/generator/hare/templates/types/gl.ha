export type gl_enum = uint;
export type gl_bitfield = uint;

export type GLDEBUGPROC = fn(
	source: gl_enum,
	type_: gl_enum,
	id: uint,
	severity: gl_enum,
	length: i32,
	message: *const i8,
	userParam: *void
) void;
export type GLDEBUGPROCARB = fn(
	source: gl_enum,
	type_: gl_enum,
	id: uint,
	severity: gl_enum,
	length: i32,
	message: *const i8,
	userParam: *void
) void;
export type GLDEBUGPROCKHR = fn(
	source: gl_enum,
	type_: gl_enum,
	id: uint,
	severity: gl_enum,
	length: i32,
	message: *const i8,
	userParam: *void
) void;
export type GLDEBUGPROCAMD = fn(
	id: uint,
	category: gl_enum,
	severity: gl_enum,
	length: i32,
	message: *const i8,
	userParam: *void
) void;
export type GLVULKANPROCNV = fn() void;
